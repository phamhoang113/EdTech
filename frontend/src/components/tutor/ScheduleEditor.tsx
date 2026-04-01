import { Plus, Trash2, Save, Clock } from 'lucide-react';
import { useState } from 'react';

import type { ScheduleSlot } from '../../services/tutorApi';
import { TimePicker24h, DayPicker } from '../common/TimePicker24h';
import '../common/TimePicker24h.css';

/**
 * Tính endTime = startTime + durationMin
 */
function calculateEndTime(startTime: string, durationMin: number): string {
  const [hours, mins] = startTime.split(':').map(Number);
  const totalMinutes = hours * 60 + mins + durationMin;
  const endHours = Math.floor(totalMinutes / 60) % 24;
  const endMins = totalMinutes % 60;
  return `${String(endHours).padStart(2, '0')}:${String(endMins).padStart(2, '0')}`;
}

interface ScheduleEditorProps {
  initialSlots?: ScheduleSlot[];
  sessionDurationMin: number;
  onSave: (slots: ScheduleSlot[]) => Promise<void>;
  onCancel?: () => void;
}

export function ScheduleEditor({ initialSlots = [], sessionDurationMin, onSave, onCancel }: ScheduleEditorProps) {
  const [slots, setSlots] = useState<ScheduleSlot[]>(
    initialSlots.length > 0
      ? initialSlots.map(s => ({
          ...s,
          dayOfWeek: ({ Monday:'T2',Tuesday:'T3',Wednesday:'T4',Thursday:'T5',Friday:'T6',Saturday:'T7',Sunday:'CN' }[s.dayOfWeek] ?? s.dayOfWeek),
          endTime: calculateEndTime(s.startTime, sessionDurationMin),
        }))
      : [{ dayOfWeek: 'T2', startTime: '08:00', endTime: calculateEndTime('08:00', sessionDurationMin) }]
  );
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  const addSlot = () => {
    setSlots(prev => [...prev, {
      dayOfWeek: 'T3',
      startTime: '14:00',
      endTime: calculateEndTime('14:00', sessionDurationMin),
    }]);
  };

  const removeSlot = (index: number) => {
    if (slots.length <= 1) return;
    setSlots(prev => prev.filter((_, i) => i !== index));
  };

  const updateStartTime = (index: number, startTime: string) => {
    setSlots(prev => prev.map((slot, i) =>
      i === index
        ? { ...slot, startTime, endTime: calculateEndTime(startTime, sessionDurationMin) }
        : slot
    ));
  };

  const updateDay = (index: number, dayOfWeek: string) => {
    setSlots(prev => prev.map((slot, i) =>
      i === index ? { ...slot, dayOfWeek } : slot
    ));
  };

  const handleSave = async () => {
    setError('');
    for (const slot of slots) {
      if (slot.startTime >= slot.endTime) {
        setError('Giờ bắt đầu phải trước giờ kết thúc');
        return;
      }
    }
    try {
      setSaving(true);
      await onSave(slots);
    } catch (err: any) {
      setError(err?.response?.data?.message || err?.message || 'Lỗi khi lưu lịch dạy');
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="sched-editor">
      <h3 className="sched-editor-title">
        <Clock size={18} /> Thiết lập lịch dạy
      </h3>
      <div className="sched-editor-duration-info">
        Thời lượng mỗi buổi: <strong>{sessionDurationMin} phút</strong>
      </div>

      <div className="sched-editor-slots">
        {slots.map((slot, i) => (
          <div key={i} className="sched-editor-slot">
            <DayPicker
              value={slot.dayOfWeek}
              onChange={value => updateDay(i, value)}
            />

            <div className="sched-time-group">
              <TimePicker24h
                value={slot.startTime}
                onChange={value => updateStartTime(i, value)}
              />
              <span className="sched-separator">→</span>
              <span className="sched-time-display">{slot.endTime}</span>
            </div>

            <button
              className="sched-remove-btn"
              onClick={() => removeSlot(i)}
              disabled={slots.length <= 1}
              title="Xoá buổi"
            >
              <Trash2 size={14} />
            </button>
          </div>
        ))}
      </div>

      {error && <div className="sched-editor-error">{error}</div>}

      <div className="sched-editor-actions">
        <button className="sched-add-btn" onClick={addSlot}>
          <Plus size={14} /> Thêm buổi
        </button>
        <div className="sched-editor-right">
          {onCancel && (
            <button className="sched-cancel-btn" onClick={onCancel}>Huỷ</button>
          )}
          <button className="sched-save-btn" onClick={handleSave} disabled={saving}>
            <Save size={14} /> {saving ? 'Đang lưu...' : 'Lưu lịch dạy'}
          </button>
        </div>
      </div>
    </div>
  );
}
