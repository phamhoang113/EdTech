import React, { useState, useEffect, useRef } from 'react';
import { X, Plus, Trash2, AlertCircle, MapPin, Clock } from 'lucide-react';
import './RequestClassModal.css';
import apiClient from '../../services/apiClient';
import { parentApi } from '../../services/parentApi';
import { useEscapeKey } from '../../hooks/useEscapeKey';

/* ── Types ───────────────────────────────────────────────────────────────── */
interface LevelFeeRow {
  level: string;
  fee: number;
}

interface Filters {
  subjects: string[];
  levels: string[];
  tutorLevels: string[];
  genders: string[];
}

interface TimeSlot { start: number; end: number; }
interface CaSchedule { ca: string; days: string[]; slots: TimeSlot[]; }

/* ── Constants ───────────────────────────────────────────────────────────── */
const DAY_LABELS = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
const DAY_VALUES = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

const CA_CONFIG: Record<string, { label: string; emoji: string; range: string; color: string; startMin: number; endMin: number }> = {
  Sáng:  { label: 'Ca sáng',  emoji: '🌅', range: '6:00 – 11:30',  color: '#f59e0b', startMin: 360,  endMin: 690  },
  Chiều: { label: 'Ca chiều', emoji: '☀️', range: '12:00 – 17:30', color: '#6366f1', startMin: 720,  endMin: 1050 },
  Tối:   { label: 'Ca tối',   emoji: '🌙', range: '18:00 – 21:30', color: '#8b5cf6', startMin: 1080, endMin: 1290 },
};

/* ── Helpers ─────────────────────────────────────────────────────────────── */
function fmtCurrency(n: number) { return n.toLocaleString('vi-VN') + ' ₫'; }
function toHHMM(m: number): string {
  const h = Math.floor(m / 60).toString().padStart(2, '0');
  const mm = (m % 60).toString().padStart(2, '0');
  return `${h}:${mm}`;
}
function buildMinOptions(startMin: number, endMin: number, step = 30): number[] {
  const opts: number[] = [];
  for (let m = startMin; m <= endMin; m += step) opts.push(m);
  return opts;
}
function getDefaultFee(levelName: string): number {
  const lower = levelName.toLowerCase();
  if (lower.includes('sinh viên') || lower.includes('sv')) return 1_600_000;
  if (lower.includes('giáo viên') || lower.includes('gv')) return 2_800_000;
  if (lower.includes('gstn') || lower.includes('tiểu học') || lower.includes('trung học') || lower.includes('gia sư'))
    return 2_200_000;
  return 2_000_000;
}
function hasConflict(slots: TimeSlot[], cur: number): boolean {
  return slots.some((s, i) => i !== cur && s.start < slots[cur].end && s.end > slots[cur].start);
}

/* ══════════════════════════════════════════════════════════════════════════
   Map Address Picker (OpenStreetMap + Leaflet + Nominatim — no API key)
══════════════════════════════════════════════════════════════════════════ */
declare global {
  interface Window { google?: unknown; initGoogleMaps?: () => void; }
}

function loadLeaflet(): Promise<void> {
  return new Promise(resolve => {
    if ((window as { L?: unknown }).L) { resolve(); return; }
    if (!document.getElementById('leaflet-css')) {
      const css = document.createElement('link');
      css.id = 'leaflet-css'; css.rel = 'stylesheet';
      css.href = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css';
      document.head.appendChild(css);
    }
    if (document.getElementById('leaflet-js')) {
      const check = setInterval(() => { if ((window as { L?: unknown }).L) { clearInterval(check); resolve(); } }, 50);
      return;
    }
    const script = document.createElement('script');
    script.id = 'leaflet-js';
    script.src = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.js';
    script.onload = () => resolve();
    document.head.appendChild(script);
  });
}

interface NominatimResult { display_name: string; lat: string; lon: string; }

