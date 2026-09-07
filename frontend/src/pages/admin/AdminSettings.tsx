import { Save, Globe, Shield, Bell, Database, Palette, CheckCircle, AlertTriangle, Loader2, CreditCard } from 'lucide-react';
import { useState, useEffect } from 'react';

import { adminApi } from '../../services/adminApi';
import type { SystemSettings } from '../../services/adminApi';
import './AdminSettings.css';

/* ── Section tabs ── */
const SECTIONS = [
  { id: 'general',    label: 'Chung',         icon: <Globe size={16}/> },
  { id: 'platform',   label: 'Nền tảng',      icon: <Database size={16}/> },
  { id: 'payment',    label: 'Thanh toán',     icon: <CreditCard size={16}/> },
  { id: 'security',   label: 'Bảo mật',       icon: <Shield size={16}/> },
  { id: 'notify',     label: 'Thông báo',     icon: <Bell size={16}/> },
  { id: 'appearance', label: 'Giao diện',     icon: <Palette size={16}/> },
];

const DEFAULT: SystemSettings = {
  siteName: 'Gia Sư Tinh Hoa',
  contactEmail: 'giasutinhhoa2026@gmail.com',
  contactPhone: '1800 1234',
  maintenanceMode: false,
  platformFeePercent: 20,
  minHourlyRate: 50000,
  maxHourlyRate: 2000000,
  maxClassesPerTutor: 5,
  autoApproveEnabled: false,
  mockDataEnabled: true,
  emailOnNewUser: true,
  emailOnVerification: true,
  emailOnNewClass: false,
  emailOnPayment: true,
  primaryColor: '#6366f1',
  vietqrBankBin: '',
  vietqrBankAccount: '',
  vietqrAccountName: '',
};

/** Áp màu chủ đạo vào CSS variable ngay lập tức */
function applyPrimaryColor(color: string) {
  document.documentElement.style.setProperty('--color-primary', color);
  // Tính màu hover (tối hơn 10%)
  document.documentElement.style.setProperty('--color-primary-hover', color + 'cc');
}

