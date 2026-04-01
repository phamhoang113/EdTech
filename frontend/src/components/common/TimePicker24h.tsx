import { useRef, useEffect, useCallback, useMemo } from 'react';

interface TimePickerProps {
  value: string;           // "HH:mm"
  onChange: (value: string) => void;
  disabled?: boolean;
}

const ITEM_H = 24;

function ScrollColumn({ items, selected, onSelect }: {
  items: { value: number; label: string }[];
  selected: number;
  onSelect: (val: number) => void;
}) {
  const ref = useRef<HTMLDivElement>(null);
  const settling = useRef(false);

  const scrollTo = useCallback((idx: number, smooth = true) => {
    ref.current?.scrollTo({ top: idx * ITEM_H, behavior: smooth ? 'smooth' : 'auto' });
  }, []);

  useEffect(() => {
    const idx = items.findIndex(i => i.value === selected);
    if (idx >= 0) scrollTo(idx, false);
  }, []);

  const handleScroll = () => {
    if (!ref.current || settling.current) return;
    const idx = Math.round(ref.current.scrollTop / ITEM_H);
    const clamped = Math.max(0, Math.min(idx, items.length - 1));
    if (items[clamped].value !== selected) onSelect(items[clamped].value);
  };

  const handleClick = (idx: number) => {
    settling.current = true;
    onSelect(items[idx].value);
    scrollTo(idx);
    setTimeout(() => { settling.current = false; }, 150);
  };

  return (
    <div className="tp-col" ref={ref} onScroll={handleScroll}>
      <div style={{ height: ITEM_H }} />
      {items.map((item, idx) => (
        <div
          key={item.value}
          className={`tp-item ${item.value === selected ? 'tp-item--on' : ''}`}
          onClick={() => handleClick(idx)}
        >
          {item.label}
        </div>
      ))}
      <div style={{ height: ITEM_H }} />
    </div>
  );
}

export function TimePicker24h({ value, onChange, disabled = false }: TimePickerProps) {
  const [hour, minute] = useMemo(() => {
    const p = (value || '08:00').split(':');
    return [parseInt(p[0], 10), parseInt(p[1], 10)];
  }, [value]);

  const hours = useMemo(() =>
    Array.from({ length: 24 }, (_, i) => ({ value: i, label: String(i).padStart(2, '0') })), []);
  const minutes = useMemo(() =>
    Array.from({ length: 12 }, (_, i) => ({ value: i * 5, label: String(i * 5).padStart(2, '0') })), []);

  if (disabled) return <span className="tp-static">{value}</span>;

  return (
    <div className="tp-box">
      <div className="tp-highlight" />
      <ScrollColumn items={hours} selected={hour}
        onSelect={h => onChange(`${String(h).padStart(2, '0')}:${String(minute).padStart(2, '0')}`)} />
      <span className="tp-colon">:</span>
      <ScrollColumn items={minutes} selected={minute}
        onSelect={m => onChange(`${String(hour).padStart(2, '0')}:${String(m).padStart(2, '0')}`)} />
    </div>
  );
}

/* ── Day Scroll Picker ─────────────────────────── */
const DAY_ITEMS = [
  { value: 0, label: 'T2', code: 'T2' },
  { value: 1, label: 'T3', code: 'T3' },
  { value: 2, label: 'T4', code: 'T4' },
  { value: 3, label: 'T5', code: 'T5' },
  { value: 4, label: 'T6', code: 'T6' },
  { value: 5, label: 'T7', code: 'T7' },
  { value: 6, label: 'CN', code: 'CN' },
];

interface DayPickerProps {
  value: string;           // "T2", "T3", ..., "CN"
  onChange: (value: string) => void;
}

export function DayPicker({ value, onChange }: DayPickerProps) {
  const selectedIdx = useMemo(() => {
    const idx = DAY_ITEMS.findIndex(d => d.code === value);
    return idx >= 0 ? idx : 0;
  }, [value]);

  return (
    <div className="tp-box tp-box--day">
      <div className="tp-highlight" />
      <ScrollColumn
        items={DAY_ITEMS.map(d => ({ value: d.value, label: d.label }))}
        selected={selectedIdx}
        onSelect={idx => onChange(DAY_ITEMS[idx].code)}
      />
    </div>
  );
}