async function reverseGeocode(lat: number, lon: number): Promise<string> {
  const res = await fetch(
    `https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${lat}&lon=${lon}&accept-language=vi`,
    { headers: { 'User-Agent': 'EdTech/1.0' } }
  );
  const data = await res.json() as { display_name?: string };
  return data.display_name ?? `${lat.toFixed(6)}, ${lon.toFixed(6)}`;
}

async function searchAddress(q: string): Promise<NominatimResult[]> {
  const res = await fetch(
    `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(q)}&countrycodes=vn&limit=5&accept-language=vi`,
    { headers: { 'User-Agent': 'EdTech/1.0' } }
  );
  return res.json() as Promise<NominatimResult[]>;
}

function MapPickerModal({ onClose, onSelect, initialAddress }: {
  onClose: () => void;
  onSelect: (address: string) => void;
  initialAddress: string;
}) {
  const mapRef = useRef<HTMLDivElement>(null);
  const mapInstanceRef = useRef<unknown>(null);
  const markerRef = useRef<unknown>(null);
  const [currentAddress, setCurrentAddress] = useState(initialAddress || 'Chưa chọn vị trí');
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState<NominatimResult[]>([]);
  const [searching, setSearching] = useState(false);
  const [loading, setLoading] = useState(true);
  const DEFAULT_LAT = 10.7769; const DEFAULT_LNG = 106.7009;

  useEffect(() => {
    let cancelled = false;
    loadLeaflet().then(() => {
      if (cancelled || !mapRef.current || mapInstanceRef.current) return;
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const L = (window as any).L;
      const map = L.map(mapRef.current).setView([DEFAULT_LAT, DEFAULT_LNG], 13);
      mapInstanceRef.current = map;
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors', maxZoom: 19,
      }).addTo(map);
      const icon = L.icon({
        iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
        iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
        shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
        iconSize: [25, 41], iconAnchor: [12, 41], popupAnchor: [1, -34],
      });
      const marker = L.marker([DEFAULT_LAT, DEFAULT_LNG], { icon, draggable: true }).addTo(map);
      markerRef.current = marker;
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      map.on('click', async (e: any) => {
        const { lat, lng } = e.latlng;
        marker.setLatLng([lat, lng]);
        setCurrentAddress(await reverseGeocode(lat, lng));
      });
      marker.on('dragend', async () => {
        const { lat, lng } = marker.getLatLng();
        setCurrentAddress(await reverseGeocode(lat, lng));
      });
      setLoading(false);
    });
    return () => { cancelled = true; };
  }, []);

  const handleSearch = async () => {
    if (!searchQuery.trim()) return;
    setSearching(true);
    try { setSearchResults(await searchAddress(searchQuery)); }
    finally { setSearching(false); }
  };

  const handleSelectResult = async (r: NominatimResult) => {
    const lat = parseFloat(r.lat); const lng = parseFloat(r.lon);
    if (mapInstanceRef.current && markerRef.current) {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (mapInstanceRef.current as any).setView([lat, lng], 16);
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (markerRef.current as any).setLatLng([lat, lng]);
    }
    setCurrentAddress(r.display_name);
    setSearchResults([]); setSearchQuery('');
  };

  return (
    <div className="ap-overlay" onClick={onClose}>
      <div className="rcm-map-modal" onClick={e => e.stopPropagation()}>
        <div className="rcm-map-header">
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
              <MapPin size={18} style={{ color: '#6366f1' }}/>
              <span style={{ fontWeight: 800, fontSize: '0.95rem' }}>Chọn địa chỉ trên bản đồ</span>
            </div>
            <button onClick={onClose} className="rcm-close"><X size={18}/></button>
          </div>
          <div className="rcm-map-search-row">
            <input
              className="rcm-input"
              style={{ flex: 1 }}
              value={searchQuery}
              onChange={e => setSearchQuery(e.target.value)}
              onKeyDown={e => { if (e.key === 'Enter') handleSearch(); }}
              placeholder="Tìm kiếm địa chỉ... (Enter)"
            />
            <button onClick={handleSearch} disabled={searching} className="rcm-map-search-btn">
              {searching ? '...' : 'Tìm'}
            </button>
            {searchResults.length > 0 && (
              <div className="rcm-map-results">
                {searchResults.map((r, i) => (
                  <button key={i} className="rcm-map-result-item" onClick={() => handleSelectResult(r)}>
                    <MapPin size={11} style={{ marginRight: 6, color: '#6366f1' }}/>{r.display_name}
                  </button>
                ))}
              </div>
            )}
          </div>
        </div>
        <div className="rcm-map-area">
          {loading && <div className="rcm-map-loading">🗺️ Đang tải bản đồ...</div>}
          <div ref={mapRef} style={{ width: '100%', height: '100%', minHeight: 340 }}/>
        </div>
        <div className="rcm-map-footer">
          <div className="rcm-map-addr-label">Địa chỉ đã chọn:</div>
          <div className="rcm-map-addr-value"><MapPin size={12} style={{ marginRight: 5 }}/>{currentAddress}</div>
          <div className="rcm-map-actions">
            <button onClick={onClose} className="rcm-btn-cancel" style={{ flex: 1 }}>Huỷ</button>
            <button
              onClick={() => { onSelect(currentAddress); onClose(); }}
              className="rcm-btn-submit" style={{ flex: 2 }}
            >
              ✓ Xác nhận địa chỉ này
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

function MapAddressInput({ value, onChange }: { value: string; onChange: (v: string) => void }) {
  const [query, setQuery] = useState(value);
  const [suggestions, setSuggestions] = useState<NominatimResult[]>([]);
  const [loading, setLoading] = useState(false);
  const [focused, setFocused] = useState(false);
  const [showMap, setShowMap] = useState(false);
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const containerRef = useRef<HTMLDivElement>(null);

  // Sync external value → input
  useEffect(() => { setQuery(value); }, [value]);

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClick = (e: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setFocused(false);
      }
    };
    document.addEventListener('mousedown', handleClick);
    return () => document.removeEventListener('mousedown', handleClick);
  }, []);

  const handleInput = (text: string) => {
    setQuery(text);
    onChange(text);
    if (debounceRef.current) clearTimeout(debounceRef.current);
    if (text.trim().length < 3) { setSuggestions([]); return; }

    debounceRef.current = setTimeout(async () => {
      setLoading(true);
      try {
        const results = await searchAddress(text);
        setSuggestions(results);
      } catch { setSuggestions([]); }
      finally { setLoading(false); }
    }, 400);
  };

  const handleSelect = (r: NominatimResult) => {
    setQuery(r.display_name);
    onChange(r.display_name);
    setSuggestions([]);
    setFocused(false);
  };

  const showDropdown = focused && (loading || suggestions.length > 0);

  return (
    <>
      <div ref={containerRef} className="rcm-autocomplete-wrap">
        <div className="rcm-autocomplete-input-row">
          <MapPin size={14} className="rcm-address-icon"/>
          <input
            className="rcm-input"
            style={{ paddingLeft: 34, paddingRight: 72 }}
            value={query}
            onChange={e => handleInput(e.target.value)}
            onFocus={() => setFocused(true)}
            placeholder="Nhập địa chỉ để tìm kiếm..."
            autoComplete="off"
          />
          {loading && (
            <span className="rcm-autocomplete-loading">🔍</span>
          )}
          <button
            type="button"
            className="rcm-map-pin-btn"
            onClick={() => setShowMap(true)}
            title="Chọn trên bản đồ"
          >
            🗺️
          </button>
        </div>

        {showDropdown && (
          <div className="rcm-suggestions">
            {loading && suggestions.length === 0 && (
              <div className="rcm-suggestion-loading">Đang tìm kiếm...</div>
            )}
            {suggestions.map((r, i) => {
              // Highlight phần tên đầu (trước dấu phẩy đầu tiên)
              const parts = r.display_name.split(',');
              const main = parts[0];
              const sub  = parts.slice(1).join(',').trim();
              return (
                <button
                  key={i}
                  type="button"
                  className="rcm-suggestion-item"
                  onMouseDown={() => handleSelect(r)}  // mousedown để không mất focus trước
                >
                  <MapPin size={12} className="rcm-suggestion-icon"/>
                  <span className="rcm-suggestion-text">
                    <span className="rcm-suggestion-main">{main}</span>
                    {sub && <span className="rcm-suggestion-sub">, {sub}</span>}
                  </span>
                </button>
              );
            })}
          </div>
        )}
      </div>

      {showMap && (
        <MapPickerModal
          initialAddress={value}
          onSelect={addr => { setQuery(addr); onChange(addr); }}
          onClose={() => setShowMap(false)}
        />
      )}
    </>
  );
}

