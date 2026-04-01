import { X, Plus, Trash2, AlertCircle, MapPin, Clock, UserCircle } from 'lucide-react';
import React, { useState, useEffect, useRef } from 'react';

import './RequestClassModal.css';
import apiClient from '../../services/apiClient';
import { parentApi } from '../../services/parentApi';
import { useEscapeKey } from '../../hooks/useEscapeKey';
/* ── Types ───────────────────────────────────────────────────────────────── */
export interface LevelFeeRow {
  level: string;
  fee: number;
}

interface Filters {
  subjects: string[];
  levels: string[];
  tutorLevels: string[];
  genders: string[];
}

export interface TimeSlot { start: number; end: number; }
export interface CaSchedule { ca: string; days: string[]; slots: TimeSlot[]; }

/* ── Constants ───────────────────────────────────────────────────────────── */
const DAY_LABELS = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
const DAY_VALUES = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

export const CA_CONFIG: Record<string, { label: string; emoji: string; range: string; color: string; startMin: number; endMin: number }> = {
  Sáng:  { label: 'Ca sáng',  emoji: '🌅', range: '6:00 – 11:30',  color: '#f59e0b', startMin: 360,  endMin: 690  },
  Chiều: { label: 'Ca chiều', emoji: '☀️', range: '12:00 – 17:30', color: '#6366f1', startMin: 720,  endMin: 1050 },
  Tối:   { label: 'Ca tối',   emoji: '🌙', range: '18:00 – 21:30', color: '#8b5cf6', startMin: 1080, endMin: 1290 },
};

