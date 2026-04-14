import React, { useState, useEffect } from 'react';
import { X, Download, FileText, Loader2 } from 'lucide-react';
import apiClient from '../services/apiClient';

interface FilePreviewModalProps {
  isOpen: boolean;
  onClose: () => void;
  fileName: string;
  downloadUrl: string; // The URL to call with GET (returns bytes)
  fileUrl?: string; // Optional old prop.
}

export const FilePreviewModal: React.FC<FilePreviewModalProps> = ({
  isOpen,
  onClose,
  fileName,
  downloadUrl
}) => {
  const [blobUrl, setBlobUrl] = useState<string | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!isOpen || !downloadUrl) {
      if (blobUrl) {
        URL.revokeObjectURL(blobUrl);
        setBlobUrl(null);
      }
      return;
    }

    const lowerName = fileName.toLowerCase();
    const isWord = /\.(doc|docx|xls|xlsx|ppt|pptx)$/.test(lowerName);
    const isPdf = /\.pdf$/.test(lowerName);
    
    if (isWord) {
      setLoading(false);
      return;
    }

    let isMounted = true;
    setLoading(true);
    setError(null);

    // Dùng apiClient để fetch file (đã tự động có Bearer JWT trong Header)
    apiClient.get(downloadUrl, { responseType: 'blob' })
      .then(res => {
        if (!isMounted) return;
        const blob = new Blob([res.data], { 
          type: isPdf ? 'application/pdf' : res.headers['content-type'] 
        });
        const url = URL.createObjectURL(blob);
        setBlobUrl(url);
        setLoading(false);
      })
      .catch(err => {
        if (!isMounted) return;
        console.error('Lỗi tải file:', err);
        setError('Không thể tải bản xem trước.');
        setLoading(false);
      });

    return () => {
      isMounted = false;
    };
  }, [isOpen, downloadUrl, fileName]);

  if (!isOpen) return null;

  const lowerName = fileName.toLowerCase();
  const isImage = /\.(jpg|jpeg|png|gif|webp)$/.test(lowerName);
  const isPdf = /\.pdf$/.test(lowerName);
  const isWord = /\.(doc|docx|xls|xlsx|ppt|pptx)$/.test(lowerName);

  const handleDownload = async () => {
    try {
      const res = await apiClient.get(downloadUrl, { responseType: 'blob' });
      const blob = new Blob([res.data]);
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = fileName;
      document.body.appendChild(a);
      a.click();
      a.remove();
      URL.revokeObjectURL(url);
    } catch (e) {
      console.error('Download failed', e);
      alert('Tải file thất bại!');
    }
  };

  return (
    <div style={{
      position: 'fixed', inset: 0, zIndex: 99999, 
      backgroundColor: 'rgba(15, 23, 42, 0.95)', backdropFilter: 'blur(10px)',
      display: 'flex', flexDirection: 'column'
    }}>
      <div style={{ height: '64px', padding: '0 24px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', borderBottom: '1px solid rgba(255,255,255,0.1)' }}>
        <h3 style={{ color: '#fff', margin: 0, fontSize: '1.05rem', fontWeight: 500, display: 'flex', alignItems: 'center', gap: '8px' }}>
          {fileName}
        </h3>
        <div style={{ display: 'flex', gap: '20px' }}>
          <button 
            onClick={handleDownload}
            style={{ background: 'transparent', border: 'none', color: '#fff', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '8px', padding: '8px 12px', borderRadius: '8px' }}
            onMouseOver={(e) => e.currentTarget.style.backgroundColor = 'rgba(255,255,255,0.1)'}
            onMouseOut={(e) => e.currentTarget.style.backgroundColor = 'transparent'}
          >
            <Download size={20} /> <span style={{fontSize: '0.95rem'}}>Tải về</span>
          </button>
          <button 
            onClick={onClose} 
            style={{ background: 'rgba(255,255,255,0.1)', border: 'none', color: '#fff', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', width: '40px', height: '40px', borderRadius: '50%' }}
            onMouseOver={(e) => e.currentTarget.style.backgroundColor = 'rgba(255,255,255,0.2)'}
            onMouseOut={(e) => e.currentTarget.style.backgroundColor = 'rgba(255,255,255,0.1)'}
          >
            <X size={24} />
          </button>
        </div>
      </div>

      <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '32px', overflow: 'hidden' }}>
        {loading && (
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', color: '#fff', gap: '16px' }}>
            <Loader2 size={48} style={{ animation: 'spin 1s linear infinite', color: '#6366F1' }} />
            <p>Đang tải bản xem trước...</p>
          </div>
        )}
        
        {!loading && error && (
          <div style={{ color: '#FCA5A5', backgroundColor: 'rgba(254,226,226,0.1)', padding: '20px 32px', borderRadius: '12px' }}>
            {error}
          </div>
        )}

        {!loading && !error && isWord && (
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', color: '#fff', gap: '16px', background: 'rgba(255,255,255,0.05)', padding: '48px', borderRadius: '24px' }}>
            <FileText size={80} color="#60A5FA" />
            <h2 style={{margin: 0, fontWeight: 500}}>Định dạng không hỗ trợ xem trước</h2>
            <p style={{ color: '#94A3B8', marginTop: 0 }}>Vui lòng tải file xuống để xem nội dung.</p>
            <button onClick={handleDownload} style={{ padding: '12px 24px', background: '#6366F1', color: '#fff', border: 'none', borderRadius: '12px', fontSize: '1rem', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '8px', marginTop: '8px' }}>
              <Download size={20} /> Tải xuống ngay
            </button>
          </div>
        )}

        {!loading && !error && blobUrl && !isImage && !isPdf && !isWord && (
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', color: '#fff', gap: '16px', background: 'rgba(255,255,255,0.05)', padding: '48px', borderRadius: '24px' }}>
            <FileText size={80} color="#60A5FA" />
            <h2 style={{margin: 0, fontWeight: 500}}>Chưa hỗ trợ xem trước file này</h2>
            <p style={{ color: '#94A3B8', marginTop: 0 }}>Vui lòng tải file xuống để đọc nội dung.</p>
            <button onClick={handleDownload} style={{ padding: '12px 24px', background: '#6366F1', color: '#fff', border: 'none', borderRadius: '12px', fontSize: '1rem', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '8px', marginTop: '8px' }}>
              <Download size={20} /> Tải xuống ngay
            </button>
          </div>
        )}

        {!loading && !error && blobUrl && isImage && (
          <img src={blobUrl} alt={fileName} style={{ maxWidth: '100%', maxHeight: '100%', objectFit: 'contain', borderRadius: '8px', boxShadow: '0 20px 40px rgba(0,0,0,0.5)' }} />
        )}

        {!loading && !error && blobUrl && isPdf && (
           <iframe src={`${blobUrl}#toolbar=0`} style={{ width: '100%', height: '100%', border: 'none', borderRadius: '12px', backgroundColor: '#fff' }} title={fileName} />
        )}
      </div>

      <style>{`
        @keyframes spin {
          from { transform: rotate(0deg); }
          to { transform: rotate(360deg); }
        }
      `}</style>
    </div>
  );
};