/* ══════════════════════════════════════════════════════════════════════════
   Session / Ca dạy Picker
══════════════════════════════════════════════════════════════════════════ */
function SlotRow({ slot, idx, caKey, caMin, caMax, allSlots, onUpdate, onRemove }: {
  slot: TimeSlot; idx: number; caKey: string;
  caMin: number; caMax: number; allSlots: TimeSlot[];
  onUpdate: (s: TimeSlot) => void; onRemove: () => void;
}) {
  const startOpts = buildMinOptions(caMin, caMax - 30);
  const endOpts   = buildMinOptions(caMin + 30, caMax);
  const conflict  = hasConflict(allSlots, idx);
  void caKey;
  return (
    <div className={`rcm-slot-row${conflict ? ' has-conflict' : ''}`}>
      <Clock size={13} style={{ color: 'var(--color-text-muted)', flexShrink: 0 }}/>
      <select className="rcm-slot-select" value={slot.start}
        onChange={e => onUpdate({ start: Number(e.target.value), end: Math.max(slot.end, Number(e.target.value) + 30) })}>
        {startOpts.map(m => <option key={m} value={m}>{toHHMM(m)}</option>)}
      </select>
      <span className="rcm-slot-sep">→</span>
      <select className="rcm-slot-select" value={slot.end}
        onChange={e => onUpdate({ ...slot, end: Number(e.target.value) })}>
        {endOpts.filter(m => m > slot.start).map(m => <option key={m} value={m}>{toHHMM(m)}</option>)}
      </select>
      {conflict && <span className="rcm-slot-conflict">⚠ Trùng</span>}
      <button type="button" className="rcm-slot-del" onClick={onRemove}><Trash2 size={13}/></button>
    </div>
  );
}

