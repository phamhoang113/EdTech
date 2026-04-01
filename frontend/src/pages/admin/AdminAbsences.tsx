import { CheckCircle, XCircle, Calendar, BookOpen, AlertCircle } from 'lucide-react';
import { useState, useEffect, useCallback } from 'react';
import { adminAbsenceApi } from '../../services/adminAbsenceApi';
import type { AdminAbsenceRequestDTO } from '../../services/adminAbsenceApi';

import './AdminAbsences.css';

function fmtDate(iso: string | null | undefined) {
  if (!iso) return '—';
  const d = new Date(iso);
  return `${String(d.getDate()).padStart(2, '0')}/${String(d.getMonth() + 1).padStart(2, '0')}/${d.getFullYear()}`;
}

const TYPE_LABEL: Record<string, string> = {
  TUTOR_LEAVE: 'Gia sư xin nghỉ',
  STUDENT_LEAVE: 'Học sinh xin nghỉ'
};

const STATUS_LABEL: Record<string, string> = {
  PENDING: 'Chờ duyệt',
  APPROVED: 'Đã duyệt',
  REJECTED: 'Đã từ chối'
};

export function AdminAbsences() {
  const [requests, setRequests] = useState<AdminAbsenceRequestDTO[]>([]);
  const [loading, setLoading] = useState(true);
  const [toast, setToast] = useState<{ type: 'success' | 'error'; msg: string } | null>(null);

  const [activeTab, setActiveTab] = useState<'PENDING' | 'PROCESSED'>('PENDING');

  const showToast = (type: 'success' | 'error', msg: string) => {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 3000);
  };

  const fetchRequests = useCallback(async () => {
    try {
      setLoading(true);
      const res = await adminAbsenceApi.getAllRequests();
      // sort by date desc
      const sorted = res.data.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
      setRequests(sorted);
    } catch {
      showToast('error', 'Không thể tải danh sách đơn xin nghỉ');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchRequests();
  }, [fetchRequests]);

  const handleApprove = async (id: string) => {
    try {
      await adminAbsenceApi.approveRequest(id);
      showToast('success', 'Đã duyệt đơn nghỉ. Hệ thống đã đánh dấu phiên học này huỷ.');
      fetchRequests();
    } catch {
      showToast('error', 'Lỗi khi duyệt đơn');
    }
  };

  const handleReject = async (id: string) => {
    if(!window.confirm('Bạn có chắc chắn muốn TỪ CHỐI đơn này?')) return;
    try {
      await adminAbsenceApi.rejectRequest(id);
      showToast('success', 'Đã từ chối đơn.');
      fetchRequests();
    } catch {
      showToast('error', 'Lỗi khi từ chối đơn');
    }
  };

  const filteredRequests = requests.filter(r => 
    activeTab === 'PENDING' ? r.status === 'PENDING' : r.status !== 'PENDING'
  );

  return (
    <div className="admin-absences">
      {toast && (
        <div style={{
          position: 'fixed', bottom: 24, right: 24, zIndex: 9999, padding: '10px 20px',
          borderRadius: 10, fontWeight: 600, fontSize: '0.88rem',
          background: toast.type === 'success' ? '#ecfdf5' : '#fef2f2',
          color: toast.type === 'success' ? '#065f46' : '#b91c1c',
          border: `1px solid ${toast.type === 'success' ? 'rgba(5,150,105,0.3)' : 'rgba(239,68,68,0.3)'}`,
          boxShadow: '0 4px 16px rgba(0,0,0,0.1)',
        }}>
          {toast.type === 'success' ? '✓ ' : '✕ '}{toast.msg}
        </div>
      )}

      <div className="admin-absences-header">
        <div>
          <h1 className="title">Xếp lịch bù & Duyệt nghỉ</h1>
          <p className="subtitle">Quản lý các đơn báo nghỉ học từ phía Học sinh / Gia sư</p>
        </div>
      </div>

      <div className="admin-tabs">
        <button 
          className={`admin-tab ${activeTab === 'PENDING' ? 'active' : ''}`}
          onClick={() => setActiveTab('PENDING')}
        >
          Chờ xử lý ({requests.filter(r => r.status === 'PENDING').length})
        </button>
        <button 
          className={`admin-tab ${activeTab === 'PROCESSED' ? 'active' : ''}`}
          onClick={() => setActiveTab('PROCESSED')}
        >
          Đã xử lý
        </button>
      </div>

      <div className="admin-absences-content">
        {loading ? (
          <div className="loading-state">Đang tải dữ liệu...</div>
        ) : filteredRequests.length === 0 ? (
          <div className="empty-state">
            <AlertCircle size={48} opacity={0.3} />
            <p>Không có đơn nghỉ nào trong mục này</p>
          </div>
        ) : (
          <div className="absences-grid">
            {filteredRequests.map(req => (
              <div key={req.id} className={`absence-card ${req.status.toLowerCase()}`}>
                <div className="ac-header">
                  <span className={`ac-type-badge ${req.requestType === 'TUTOR_LEAVE' ? 'tutor' : 'student'}`}>
                    {TYPE_LABEL[req.requestType] || req.requestType}
                  </span>
                  <span className={`ac-status-badge ${req.status.toLowerCase()}`}>
                    {STATUS_LABEL[req.status]}
                  </span>
                </div>
                
                <div className="ac-body">
                  <div className="ac-row">
                    <BookOpen size={16} />
                    <strong>{req.classTitle || 'Không rõ lớp'}</strong> ({req.subject})
                  </div>
                  <div className="ac-row">
                    <Calendar size={16} />
                    <span>Buổi học: <strong>{fmtDate(req.sessionDate)}</strong> (Từ {req.startTime} - {req.endTime})</span>
                  </div>
                  <div className="ac-reason-box">
                    <strong>Lý do: </strong> {req.reason || '(Không có)'}
                  </div>
                  <div className="ac-makeup-info">
                    {req.makeUpRequired ? (
                      <span className="req-makeup">⚠️ Có yêu cầu học bù</span>
                    ) : (
                      <span className="no-makeup">Không yêu cầu bù</span>
                    )}
                  </div>
                  <div className="ac-participants">
                    <div><small>Gia sư:</small> {req.tutorName || 'N/A'}</div>
                    <div><small>Học sinh:</small> {req.studentName || 'N/A'}</div>
                  </div>
                </div>

                {req.status === 'PENDING' && (
                  <div className="ac-actions">
                    <button className="btn-approve" onClick={() => handleApprove(req.id)}>
                      <CheckCircle size={16}/> Duyệt & Báo Huỷ Buổi
                    </button>
                    <button className="btn-reject" onClick={() => handleReject(req.id)}>
                      <XCircle size={16}/> Từ chối
                    </button>
                  </div>
                )}
                
                {req.status !== 'PENDING' && (
                  <div className="ac-footer-note">
                    Xử lý bởi: <strong>{req.reviewedBy || 'Hệ thống'}</strong> lúc {fmtDate(req.reviewedAt)}
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

export default AdminAbsences;