/* ── Helpers ─────────────────────────────────────────────────────────────── */
function fmtCurrency(n: number) { return n.toLocaleString('vi-VN') + ' ₫'; }
export function toHHMM(m: number): string {
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
   Map Address Picker (Mapbox GL JS + Mapbox Search API v6)
══════════════════════════════════════════════════════════════════════════ */
declare global {
  interface Window { mapboxgl?: any; }
}

function loadMapboxGL(): Promise<void> {
  return new Promise((resolve, reject) => {
    if (window.mapboxgl) { resolve(); return; }
    if (!document.getElementById('mapbox-css')) {
      const css = document.createElement('link');
      css.id = 'mapbox-css'; css.rel = 'stylesheet';
      css.href = 'https://api.mapbox.com/mapbox-gl-js/v3.0.1/mapbox-gl.css';
      document.head.appendChild(css);
    }
    if (document.getElementById('mapbox-js')) {
      const check = setInterval(() => { if (window.mapboxgl) { clearInterval(check); resolve(); } }, 50);
      return;
    }
    const script = document.createElement('script');
    script.id = 'mapbox-js';
    script.src = 'https://api.mapbox.com/mapbox-gl-js/v3.0.1/mapbox-gl.js';
    script.onload = () => resolve();
    script.onerror = () => reject(new Error('Failed to load Mapbox GL JS API'));
    document.head.appendChild(script);
  });
}

interface PlaceResult { display_name: string; place_id?: string; lat?: number; lon?: number; center?: [number, number]; }

async function reverseGeocodeMapbox(lat: number, lng: number): Promise<string> {
  const apiKey = import.meta.env.VITE_MAPBOX_API_KEY;
  if (!apiKey) return `${lat.toFixed(6)}, ${lng.toFixed(6)}`;
  try {
    const res = await fetch(`https://api.mapbox.com/search/geocode/v6/reverse?longitude=${lng}&latitude=${lat}&language=vi&access_token=${apiKey}`);
    const data = await res.json();
    if (data.features?.length > 0) {
      const f = data.features[0].properties;
      return f.full_address || f.name || f.place_formatted || `${lat.toFixed(6)}, ${lng.toFixed(6)}`;
    }
  } catch (e) { console.error(e); }
  return `${lat.toFixed(6)}, ${lng.toFixed(6)}`;
}

async function searchAddressMapbox(q: string): Promise<PlaceResult[]> {
  if (!q.trim()) return [];
  const apiKey = import.meta.env.VITE_MAPBOX_API_KEY;
  if (!apiKey) return [];
  try {
    const res = await fetch(`https://api.mapbox.com/search/geocode/v6/forward?q=${encodeURIComponent(q)}&country=vn&language=vi&access_token=${apiKey}`);
    const data = await res.json();
    if (data.features) {
      return data.features.map((f: any) => ({
        display_name: f.properties.full_address || f.properties.name || f.properties.place_formatted,
        center: f.geometry.coordinates,
        lat: f.geometry.coordinates[1],
        lon: f.geometry.coordinates[0],
        place_id: f.id
      }));
    }
  } catch (e) { console.error(e); }
  return [];
}

function MapPickerModal({ onClose, onSelect, initialAddress }: {
  onClose: () => void;
  onSelect: (address: string, lat?: number, lon?: number) => void;
  initialAddress: string;
}) {
  const mapRef = useRef<HTMLDivElement>(null);
  const mapInstanceRef = useRef<unknown>(null);
  const markerRef = useRef<unknown>(null);
  const [currentAddress, setCurrentAddress] = useState(initialAddress || 'Chưa chọn vị trí');
  const [currentPos, setCurrentPos] = useState<{lat: number; lon: number} | null>(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState<PlaceResult[]>([]);
  const [searching, setSearching] = useState(false);
  const [loading, setLoading] = useState(true);
  const DEFAULT_LAT = 10.7769; const DEFAULT_LNG = 106.7009;

  useEffect(() => {
    let cancelled = false;
    loadMapboxGL().then(() => {
      if (cancelled || !mapRef.current || mapInstanceRef.current) return;
      const mapboxgl = window.mapboxgl;
      mapboxgl.accessToken = import.meta.env.VITE_MAPBOX_API_KEY;
      
      const map = new mapboxgl.Map({
        container: mapRef.current,
        style: 'mapbox://styles/mapbox/streets-v12',
        center: [DEFAULT_LNG, DEFAULT_LAT],
        zoom: 14,
        attributionControl: false
      });
      map.addControl(new mapboxgl.AttributionControl({ compact: true }));
      mapInstanceRef.current = map;
      
      const marker = new mapboxgl.Marker({ color: '#6366f1', draggable: true })
        .setLngLat([DEFAULT_LNG, DEFAULT_LAT])
        .addTo(map);
      markerRef.current = marker;

      map.on('click', async (e: any) => {
        marker.setLngLat(e.lngLat);
        setCurrentAddress(await reverseGeocodeMapbox(e.lngLat.lat, e.lngLat.lng));
        setCurrentPos({ lat: e.lngLat.lat, lon: e.lngLat.lng });
      });

      marker.on('dragend', async () => {
        const pos = marker.getLngLat();
        setCurrentAddress(await reverseGeocodeMapbox(pos.lat, pos.lng));
        setCurrentPos({ lat: pos.lat, lon: pos.lng });
      });
      
      setLoading(false);
    }).catch(err => {
      console.error(err);
      setLoading(false);
      setCurrentAddress("Lỗi tải Mapbox. Vui lòng thử lại sau.");
    });
    return () => { cancelled = true; };
  }, []);

  const handleSearch = async () => {
    if (!searchQuery.trim()) return;
    setSearching(true);
    try { setSearchResults(await searchAddressMapbox(searchQuery)); }
    finally { setSearching(false); }
  };

  const handleSelectResult = async (r: PlaceResult) => {
    if (r.center && mapInstanceRef.current && markerRef.current) {
      const map = mapInstanceRef.current as any;
      const marker = markerRef.current as any;
      map.flyTo({ center: r.center, zoom: 16 });
      marker.setLngLat(r.center);
    }
    setCurrentAddress(r.display_name);
    setCurrentPos(r.lat && r.lon ? { lat: r.lat, lon: r.lon } : null);
    setSearchResults([]); setSearchQuery('');
  };

  return (
    <div className="rcm-overlay" onClick={onClose} style={{ zIndex: 999999 }}>
      <div className="rcm-map-modal" onClick={e => e.stopPropagation()}>
        <div className="rcm-map-area" style={{ position: 'relative' }}>
          {loading && <div className="rcm-map-loading">🗺️ Đang tải bản đồ...</div>}
          <div ref={mapRef} style={{ width: '100%', height: '100%', minHeight: 400 }}/>
          
          <div className="rcm-floating-search-wrap">
            <div className="rcm-floating-search-box">
              <MapPin size={18} style={{ color: '#6366f1', marginLeft: 8 }}/>
              <input
                className="rcm-fs-input"
                value={searchQuery}
                onChange={e => setSearchQuery(e.target.value)}
                onKeyDown={e => { if (e.key === 'Enter') handleSearch(); }}
                placeholder="Tìm kiếm vị trí (VD: Số 123...)"
              />
              <div className="rcm-fs-actions">
                {searching && <div className="rcm-spinner-small" style={{ marginRight: 8 }}/>}
                <div className="rcm-fs-divider"/>
                <button onClick={handleSearch} disabled={searching} className="rcm-fs-icon-btn search" title="Tìm kiếm">
                  <span style={{ fontSize: '0.86rem', fontWeight: 700 }}>Tìm</span>
                </button>
              </div>
            </div>
            
            {searchResults.length > 0 && (
              <div className="rcm-fs-results">
                {searchResults.map((r, i) => {
                  const parts = r.display_name.split(',');
                  const main = parts[0];
                  const sub  = parts.slice(1).join(',').trim();
                  return (
                    <button key={i} className="rcm-fs-result-item" onClick={() => handleSelectResult(r)}>
                      <div className="rcm-fs-icon-box"><MapPin size={16}/></div>
                      <div className="rcm-fs-text-box">
                        <div className="rcm-fs-main">{main}</div>
                        {sub && <div className="rcm-fs-sub">{sub}</div>}
                      </div>
                    </button>
                  );
                })}
              </div>
            )}
          </div>
        </div>
        <div className="rcm-map-footer">
          <div className="rcm-map-addr-label">Địa chỉ đã chọn:</div>
          <div className="rcm-map-addr-value"><MapPin size={12} style={{ marginRight: 5 }}/>{currentAddress}</div>
          <div className="rcm-map-actions">
            <button onClick={onClose} className="rcm-btn-cancel" style={{ flex: 1 }}>Huỷ</button>
            <button
              onClick={() => { onSelect(currentAddress, currentPos?.lat, currentPos?.lon); onClose(); }}
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

export function MapAddressInput({ value, onChange }: { value: string; onChange: (v: string, lat?: number, lon?: number) => void }) {
  const [query, setQuery] = useState(value);
  const [suggestions, setSuggestions] = useState<PlaceResult[]>([]);
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
    if (text.trim().length < 2) { setSuggestions([]); return; }

    debounceRef.current = setTimeout(async () => {
      setLoading(true);
      try {
        const results = await searchAddressMapbox(text);
        setSuggestions(results);
      } catch { setSuggestions([]); }
      finally { setLoading(false); }
    }, 400);
  };

  const handleSelect = (r: PlaceResult) => {
    setQuery(r.display_name);
    onChange(r.display_name, r.lat, r.lon);
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

export function SessionPicker({ caSchedules, onChange, sessionDurationMin }: {
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
export function LevelFeesEditor({ rows, onChange, tutorLevels }: {
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

  // Chọn con em
  const [children, setChildren] = useState<{ id: string; fullName: string; grade?: string }[]>([]);
  const [selectedStudentIds, setSelectedStudentIds] = useState<string[]>([]);
  const [loadingChildren, setLoadingChildren] = useState(true);

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
    // Fetch danh sách con em
    parentApi.getMyChildren()
      .then(res => { setChildren((res.data ?? []).map(s => ({ id: s.id, fullName: s.fullName, grade: s.grade ?? undefined }))); })
      .catch(() => {})
      .finally(() => setLoadingChildren(false));
  }, []);

  const set = <K extends keyof typeof form>(k: K, v: typeof form[K]) =>
    setForm(f => ({ ...f, [k]: v }));

  const handleAddressSelect = async (addr: string) => {
    set('address', addr);
  };

  const effectiveSubject = form.subject === 'Khác' ? form.customSubject : form.subject;
  const buildTitle = () => (!effectiveSubject || !form.grade) ? '' : `Lớp ${effectiveSubject} ${form.grade}`;

  const handleSubmit = async () => {
    if (!effectiveSubject) { setError('Vui lòng chọn môn học.'); return; }
    if (!form.grade)       { setError('Vui lòng chọn khối/lớp.'); return; }
    if (form.mode === 'OFFLINE' && !form.address.trim()) { setError('Vui lòng chọn địa chỉ học.'); return; }
    if (children.length > 0 && selectedStudentIds.length === 0) { setError('Vui lòng chọn con em cho lớp này.'); return; }
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
        studentIds: selectedStudentIds.length > 0 ? selectedStudentIds : undefined,
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

          {/* Section 0 — Chọn con em (bắt buộc) */}
          {children.length > 0 && (
            <div className="rcm-section">
              <div className="rcm-section-label">
                <span className="rcm-sl-dot"/> 👶 Chọn con em <span className="rcm-label-req">*</span>
              </div>
              {loadingChildren ? (
                <div style={{ fontSize: '0.84rem', color: 'var(--color-text-muted)', padding: '12px 0' }}>Đang tải...</div>
              ) : (
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
                  {children.map(child => {
                    const selected = selectedStudentIds.includes(child.id);
                    return (
                      <button
                        key={child.id}
                        type="button"
                        onClick={() => {
                          setSelectedStudentIds(prev =>
                            selected ? prev.filter(id => id !== child.id) : [...prev, child.id]
                          );
                        }}
                        style={{
                          display: 'flex', alignItems: 'center', gap: 8,
                          padding: '8px 14px', borderRadius: 20,
                          border: `1.5px solid ${selected ? '#6366f1' : 'var(--color-border)'}`,
                          background: selected ? 'rgba(99, 102, 241, 0.08)' : 'transparent',
                          color: selected ? '#6366f1' : 'var(--color-text)',
                          fontWeight: selected ? 700 : 500,
                          fontSize: '0.84rem', cursor: 'pointer',
                          fontFamily: 'inherit',
                          transition: 'all 0.15s',
                        }}
                      >
                        <UserCircle size={16}/>
                        <span>{child.fullName}</span>
                        {child.grade && <span style={{ fontSize: '0.72rem', opacity: 0.7 }}>({child.grade})</span>}
                      </button>
                    );
                  })}
                </div>
              )}
              {selectedStudentIds.length === 0 && !loadingChildren && (
                <p style={{ fontSize: '0.78rem', color: '#ef4444', marginTop: 6, fontWeight: 600 }}>
                  Vui lòng chọn ít nhất 1 con em
                </p>
              )}
            </div>
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
                  <label className="rcm-label">
                    Địa chỉ học <span className="rcm-label-req">*</span>
                  </label>
                  <MapAddressInput value={form.address} onChange={(v) => handleAddressSelect(v)}/>
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