function CaAccordion({ caKey, value, onChange, sessionDurationMin }: {
  caKey: string; value: CaSchedule;
  onChange: (v: CaSchedule) => void;
  sessionDurationMin: number;
}) {
  const cfg = CA_CONFIG[caKey];
  const [open, setOpen] = useState(false);
  const hasData = value.days.length > 0 || value.slots.length > 0;

  const toggleDay = (day: string) => {
    const days = value.days.includes(day) ? value.days.filter(d => d !== day) : [...value.days, day];
    onChange({ ...value, days });
  };

  const addSlot = () => {
    const last = value.slots[value.slots.length - 1];
    const start = last ? Math.min(last.end, cfg.endMin - sessionDurationMin) : cfg.startMin;
    const end   = Math.min(start + sessionDurationMin, cfg.endMin);
    onChange({ ...value, slots: [...value.slots, { start, end }] });
  };

  const updateSlot = (idx: number, s: TimeSlot) => {
    const slots = [...value.slots]; slots[idx] = s;
    onChange({ ...value, slots });
  };

  const removeSlot = (idx: number) => {
    onChange({ ...value, slots: value.slots.filter((_, i) => i !== idx) });
  };

  return (
    <div className={`rcm-accordion${hasData ? ' active-ca' : ''}`}
      style={{ '--rcm-ca-color': cfg.color } as React.CSSProperties}>
      <button type="button" className="rcm-accordion-header" onClick={() => setOpen(o => !o)}>
        <span className="rcm-accordion-emoji">{cfg.emoji}</span>
        <span className="rcm-accordion-name">{cfg.label}</span>
        <span className="rcm-accordion-range"
          style={{ background: cfg.color + '18', color: cfg.color }}>
          {cfg.range}
        </span>
        {hasData && (
          <span className="rcm-accordion-badge" style={{ background: cfg.color }}>
            {value.days.length} ngày · {value.slots.length} ca
          </span>
        )}
        <span className={`rcm-accordion-chevron${open ? ' open' : ''}`}>▼</span>
      </button>

      {open && (
        <div className="rcm-accordion-body">
          {/* Day pills */}
          <div className="rcm-day-pills">
            {DAY_LABELS.map((label, i) => (
              <button
                key={label} type="button"
                className={`rcm-day-pill${value.days.includes(DAY_VALUES[i]) ? ' active' : ''}`}
                style={value.days.includes(DAY_VALUES[i]) ? { background: cfg.color } : {}}
                onClick={() => toggleDay(DAY_VALUES[i])}
              >
                {label}
              </button>
            ))}
          </div>

          {/* Slot rows */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
            {value.slots.map((slot, idx) => (
              <SlotRow
                key={idx} slot={slot} idx={idx} caKey={caKey}
                caMin={cfg.startMin} caMax={cfg.endMin}
                allSlots={value.slots}
                onUpdate={s => updateSlot(idx, s)}
                onRemove={() => removeSlot(idx)}
              />
            ))}
            <button
              type="button"
              onClick={addSlot}
              className="rcm-add-slot-btn"
              style={{ color: cfg.color, borderColor: cfg.color + '60' }}
            >
              <Plus size={12}/> Thêm khung giờ
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

function SessionPicker({ caSchedules, onChange, sessionDurationMin }: {
  caSchedules: CaSchedule[];
  onChange: (s: CaSchedule[]) => void;
  sessionDurationMin: number;
}) {
  const updateCa = (caKey: string, val: CaSchedule) => {
    const existing = caSchedules.find(c => c.ca === caKey);
    if (existing) { onChange(caSchedules.map(c => c.ca === caKey ? val : c)); }
    else { onChange([...caSchedules, val]); }
  };
  const getCa = (caKey: string): CaSchedule =>
    caSchedules.find(c => c.ca === caKey) ?? { ca: caKey, days: [], slots: [] };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
      {Object.keys(CA_CONFIG).map(caKey => (
        <CaAccordion
          key={caKey} caKey={caKey}
          value={getCa(caKey)}
          onChange={val => updateCa(caKey, val)}
          sessionDurationMin={sessionDurationMin}
        />
      ))}
    </div>
  );
}

/* ══════════════════════════════════════════════════════════════════════════
   Level GS Multi-row
══════════════════════════════════════════════════════════════════════════ */
function LevelFeesEditor({ rows, onChange, tutorLevels }: {
  rows: LevelFeeRow[];
  onChange: (rows: LevelFeeRow[]) => void;
  tutorLevels: string[];
}) {
  const usedLevels = rows.map(r => r.level);

  const addRow = () => {
    const next = tutorLevels.find(l => !usedLevels.includes(l));
    if (!next) return;
    onChange([...rows, { level: next, fee: getDefaultFee(next) }]);
  };
  const updateLevel = (idx: number, level: string) => {
    const updated = [...rows];
    updated[idx] = { level, fee: getDefaultFee(level) };
    onChange(updated);
  };
  const updateFee = (idx: number, fee: number) => {
    const updated = [...rows]; updated[idx] = { ...updated[idx], fee };
    onChange(updated);
  };
  const removeRow = (idx: number) => { onChange(rows.filter((_, i) => i !== idx)); };

  return (
    <div>
      <div className="rcm-level-hint">
        Mặc định: SV 1.600.000đ · GSTN 2.200.000đ · GV 2.800.000đ — có thể điều chỉnh linh hoạt
      </div>
      {rows.map((row, idx) => (
        <div key={idx} className="rcm-level-row">
          <select className="rcm-input rcm-select" style={{ flex: 1 }} value={row.level}
            onChange={e => updateLevel(idx, e.target.value)}>
            {tutorLevels.map(l => (
              <option key={l} value={l} disabled={usedLevels.includes(l) && l !== row.level}>{l}</option>
            ))}
          </select>
          <div className="rcm-level-fee-wrap" style={{ flex: 1 }}>
            <input
              className="rcm-input" type="number" min={500_000} step={100_000}
              value={row.fee} style={{ paddingRight: 80 }}
              onChange={e => updateFee(idx, Number(e.target.value))}
            />
            <span className="rcm-level-fee-badge">{fmtCurrency(row.fee)}</span>
          </div>
          <button type="button" onClick={() => removeRow(idx)}
            style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#ef4444', padding: 4, flexShrink: 0 }}>
            <Trash2 size={15}/>
          </button>
        </div>
      ))}
      {rows.length < tutorLevels.length && (
        <button type="button" onClick={addRow} className="rcm-add-level-btn">
          <Plus size={13}/> Thêm loại gia sư
        </button>
      )}
      {rows.length === 0 && (
        <p style={{ fontSize: '0.78rem', color: 'var(--color-text-muted)', textAlign: 'center', padding: '12px 0' }}>
          Nhấn "Thêm loại gia sư" để thêm yêu cầu
        </p>
      )}
    </div>
  );
}

/* ══════════════════════════════════════════════════════════════════════════
   Main Modal — Premium design
══════════════════════════════════════════════════════════════════════════ */
interface Props { onClose: () => void; onSuccess: () => void; }

export function RequestClassModal({ onClose, onSuccess }: Props) {
  useEscapeKey(onClose);
  const [filters, setFilters] = useState<Filters>({ subjects: [], levels: [], tutorLevels: [], genders: [] });
  const [form, setForm] = useState({
    subject: '',
    customSubject: '',
    grade: '',
    mode: 'OFFLINE' as 'ONLINE' | 'OFFLINE',
    address: '',
    sessionsPerWeek: 2,
    sessionDurationMin: 90,
    genderRequirement: 'Không yêu cầu',
    description: '',
  });
  const [caSchedules, setCaSchedules] = useState<CaSchedule[]>([]);
  const [levelFees, setLevelFees] = useState<LevelFeeRow[]>([]);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    apiClient.get('/api/v1/classes/filters')
      .then(res => {
        const data = res.data?.data as Filters;
        setFilters(data);
        if (data.subjects.length > 0) setForm(f => ({ ...f, subject: data.subjects[0] }));
        if (data.levels.length > 0)   setForm(f => ({ ...f, grade: data.levels[0] }));
        setLevelFees([]);
      })
      .catch(() => {});
  }, []);

  const set = <K extends keyof typeof form>(k: K, v: typeof form[K]) =>
    setForm(f => ({ ...f, [k]: v }));

  const effectiveSubject = form.subject === 'Khác' ? form.customSubject : form.subject;
  const buildTitle = () => (!effectiveSubject || !form.grade) ? '' : `Lớp ${effectiveSubject} ${form.grade}`;

  const handleSubmit = async () => {
    if (!effectiveSubject) { setError('Vui lòng chọn môn học.'); return; }
    if (!form.grade)       { setError('Vui lòng chọn khối/lớp.'); return; }
    if (form.mode === 'OFFLINE' && !form.address.trim()) { setError('Vui lòng chọn địa chỉ học.'); return; }
    // Học phí PH tự động tính từ mức thấp nhất trong levelFees (0 nếu chưa chọn loại GS)
    const computedParentFee = levelFees.length > 0
      ? Math.min(...levelFees.map(r => r.fee))
      : 0;

    let timeFrame = '';
    const scheduleEntries: { dayOfWeek: string; ca: string; startTime: string; endTime: string }[] = [];
    for (const cs of caSchedules) {
      if (cs.days.length === 0 && cs.slots.length === 0) continue;
      const slotStrs = cs.slots.map(s => `${toHHMM(s.start)}-${toHHMM(s.end)}`).join(', ');
      if (slotStrs && !timeFrame) timeFrame = `${cs.ca}: ${slotStrs}`;
      for (const day of cs.days) {
        for (const slot of cs.slots) {
          scheduleEntries.push({ dayOfWeek: day, ca: cs.ca, startTime: toHHMM(slot.start), endTime: toHHMM(slot.end) });
        }
        if (cs.slots.length === 0) scheduleEntries.push({ dayOfWeek: day, ca: cs.ca, startTime: '', endTime: '' });
      }
    }
    const scheduleJson  = JSON.stringify(scheduleEntries);
    const levelFeesJson = levelFees.length > 0 ? JSON.stringify(levelFees) : undefined;

    setSubmitting(true); setError('');
    try {
      await parentApi.requestClass({
        title: buildTitle() || `Lớp ${effectiveSubject}`,
        subject: effectiveSubject,
        grade: form.grade,
        mode: form.mode,
        address: form.mode === 'OFFLINE' ? form.address : undefined,
        schedule: scheduleJson,
        sessionsPerWeek: form.sessionsPerWeek,
        sessionDurationMin: form.sessionDurationMin,
        timeFrame: timeFrame || undefined,
        parentFee: computedParentFee,
        genderRequirement: form.genderRequirement !== 'Không yêu cầu' ? form.genderRequirement : undefined,
        description: form.description.trim() || undefined,
        levelFees: levelFeesJson,
      });
      onSuccess();
    } catch (e: unknown) {
      const err = e as { response?: { data?: { message?: string } } };
      setError(err?.response?.data?.message ?? 'Gửi yêu cầu thất bại. Vui lòng thử lại.');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="rcm-overlay" onClick={onClose}>
      <div className="rcm-modal" onClick={e => e.stopPropagation()}>

        {/* ── Gradient header ── */}
        <div className="rcm-header">
          <div className="rcm-header-row">
            <div>
              <div className="rcm-header-icon">📋</div>
              <h2 className="rcm-title">Yêu cầu mở lớp học</h2>
              <p className="rcm-subtitle">Admin xét duyệt → gia sư đăng ký nhận lớp</p>
            </div>
            <button className="rcm-close" onClick={onClose} aria-label="Đóng">
              <X size={18}/>
            </button>
          </div>
        </div>

        {/* ── Scrollable body ── */}
        <div className="rcm-body">
          {error && (
            <div className="rcm-error"><AlertCircle size={15}/> {error}</div>
          )}

          {/* Section 1 — Thông tin lớp */}
          <div className="rcm-section">
            <div className="rcm-section-label">
              <span className="rcm-sl-dot"/> 📚 Thông tin lớp học
            </div>
            <div className="rcm-grid">
              <div className="rcm-field">
                <label className="rcm-label">Môn học <span className="rcm-label-req">*</span></label>
                <select className="rcm-input rcm-select" value={form.subject} onChange={e => set('subject', e.target.value)}>
                  {filters.subjects.map(s => <option key={s}>{s}</option>)}
                  <option value="Khác">Khác...</option>
                </select>
                {form.subject === 'Khác' && (
                  <input className="rcm-input" style={{ marginTop: 6 }}
                    value={form.customSubject} onChange={e => set('customSubject', e.target.value)}
                    placeholder="Nhập tên môn học" autoFocus/>
                )}
              </div>

              <div className="rcm-field">
                <label className="rcm-label">Khối/Lớp <span className="rcm-label-req">*</span></label>
                <select className="rcm-input rcm-select" value={form.grade} onChange={e => set('grade', e.target.value)}>
                  {filters.levels.map(g => <option key={g}>{g}</option>)}
                </select>
              </div>

              <div className="rcm-field">
                <label className="rcm-label">Hình thức</label>
                <div className="rcm-mode-toggle">
                  <button type="button" className={`rcm-mode-btn${form.mode === 'OFFLINE' ? ' active' : ''}`}
                    onClick={() => set('mode', 'OFFLINE')}>🏠 Tại nhà</button>
                  <button type="button" className={`rcm-mode-btn${form.mode === 'ONLINE' ? ' active' : ''}`}
                    onClick={() => set('mode', 'ONLINE')}>💻 Online</button>
                </div>
              </div>

              {form.mode === 'OFFLINE' && (
                <div className="rcm-field">
                  <label className="rcm-label">Địa chỉ học <span className="rcm-label-req">*</span></label>
                  <MapAddressInput value={form.address} onChange={(v: string) => set('address', v)}/>
                </div>
              )}

              <div className="rcm-field">
                <label className="rcm-label">Số buổi/tuần</label>
                <select className="rcm-input rcm-select" value={form.sessionsPerWeek}
                  onChange={e => set('sessionsPerWeek', Number(e.target.value))}>
                  {[1,2,3,4,5,6,7].map(n => <option key={n} value={n}>{n} buổi/tuần</option>)}
                </select>
              </div>

              <div className="rcm-field">
                <label className="rcm-label">Thời lượng/buổi</label>
                <select className="rcm-input rcm-select" value={form.sessionDurationMin}
                  onChange={e => set('sessionDurationMin', Number(e.target.value))}>
                  {[60, 90, 120, 150, 180].map(n => <option key={n} value={n}>{n} phút</option>)}
                </select>
              </div>
            </div>
          </div>

          {/* Section 2 — Lịch học */}
          <div className="rcm-section">
            <div className="rcm-section-label">
              <span className="rcm-sl-dot"/> 🗓️ Lịch học & ca dạy
            </div>
            <SessionPicker caSchedules={caSchedules} onChange={setCaSchedules} sessionDurationMin={form.sessionDurationMin}/>
          </div>

          {/* Section 3 — Loại GS (học phí chốt ở bước xác nhận GS) */}
          <div className="rcm-section">
            <div className="rcm-section-label">
              <span className="rcm-sl-dot"/> 💰 Loại gia sư mong muốn
            </div>
            <div className="rcm-field" style={{ marginBottom: 14 }}>
              <label className="rcm-label">Yêu cầu giới tính GS</label>
              <select className="rcm-input rcm-select" value={form.genderRequirement}
                onChange={e => set('genderRequirement', e.target.value)}>
                <option>Không yêu cầu</option>
                {filters.genders.map(g => <option key={g}>{g}</option>)}
              </select>
            </div>
            <div className="rcm-field">
              <label className="rcm-label">Loại gia sư & học phí GS nhận</label>
              <LevelFeesEditor rows={levelFees} onChange={setLevelFees} tutorLevels={filters.tutorLevels}/>
            </div>
          </div>

          {/* Section 4 — Ghi chú */}
          <div className="rcm-section" style={{ marginBottom: 0 }}>
            <div className="rcm-section-label">
              <span className="rcm-sl-dot"/> 📝 Ghi chú thêm
            </div>
            <textarea className="rcm-input rcm-textarea"
              value={form.description} onChange={e => set('description', e.target.value)}
              rows={2} placeholder="Yêu cầu đặc biệt, tình trạng học sinh, mục tiêu học..."/>
          </div>
        </div>

        {/* ── Sticky footer ── */}
        <div className="rcm-footer">
          <button className="rcm-btn-cancel" onClick={onClose}>Huỷ</button>
          <button className="rcm-btn-submit" onClick={handleSubmit} disabled={submitting}>
            {submitting
              ? <><span style={{
                  display: 'inline-block', width: 14, height: 14, borderRadius: '50%',
                  border: '2px solid rgba(255,255,255,0.4)', borderTopColor: '#fff',
                  animation: 'spin 0.7s linear infinite',
                }}/> Đang gửi...</>
              : <><Plus size={15}/> Gửi yêu cầu</>
            }
          </button>
        </div>
      </div>
    </div>
  );
}
