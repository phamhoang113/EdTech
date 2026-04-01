import { CreditCard, QrCode, CheckCircle, Clock, Copy } from 'lucide-react';
import { useState, useEffect } from 'react';
import { studentApi } from '../../services/studentApi';
import { StudentSidebar } from '../../components/student/StudentSidebar';
import { DashboardHeader } from '../../components/layout/DashboardHeader';

import './Dashboard.css';

interface Billing {
  id: string;
  classId: string;
  classCode: string;
  classTitle: string;
  month: number;
  year: number;
  totalSessions: number;
  parentFeeAmount: number;
  transactionCode: string;
  status: 'UNPAID' | 'VERIFYING' | 'PAID' | 'CANCELLED';
  qrDataStr: string | null;
  studentNames: string | null;
  beneficiaryBank?: string;
  beneficiaryAccount?: string;
  beneficiaryName?: string;
}

export const StudentPaymentPage = () => {
  const [loading, setLoading] = useState<boolean>(true);
  const [toast, setToast] = useState<{ type: 'success' | 'error'; msg: string } | null>(null);
  const [confirmingTx, setConfirmingTx] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<'pending' | 'history'>('pending');

  // Grouped by transaction code
  const [groupedBillings, setGroupedBillings] = useState<Record<string, Billing[]>>({});

  useEffect(() => {
    setLoading(true);
    studentApi.getBillings()
      .then(res => {
        const data = res.data ?? [];
        
        // Group by transactionCode
        const groups: Record<string, Billing[]> = {};
        data.forEach(b => {
          if (!groups[b.transactionCode]) groups[b.transactionCode] = [];
          groups[b.transactionCode].push(b);
        });
        setGroupedBillings(groups);
      })
      .catch((e: any) => {
        showToast('error', e?.response?.data?.message ?? 'Lỗi khi tải danh sách hoá đơn');
      })
      .finally(() => setLoading(false));
  }, []);

  const showToast = (type: 'success' | 'error', msg: string) => {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 3500);
  };

  const handleCopy = (text: string, label: string) => {
    navigator.clipboard.writeText(text)
      .then(() => showToast('success', `Đã sao chép ${label}`))
      .catch(() => showToast('error', 'Trình duyệt không hỗ trợ sao chép'));
  };

  const loadData = () => {
    studentApi.getBillings().then(res => {
      const data = res.data ?? [];
      const groups: Record<string, Billing[]> = {};
      data.forEach(b => {
        if (!groups[b.transactionCode]) groups[b.transactionCode] = [];
        groups[b.transactionCode].push(b);
      });
      setGroupedBillings(groups);
    });
  };

  const handleConfirm = async (txCode: string, bills: Billing[]) => {
    setConfirmingTx(txCode);
    try {
      const unpaidBills = bills.filter(b => b.status === 'UNPAID');
      await Promise.all(unpaidBills.map(b => studentApi.confirmTransfer(b.id)));
      showToast('success', 'Đã lưu xác nhận. Đang chờ kế toán kiểm duyệt.');
      window.dispatchEvent(new Event('refetchBadgeCounts'));
      loadData();
    } catch (e: any) {
      showToast('error', e?.response?.data?.message || 'Lỗi khi xác nhận chuyển khoản');
    } finally {
      setConfirmingTx(null);
    }
  };

  return (
    <div className="dash-page">
      <StudentSidebar active="payments" />

      <main className="dash-main">
        <DashboardHeader />

        <div className="dash-body">
          <div className="dash-section-head">
            <h1 className="dash-section-title" style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: '1.4rem' }}>
              <CreditCard size={24} className="text-indigo" />
              Thanh toán & Học phí
            </h1>
          </div>

          {!loading && Object.values(groupedBillings).some(bills => bills.some(b => b.status === 'UNPAID')) && (
            <div style={{
              background: 'linear-gradient(135deg, #ef4444, #dc2626)',
              color: 'white',
              borderRadius: 16,
              padding: '16px 24px',
              marginBottom: 24,
              display: 'flex',
              alignItems: 'center',
              gap: 16,
              boxShadow: '0 8px 30px rgba(239, 68, 68, 0.25)',
              border: '1px solid rgba(255,255,255,0.1)'
            }}>
              <div style={{ background: 'rgba(255,255,255,0.2)', padding: 12, borderRadius: 12, display: 'flex' }}>
                <Clock size={28} />
              </div>
              <div>
                <h3 style={{ margin: 0, fontSize: '1.15rem', fontWeight: 700, letterSpacing: '-0.01em' }}>Có hoá đơn cần thanh toán</h3>
                <p style={{ margin: '4px 0 0 0', opacity: 0.9, fontSize: '0.9rem', lineHeight: 1.4 }}>
                  Vui lòng quét mã QR bên dưới để thanh toán, sau đó nhấn <strong>"Tôi đã chuyển khoản"</strong> để thông báo cho kế toán.
                </p>
              </div>
            </div>
          )}

          <div style={{ display: 'flex', gap: 24, marginBottom: 24, borderBottom: '1px solid var(--color-border)' }}>
            <button 
              onClick={() => setActiveTab('pending')}
              style={{
                background: 'none', border: 'none', padding: '12px 0', fontSize: '1rem', fontWeight: activeTab === 'pending' ? 600 : 500,
                color: activeTab === 'pending' ? 'var(--color-indigo)' : 'var(--color-text-muted)', cursor: 'pointer',
                borderBottom: activeTab === 'pending' ? '2px solid var(--color-indigo)' : '2px solid transparent',
                transition: 'all 0.2s'
              }}
            >
              Cần thanh toán 
              {Object.values(groupedBillings).filter(bills => !bills.every(b => b.status === 'PAID')).length > 0 && (
                <span style={{ marginLeft: 8, background: '#ef4444', color: 'white', padding: '2px 8px', borderRadius: 12, fontSize: '0.75rem' }}>
                  {Object.values(groupedBillings).filter(bills => !bills.every(b => b.status === 'PAID')).length}
                </span>
              )}
            </button>
            <button 
              onClick={() => setActiveTab('history')}
              style={{
                background: 'none', border: 'none', padding: '12px 0', fontSize: '1rem', fontWeight: activeTab === 'history' ? 600 : 500,
                color: activeTab === 'history' ? 'var(--color-indigo)' : 'var(--color-text-muted)', cursor: 'pointer',
                borderBottom: activeTab === 'history' ? '2px solid var(--color-indigo)' : '2px solid transparent',
                transition: 'all 0.2s'
              }}
            >
              Lịch sử giao dịch ({Object.values(groupedBillings).filter(bills => bills.every(b => b.status === 'PAID')).length})
            </button>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: 20 }}>
            {loading ? (
              <p style={{ textAlign: 'center', color: 'var(--color-text-muted)', padding: 30 }}>Đang tải hoá đơn...</p>
            ) : (() => {
              const displayGroups = Object.entries(groupedBillings)
                .filter(([, bills]) => activeTab === 'pending' ? !bills.every(b => b.status === 'PAID') : bills.every(b => b.status === 'PAID'))
                .sort((a, b) => b[0].localeCompare(a[0]));

              if (displayGroups.length === 0) {
                return (
                  <div style={{ textAlign: 'center', color: 'var(--color-text-muted)', padding: 50, background: 'var(--color-surface)', borderRadius: 16, border: '1px dashed var(--color-border)' }}>
                    {activeTab === 'pending' ? (
                      <>
                        <CheckCircle size={48} style={{ opacity: 0.3, marginBottom: 16, color: 'var(--color-emerald)' }} />
                        <p style={{ fontSize: '1.05rem', margin: 0 }}>Tuyệt vời! Bạn không có hoá đơn nào cần thanh toán.</p>
                      </>
                    ) : (
                      <>
                        <Clock size={48} style={{ opacity: 0.2, marginBottom: 16 }} />
                        <p style={{ fontSize: '1.05rem', margin: 0 }}>Chưa có lịch sử giao dịch nào gửi thành công.</p>
                      </>
                    )}
                  </div>
                );
              }

              return displayGroups.map(([txCode, bills]) => {
                const totalAmount = bills.reduce((sum, b) => sum + b.parentFeeAmount, 0);
                const isPaid = bills.every(b => b.status === 'PAID');
                const firstBill = bills[0];
                const monthStr = `${firstBill.month}/${firstBill.year}`;
                const qrStr = firstBill.qrDataStr;

                return (
                  <div key={txCode} className="dash-panel" style={{ display: 'flex', gap: 24, flexWrap: 'wrap', opacity: activeTab === 'history' ? 0.9 : 1 }}>
                    
                    {/* Danh sách lớp của mã GD này */}
                    <div style={{ flex: 1, minWidth: 300 }}>
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 16 }}>
                        <div>
                          <h3 style={{ fontSize: '1.1rem', marginBottom: 4, display: 'flex', alignItems: 'center', gap: 8 }}>
                            Kỳ học phí: Tháng {monthStr}
                            {isPaid ? (
                              <span style={{ fontSize: '0.75rem', padding: '2px 8px', borderRadius: 12, background: 'rgba(16, 185, 129, 0.1)', color: 'var(--color-emerald)', fontWeight: 700, display: 'flex', alignItems: 'center', gap: 4 }}>
                                <CheckCircle size={12} /> Đã thanh toán
                              </span>
                            ) : bills.every(b => b.status === 'VERIFYING' || b.status === 'PAID') ? (
                              <span style={{ fontSize: '0.75rem', padding: '2px 8px', borderRadius: 12, background: 'rgba(99, 102, 241, 0.1)', color: 'var(--color-indigo)', fontWeight: 700, display: 'flex', alignItems: 'center', gap: 4 }}>
                                <Clock size={12} /> Đang đối soát
                              </span>
                            ) : (
                              <span style={{ fontSize: '0.75rem', padding: '2px 8px', borderRadius: 12, background: 'rgba(245, 158, 11, 0.1)', color: '#f59e0b', fontWeight: 700, display: 'flex', alignItems: 'center', gap: 4 }}>
                                <Clock size={12} /> Cần thanh toán
                              </span>
                            )}
                          </h3>
                          <p style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)', fontFamily: 'monospace' }}>Mã GD: {txCode}</p>
                        </div>
                      </div>

                      <div style={{ background: 'var(--color-surface-2)', border: '1px solid var(--color-border)', borderRadius: 12, overflow: 'hidden' }}>
                        <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '0.85rem' }}>
                          <thead style={{ background: 'rgba(0,0,0,0.02)' }}>
                            <tr>
                              <th style={{ padding: '12px 16px', borderBottom: '1px solid var(--color-border)' }}>Lớp học</th>
                              <th style={{ padding: '12px 16px', borderBottom: '1px solid var(--color-border)' }}>Số buổi</th>
                              <th style={{ padding: '12px 16px', borderBottom: '1px solid var(--color-border)', textAlign: 'right' }}>Thành tiền</th>
                            </tr>
                          </thead>
                          <tbody>
                            {bills.map(b => (
                              <tr key={b.id}>
                                <td style={{ padding: '12px 16px', borderBottom: '1px solid var(--color-border)' }}>
                                  <div style={{ fontWeight: 600 }}>{b.classTitle}</div>
                                  <div style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)', marginTop: 2 }}>
                                    Mã: {b.classCode} {b.studentNames && ` • HS: ${b.studentNames}`}
                                  </div>
                                </td>
                                <td style={{ padding: '12px 16px', borderBottom: '1px solid var(--color-border)' }}>{b.totalSessions}</td>
                                <td style={{ padding: '12px 16px', borderBottom: '1px solid var(--color-border)', textAlign: 'right', fontWeight: 600, color: 'var(--color-indigo)' }}>
                                  {b.parentFeeAmount.toLocaleString('vi-VN')} ₫
                                </td>
                              </tr>
                            ))}
                          </tbody>
                          <tfoot>
                            <tr style={{ background: 'rgba(99, 102, 241, 0.04)' }}>
                              <td colSpan={2} style={{ padding: '14px 16px', fontWeight: 700, textAlign: 'right' }}>Tổng cộng:</td>
                              <td style={{ padding: '14px 16px', fontWeight: 800, textAlign: 'right', color: 'var(--color-indigo)', fontSize: '1rem' }}>
                                {totalAmount.toLocaleString('vi-VN')} ₫
                              </td>
                            </tr>
                          </tfoot>
                        </table>
                      </div>
                    </div>

                    {/* QR Code Section */}
                    {!isPaid && (
                      <div style={{ width: 300, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', background: 'var(--color-surface)', padding: '20px 16px', borderRadius: 16, border: '1px solid var(--color-indigo)', boxShadow: '0 4px 20px rgba(99, 102, 241, 0.1)' }}>
                        <h4 style={{ marginBottom: 16, fontSize: '0.95rem', fontWeight: 600, color: 'var(--color-indigo)', display: 'flex', alignItems: 'center', gap: 6 }}>
                          <QrCode size={18} /> Quét mã để thanh toán
                        </h4>
                        
                        <div style={{ background: '#fff', padding: 8, borderRadius: 12, marginBottom: 16, border: '1px solid #e5e7eb' }}>
                          {qrStr ? (
                            <img src={qrStr} width="164" height="164" alt="VietQR" style={{ display: 'block' }} crossOrigin="anonymous" />
                          ) : (
                            <div style={{ width: 164, height: 164, display: 'flex', alignItems: 'center', justifyContent: 'center', background: 'var(--color-surface-2)', color: 'var(--color-text-muted)', fontSize: '0.8rem', textAlign: 'center', padding: 10 }}>
                              Không thể tạo mã QR<br/>Vui lòng liên hệ Admin
                            </div>
                          )}
                        </div>
                        
                        <div style={{ fontSize: '0.8rem', textAlign: 'left', color: 'var(--color-text-muted)', lineHeight: 1.6, width: '100%', marginTop: 8, padding: '0 8px' }}>
                          <div style={{ marginBottom: 4 }}>Ngân hàng: <strong style={{ color: 'var(--color-heading)' }}>{firstBill.beneficiaryBank || 'BIDV'}</strong></div>
                          <div style={{ marginBottom: 4, display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                            <span>Số TK: <strong style={{ color: 'var(--color-heading)', fontSize: '0.9rem' }}>{firstBill.beneficiaryAccount || '0976947441'}</strong></span>
                            <button onClick={() => handleCopy(firstBill.beneficiaryAccount || '0976947441', 'Số tài khoản')} style={{ background: 'none', border: 'none', color: '#6366f1', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 4 }} title="Sao chép">
                              <Copy size={16} />
                            </button>
                          </div>
                          <div style={{ marginBottom: 16 }}>Chủ TK: <strong style={{ color: 'var(--color-heading)' }}>{firstBill.beneficiaryName || 'CONG TY GIA SU TINH HOA'}</strong></div>

                          <div style={{ background: 'var(--color-surface-hover)', padding: '10px 12px', borderRadius: 8, marginBottom: 8, border: '1px dashed var(--color-border)', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                            <span>
                              <span style={{ fontSize: '0.8rem', color: '#64748b', marginRight: 8 }}>Nội dung CK:</span>
                              <strong style={{ color: '#6366f1', userSelect: 'all', fontSize: '0.95rem', letterSpacing: '0.02em' }}>{txCode}</strong>
                            </span>
                            <button onClick={() => handleCopy(txCode, 'Nội dung chuyển khoản')} style={{ background: 'none', border: 'none', color: '#6366f1', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 4 }} title="Sao chép">
                              <Copy size={16} />
                            </button>
                          </div>

                          {bills.some(b => b.status === 'VERIFYING') ? (
                            <div style={{ color: 'var(--color-indigo)', fontWeight: 600, padding: '10px 8px', background: 'rgba(99, 102, 241, 0.1)', borderRadius: 8, marginTop: 16, textAlign: 'center', border: '1px solid rgba(99, 102, 241, 0.2)' }}>
                              Đang chờ kế toán xác nhận
                            </div>
                          ) : (
                            <>
                              <div style={{ marginTop: 12, textAlign: 'center', fontSize: '0.75rem' }}>Sau khi chuyển khoản, vui lòng bấm nút dưới đây để thông báo.</div>
                              <button 
                                onClick={() => handleConfirm(txCode, bills)}
                                disabled={confirmingTx === txCode}
                                style={{
                                  width: '100%', marginTop: 12, display: 'flex', justifyContent: 'center', alignItems: 'center', gap: 8,
                                  background: 'linear-gradient(135deg, #10b981, #059669)',
                                  color: 'white',
                                  border: 'none',
                                  padding: '12px 16px',
                                  borderRadius: 12,
                                  fontWeight: 600,
                                  fontSize: '0.9rem',
                                  cursor: confirmingTx === txCode ? 'not-allowed' : 'pointer',
                                  opacity: confirmingTx === txCode ? 0.7 : 1,
                                  boxShadow: '0 4px 15px rgba(16, 185, 129, 0.3)',
                                  transition: 'all 0.2s ease'
                                }}
                                onMouseOver={(e: any) => e.currentTarget.style.transform = 'translateY(-2px)'}
                                onMouseOut={(e: any) => e.currentTarget.style.transform = 'translateY(0)'}
                              >
                                {confirmingTx === txCode ? (
                                  <><Clock size={18} className="spin" /> Đang gửi...</>
                                ) : (
                                  <><CheckCircle size={18} /> TÔI ĐÃ CHUYỂN KHOẢN</>
                                )}
                              </button>
                            </>
                          )}
                        </div>
                      </div>
                    )}

                  </div>
                );
              });
            })()}
          </div>
        </div>
      </main>

      {/* Toast */}
      {toast && (
        <div style={{
          position: 'fixed', bottom: 24, right: 24, zIndex: 9999,
          padding: '10px 20px', borderRadius: 12, fontWeight: 600, fontSize: '0.88rem',
          background: toast.type === 'success' ? '#ecfdf5' : '#fef2f2',
          color: toast.type === 'success' ? '#065f46' : '#b91c1c',
          border: `1px solid ${toast.type === 'success' ? 'rgba(5,150,105,0.3)' : 'rgba(239,68,68,0.3)'}`,
          boxShadow: '0 4px 20px rgba(0,0,0,0.12)'
        }}>
          {toast.type === 'success' ? '✓ ' : '✕ '}{toast.msg}
        </div>
      )}
    </div>
  );
};
