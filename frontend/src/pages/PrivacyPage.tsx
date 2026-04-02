// @ts-nocheck
import { useOutletContext } from 'react-router-dom';
import type { PublicLayoutContext } from '../components/layout/PublicLayout';

import { ShieldCheck, Database, Lock, EyeOff } from 'lucide-react';


import './PrivacyPage.css';

export const PrivacyPage = () => {
  return (
    <div className="privacy-page">
      <main className="privacy-main">
        <div className="privacy-header">
          <div className="container">
            <h1 className="privacy-title">Chính sách Bảo mật</h1>
            <p className="privacy-subtitle">Bảo vệ dữ liệu của bạn là ưu tiên hàng đầu tại Gia Sư Tinh Hoa</p>
          </div>
        </div>

        <div className="container privacy-content-wrapper">
          <aside className="privacy-sidebar">
            <nav className="privacy-nav">
              <a href="#collection" className="privacy-nav-item active"><Database size={16}/> 1. Thu thập dữ liệu</a>
              <a href="#usage" className="privacy-nav-item"><EyeOff size={16}/> 2. Mục đích sử dụng</a>
              <a href="#protection" className="privacy-nav-item"><ShieldCheck size={16}/> 3. Bảo vệ an toàn</a>
              <a href="#sharing" className="privacy-nav-item"><Lock size={16}/> 4. Chia sẻ thông tin</a>
            </nav>
          </aside>

          <article className="privacy-article">
            <section id="collection" className="privacy-section">
              <h2>1. Thu thập Dữ liệu</h2>
              <p>
                Gia Sư Tinh Hoa chỉ thu thập những thông tin cần thiết nhất để phục vụ quá trình kết nối và học tập, bao gồm:
              </p>
              <ul>
                <li><strong>Thông tin cơ bản:</strong> Họ tên, email, số điện thoại, ngày sinh tóm tắt lịch sử giảng dạy.</li>
                <li><strong>Hồ sơ xác thực (chỉ dành cho Gia sư):</strong> Hình ảnh các bằng cấp, chứng chỉ, CCCD hoặc thẻ sinh viên dùng cho đối chiếu nghiêm ngặt nội bộ (không bêu hiếu trên nền tảng công khai).</li>
              </ul>
            </section>

            <section id="usage" className="privacy-section">
              <h2>2. Mục đích Sử dụng</h2>
              <p>Hệ thống không thu thập dữ liệu về mục đích theo dõi (tracking) tiếp thị chéo cho bên thứ ba. Dữ liệu chỉ dùng để:</p>
              <ul>
                <li>Phê duyệt hồ sơ đánh giá và cấp chứng nhận "Gia sư Tinh hoa".</li>
                <li>Gửi thông báo OTP, email lịch học và tin nhắn thông báo thay đổi tình trạng hợp đồng giảng dạy.</li>
                <li>Hỗ trợ xử lý tra soát và giải quyết khiếu nại nếu xảy ra tranh chấp học phí.</li>
              </ul>
            </section>

            <section id="protection" className="privacy-section">
              <h2>3. Bảo vệ & An toàn</h2>
              <p>
                Cơ sở dữ liệu của chúng tôi được lưu trữ trên các nền tảng điện toán đám mây đạt chuẩn bảo mật quốc tế.
                Toàn bộ dữ liệu mật khẩu đều được băm (hash) một chiều mã hóa mạnh (Bcrypt), ngay cả quản trị viên hệ thống cũng không thể đọc được mật khẩu gốc của bạn.
              </p>
              <div className="privacy-highlight-box">
                <strong>Cam kết OTP:</strong> Quý đối tác KHÔNG cung cấp mật khẩu hoặc mã OTP cho bất kỳ ai, kể cả là hỗ trợ viên (Hỗ trợ viên Gia Sư Tinh Hoa sẽ gọi điện nhắc nhở thông qua số hotline, nhưng không bao giờ hỏi mật khẩu của bạn).
              </div>
            </section>

            <section id="sharing" className="privacy-section">
              <h2>4. Quy định Chia sẻ Thông tin</h2>
              <p>
                Chúng tôi cam kết <strong>không bán</strong> tài nguyên dữ liệu của bạn phục vụ cho các tổ chức quảng cáo thương hiệu khác. 
                Thông tin cá nhân chỉ được chia sẻ một cách tự động khi người học và gia sư quyết định chấp nhận giao kết lịch học để trao đổi phương thức làm việc (như cho họ tên, sđt liên lạc với nhau).
              </p>
            </section>
          </article>
        </div>
      </main>

      </div>
  );
};