export function AdminSettings() {
  const [activeSection, setActiveSection] = useState('general');
  const [settings, setSettings] = useState<SystemSettings>(DEFAULT);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [toast, setToast] = useState<{ type: 'success' | 'error'; msg: string } | null>(null);

  useEffect(() => {
    adminApi.getSettings()
      .then(res => {
        setSettings(res.data);
        applyPrimaryColor(res.data.primaryColor);
      })
      .catch(() => showToast('error', 'Không thể tải cài đặt hệ thống'))
      .finally(() => setLoading(false));
  }, []);

  function showToast(type: 'success' | 'error', msg: string) {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 3000);
  }

  const handleSave = async () => {
    setSaving(true);
    try {
      const res = await adminApi.updateSettings(settings);
      setSettings(res.data);
      applyPrimaryColor(res.data.primaryColor);
      showToast('success', 'Lưu cài đặt thành công!');
    } catch {
      showToast('error', 'Lưu thất bại. Vui lòng thử lại.');
    } finally {
      setSaving(false);
    }
  };

  const set = <K extends keyof SystemSettings>(key: K, value: SystemSettings[K]) => {
    setSettings(prev => ({ ...prev, [key]: value }));
    // Áp màu ngay khi thay đổi (không cần save)
    if (key === 'primaryColor') applyPrimaryColor(value as string);
  };

  if (loading) {
    return (
      <div style={{ padding: 60, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 12, color: 'var(--color-text-muted)' }}>
        <Loader2 size={20} style={{ animation: 'spin 1s linear infinite' }}/>
        Đang tải cài đặt...
      </div>
    );
  }

  return (
    <div className="admin-settings">
      {/* Toast */}
      {toast && (
        <div style={{
          position: 'fixed', bottom: 24, right: 24, zIndex: 9999,
          padding: '10px 20px', borderRadius: 10, fontWeight: 600, fontSize: '0.88rem',
          background: toast.type === 'success' ? '#ecfdf5' : '#fef2f2',
          color: toast.type === 'success' ? '#065f46' : '#b91c1c',
          border: `1px solid ${toast.type === 'success' ? 'rgba(5,150,105,0.3)' : 'rgba(239,68,68,0.3)'}`,
          boxShadow: '0 4px 16px rgba(0,0,0,0.1)',
          display: 'flex', alignItems: 'center', gap: 8,
        }}>
          {toast.type === 'success' ? <CheckCircle size={16}/> : <AlertTriangle size={16}/>}
          {toast.msg}
        </div>
      )}

      {/* Header */}
      <div className="as-header">
        <div>
          <h1 className="as-title">Cài đặt hệ thống</h1>
          <p className="as-subtitle">Cấu hình được lưu vào cơ sở dữ liệu và áp dụng toàn hệ thống</p>
        </div>
        <button className="as-save-btn" onClick={handleSave} disabled={saving}>
          {saving ? <><Loader2 size={16} style={{ animation: 'spin 1s linear infinite' }}/> Đang lưu...</>
                  : <><Save size={16}/> Lưu cài đặt</>}
        </button>
      </div>

      <div className="as-layout">
        {/* Sidebar nav */}
        <nav className="as-nav">
          {SECTIONS.map(s => (
            <button
              key={s.id}
              className={`as-nav__item ${activeSection === s.id ? 'active' : ''}`}
              onClick={() => setActiveSection(s.id)}
            >
              {s.icon} {s.label}
            </button>
          ))}
        </nav>

        {/* Content */}
        <div className="as-content">

          {/* ── Chung ── */}
          {activeSection === 'general' && (
            <div className="as-section">
              <h2 className="as-section__title">Thông tin chung</h2>
              <div className="as-group">
                <label className="as-label">Tên nền tảng</label>
                <input className="as-input" value={settings.siteName} onChange={e => set('siteName', e.target.value)}/>
              </div>
              <div className="as-group">
                <label className="as-label">Email liên hệ</label>
                <input className="as-input" type="email" value={settings.contactEmail} onChange={e => set('contactEmail', e.target.value)}/>
              </div>
              <div className="as-group">
                <label className="as-label">Hotline hỗ trợ</label>
                <input className="as-input" value={settings.contactPhone} onChange={e => set('contactPhone', e.target.value)}/>
              </div>
              <div className="as-group">
                <div className={`as-toggle-row ${settings.maintenanceMode ? 'as-toggle-row--warn' : ''}`}>
                  <div>
                    <div className="as-label">Chế độ bảo trì</div>
                    <div className="as-hint">Tạm ngưng toàn bộ truy cập người dùng thường</div>
                  </div>
                  <label className="as-toggle">
                    <input type="checkbox" checked={settings.maintenanceMode} onChange={e => set('maintenanceMode', e.target.checked)}/>
                    <span className="as-toggle__slider"/>
                  </label>
                </div>
                {settings.maintenanceMode && (
                  <div style={{ display: 'flex', gap: 6, alignItems: 'center', marginTop: 4, fontSize: '0.8rem', color: '#f59e0b', fontWeight: 600 }}>
                    <AlertTriangle size={14}/> Đang bật chế độ bảo trì — người dùng sẽ không truy cập được
                  </div>
                )}
              </div>
            </div>
          )}

          {/* ── Nền tảng ── */}
          {activeSection === 'platform' && (
            <div className="as-section">
              <h2 className="as-section__title">Cấu hình nền tảng</h2>
              <div className="as-group">
                <label className="as-label">Phí nền tảng (%)</label>
                <input className="as-input" type="number" min={0} max={100} value={settings.platformFeePercent} onChange={e => set('platformFeePercent', Number(e.target.value))}/>
                <span className="as-hint">Phần trăm phí thu trên mỗi hợp đồng gia sư — hiện tại: {settings.platformFeePercent}%</span>
              </div>
              <div className="as-row">
                <div className="as-group">
                  <label className="as-label">Lương tối thiểu (₫/h)</label>
                  <input className="as-input" type="number" value={settings.minHourlyRate} onChange={e => set('minHourlyRate', Number(e.target.value))}/>
                  <span className="as-hint">{settings.minHourlyRate.toLocaleString('vi-VN')} ₫</span>
                </div>
                <div className="as-group">
                  <label className="as-label">Lương tối đa (₫/h)</label>
                  <input className="as-input" type="number" value={settings.maxHourlyRate} onChange={e => set('maxHourlyRate', Number(e.target.value))}/>
                  <span className="as-hint">{settings.maxHourlyRate.toLocaleString('vi-VN')} ₫</span>
                </div>
              </div>
              <div className="as-group">
                <label className="as-label">Số lớp tối đa / gia sư</label>
                <input className="as-input" type="number" min={1} max={20} value={settings.maxClassesPerTutor} onChange={e => set('maxClassesPerTutor', Number(e.target.value))}/>
              </div>
              <div className="as-group">
                <div className="as-toggle-row">
                  <div>
                    <div className="as-label">Tự động duyệt hồ sơ gia sư</div>
                    <div className="as-hint">Bỏ qua bước duyệt thủ công (không khuyến nghị)</div>
                  </div>
                  <label className="as-toggle">
                    <input type="checkbox" checked={settings.autoApproveEnabled} onChange={e => set('autoApproveEnabled', e.target.checked)}/>
                    <span className="as-toggle__slider"/>
                  </label>
                </div>
              </div>
              <div className="as-group">
                <div className="as-toggle-row">
                  <div>
                    <div className="as-label" style={{ color: '#ec4899' }}>Hiển thị Dữ liệu Ảo (Mock Data)</div>
                    <div className="as-hint">Bật hiển thị 7 Gia sư ảo và 20 Lớp học ảo chống Cold-Start (các dữ liệu thật được xếp lên trước).</div>
                  </div>
                  <label className="as-toggle" style={{ '--color-primary': '#ec4899' } as React.CSSProperties}>
                    <input type="checkbox" checked={settings.mockDataEnabled} onChange={e => set('mockDataEnabled', e.target.checked)}/>
                    <span className="as-toggle__slider"/>
                  </label>
                </div>
              </div>
            </div>
          )}

          {/* ── Bảo mật (Đã cấu hình hard-code Server-side, ẩn thông số UI) ── */}
          {activeSection === 'security' && (
            <div className="as-section">
              <h2 className="as-section__title">Bảo mật & Xác thực</h2>
              <div className="as-group">
                <p className="as-hint">Lưu ý: Các cấu hình bảo mật như Session Timeout hiện đã được cấu hình cố định phía Server-side để tối ưu hệ thống và bảo mật (1 ngày với Admin, 7-365 ngày với User).</p>
              </div>
            </div>
          )}

          {/* ── Thông báo ── */}
          {activeSection === 'notify' && (
            <div className="as-section">
              <h2 className="as-section__title">Cài đặt thông báo Email</h2>
              {([
                { key: 'emailOnNewUser'       as const, label: 'Người dùng mới đăng ký',      hint: 'Gửi email khi tài khoản mới được tạo' },
                { key: 'emailOnVerification'  as const, label: 'Hồ sơ gia sư chờ duyệt',      hint: 'Gửi nhắc nhở khi có hồ sơ đang chờ xét' },
                { key: 'emailOnNewClass'      as const, label: 'Lớp học mới được tạo',        hint: 'Gửi email khi phụ huynh đăng lớp mới' },
                { key: 'emailOnPayment'       as const, label: 'Giao dịch thanh toán',        hint: 'Gửi email khi có giao dịch mới phát sinh' },
              ] as const).map(r => (
                <div className="as-group" key={r.key}>
                  <div className="as-toggle-row">
                    <div>
                      <div className="as-label">{r.label}</div>
                      <div className="as-hint">{r.hint}</div>
                    </div>
                    <label className="as-toggle">
                      <input type="checkbox" checked={settings[r.key]} onChange={e => set(r.key, e.target.checked)}/>
                      <span className="as-toggle__slider"/>
                    </label>
                  </div>
                </div>
              ))}
            </div>
          )}

          {/* ── Giao diện ── */}
          {activeSection === 'appearance' && (
            <div className="as-section">
              <h2 className="as-section__title">Tuỳ chỉnh giao diện</h2>
              <div className="as-group">
                <label className="as-label">Màu chủ đạo</label>
                <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                  <input type="color" value={settings.primaryColor} onChange={e => set('primaryColor', e.target.value)}
                    style={{ width: 44, height: 44, borderRadius: 8, border: 'none', cursor: 'pointer', padding: 2 }}/>
                  <span style={{ fontFamily: 'monospace', fontSize: '0.9rem', fontWeight: 700, color: settings.primaryColor }}>{settings.primaryColor}</span>
                </div>
                <span className="as-hint">Màu áp dụng ngay lập tức — bấm "Lưu cài đặt" để lưu vĩnh viễn</span>
              </div>
              <div className="as-group">
                <label className="as-label" style={{ marginBottom: 8 }}>Màu gợi ý</label>
                <div className="as-color-presets">
                  {[
                    { hex: '#6366f1', name: 'Indigo' },
                    { hex: '#8b5cf6', name: 'Violet' },
                    { hex: '#0ea5e9', name: 'Sky' },
                    { hex: '#10b981', name: 'Emerald' },
                    { hex: '#f59e0b', name: 'Amber' },
                    { hex: '#ef4444', name: 'Red' },
                    { hex: '#ec4899', name: 'Pink' },
                    { hex: '#14b8a6', name: 'Teal' },
                  ].map(c => (
                    <button
                      key={c.hex}
                      title={c.name}
                      onClick={() => set('primaryColor', c.hex)}
                      style={{
                        width: 36, height: 36, borderRadius: 10, background: c.hex, border: 'none', cursor: 'pointer',
                        boxShadow: settings.primaryColor === c.hex ? `0 0 0 3px #fff, 0 0 0 5px ${c.hex}` : 'none',
                        transform: settings.primaryColor === c.hex ? 'scale(1.15)' : 'scale(1)',
                        transition: 'all 0.15s',
                      }}
                    />
                  ))}
                </div>
              </div>
              {/* Preview */}
              <div className="as-group" style={{ marginTop: 8 }}>
                <label className="as-label">Xem trước</label>
                <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
                  <button style={{ padding: '8px 20px', borderRadius: 10, background: settings.primaryColor, color: '#fff', border: 'none', fontWeight: 700, fontSize: '0.88rem', cursor: 'default' }}>
                    Button chính
                  </button>
                  <button style={{ padding: '8px 20px', borderRadius: 10, background: settings.primaryColor + '15', color: settings.primaryColor, border: `1.5px solid ${settings.primaryColor}55`, fontWeight: 700, fontSize: '0.88rem', cursor: 'default' }}>
                    Button phụ
                  </button>
                  <span style={{ padding: '5px 14px', borderRadius: 20, background: settings.primaryColor + '15', color: settings.primaryColor, fontSize: '0.8rem', fontWeight: 700 }}>
                    Badge
                  </span>
                </div>
              </div>
            </div>
          )}

          {/* ── Thanh toán ── */}
          {activeSection === 'payment' && (
            <div className="as-section">
              <h2 className="as-section__title">Cấu hình thanh toán (VietQR)</h2>
              <p style={{ fontSize: '0.85rem', color: '#64748b', marginBottom: 16 }}>
                Cấu hình tài khoản ngân hàng để tạo mã QR thanh toán cho Phụ huynh. Thông tin này sẽ hiển thị trên trang thanh toán.
              </p>
              <div className="as-group">
                <label className="as-label">Mã BIN ngân hàng <span style={{ color: '#ef4444' }}>*</span></label>
                <input className="as-input" value={settings.vietqrBankBin} onChange={e => set('vietqrBankBin', e.target.value)} placeholder="Ví dụ: 970418"/>
                <span className="as-hint">Mã BIN theo chuẩn VietQR. Xem bảng bên dưới.</span>
              </div>
              <div className="as-group">
                <label className="as-label">Số tài khoản <span style={{ color: '#ef4444' }}>*</span></label>
                <input className="as-input" value={settings.vietqrBankAccount} onChange={e => set('vietqrBankAccount', e.target.value)} placeholder="Nhập số tài khoản ngân hàng"/>
              </div>
              <div className="as-group">
                <label className="as-label">Tên chủ tài khoản <span style={{ color: '#ef4444' }}>*</span></label>
                <input className="as-input" value={settings.vietqrAccountName} onChange={e => set('vietqrAccountName', e.target.value)} placeholder="Ví dụ: NGUYEN VAN A"/>
                <span className="as-hint">Viết HOA không dấu, đúng tên trên tài khoản ngân hàng.</span>
              </div>

              {/* Preview QR */}
              {settings.vietqrBankBin && settings.vietqrBankAccount && (
                <div className="as-group" style={{ marginTop: 12 }}>
                  <label className="as-label">Xem trước mã QR</label>
                  <div style={{ background: '#f8fafc', padding: 16, borderRadius: 12, border: '1px solid #e2e8f0', display: 'inline-block' }}>
                    <img
                      src={`https://img.vietqr.io/image/${settings.vietqrBankBin}-${settings.vietqrBankAccount}-compact.jpg?amount=100000&addInfo=TEST&accountName=${encodeURIComponent(settings.vietqrAccountName || 'TEST')}`}
                      width={180} height={180}
                      alt="VietQR Preview"
                      style={{ borderRadius: 8 }}
                      crossOrigin="anonymous"
                      onError={e => { (e.target as HTMLImageElement).style.display = 'none'; }}
                    />
                  </div>
                  <span className="as-hint">QR mẫu với số tiền 100,000đ và nội dung "TEST"</span>
                </div>
              )}

              {/* Bảng mã BIN */}
              <div className="as-group" style={{ marginTop: 16 }}>
                <label className="as-label" style={{ marginBottom: 8 }}>Bảng mã BIN phổ biến</label>
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(200px, 1fr))', gap: 8 }}>
                  {[
                    { bin: '970418', name: 'BIDV' },
                    { bin: '970436', name: 'Vietcombank' },
                    { bin: '970415', name: 'VietinBank' },
                    { bin: '970422', name: 'MB Bank' },
                    { bin: '970416', name: 'ACB' },
                    { bin: '970405', name: 'AgriBank' },
                    { bin: '970448', name: 'OCB' },
                    { bin: '970407', name: 'Techcombank' },
                    { bin: '970423', name: 'TPBank' },
                    { bin: '970432', name: 'VPBank' },
                    { bin: '970403', name: 'Sacombank' },
                    { bin: '970454', name: 'VietCapital' },
                  ].map(b => (
                    <button
                      key={b.bin}
                      onClick={() => set('vietqrBankBin', b.bin)}
                      style={{
                        padding: '8px 12px', borderRadius: 8, border: '1px solid #e2e8f0', cursor: 'pointer',
                        background: settings.vietqrBankBin === b.bin ? 'rgba(99,102,241,0.1)' : '#fff',
                        color: settings.vietqrBankBin === b.bin ? '#6366f1' : '#475569',
                        fontWeight: settings.vietqrBankBin === b.bin ? 700 : 500,
                        fontSize: '0.82rem', textAlign: 'left',
                      }}
                    >
                      <strong>{b.bin}</strong> — {b.name}
                    </button>
                  ))}
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
