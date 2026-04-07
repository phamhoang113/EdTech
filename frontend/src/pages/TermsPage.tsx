import { FileText, Shield, AlertTriangle, HelpCircle } from 'lucide-react';

import { SEO } from '../components/common/SEO';
import './TermsPage.css';

export const TermsPage = () => {
  return (
    <div className="terms-page">
      <SEO
        title="Điều khoản & Điều kiện | Gia Sư Tinh Hoa"
        description="Điều khoản sử dụng dịch vụ, chính sách thanh toán, hoàn phí và quy định dành cho Gia sư, Phụ huynh và Học sinh tại Gia Sư Tinh Hoa."
      />
      <main className="terms-main">
        <div className="terms-header">
          <div className="container">
            <h1 className="terms-title">Điều khoản & Điều kiện</h1>
            <p className="terms-subtitle">Cập nhật lần cuối: Tháng 4 năm 2026</p>
          </div>
        </div>

        <div className="container terms-content-wrapper">
          <aside className="terms-sidebar">
            <nav className="terms-nav">
              <a href="#introduction" className="terms-nav-item active"><FileText size={16}/> 1. Giới thiệu chung</a>
              <a href="#accounts" className="terms-nav-item"><Shield size={16}/> 2. Tài khoản & Bảo mật</a>
              <a href="#services" className="terms-nav-item"><AlertTriangle size={16}/> 3. Sử dụng Dịch vụ</a>
              <a href="#payments" className="terms-nav-item"><HelpCircle size={16}/> 4. Thanh toán & Hoàn phí (Gia sư)</a>
              <a href="#tuition" className="terms-nav-item"><HelpCircle size={16}/> 5. Chính sách Học phí (Phụ huynh)</a>
            </nav>
          </aside>

          <article className="terms-article">
            <section id="introduction" className="terms-section">
              <h2>1. Giới thiệu chung</h2>
              <p>
                Chào mừng bạn đến với Gia Sư Tinh Hoa. Bằng việc truy cập và sử dụng nền tảng của chúng tôi, bạn đồng ý tuân thủ các Điều khoản & Điều kiện được quy định dưới đây. 
                Vui lòng đọc kỹ trước khi bắt đầu sử dụng dịch vụ. Nếu bạn không đồng ý với bất kỳ điều khoản nào, vui lòng ngừng sử dụng nền tảng.
              </p>
              <p>
                Gia Sư Tinh Hoa hoạt động như một nền tảng cầu nối giữa Gia sư (Tutor) và Phụ huynh/Học sinh (Parent/Student). Chúng tôi cung cấp công cụ phần mềm để quản lý lịch học, kết nối chuyên gia, và đơn giản hóa thủ tục thanh toán.
              </p>
            </section>

            <section id="accounts" className="terms-section">
              <h2>2. Nghĩa vụ về Tài khoản và Bảo mật</h2>
              <ul>
                <li><strong>Gia sư:</strong> Bắt buộc cung cấp thông tin lý lịch Tư pháp, bằng cấp, thẻ Sinh viên và ảnh chụp CCCD/CMND khi đăng ký mở thẻ hồ sơ năng lực.</li>
                <li><strong>Phụ huynh/Học sinh:</strong> Cam kết sử dụng thông tin liên lạc chính xác để chúng tôi tiến hành thông báo lịch mở lớp.</li>
                <li>Mọi thành viên có trách nhiệm bảo mật mật khẩu và mã OTP. Bất kỳ rủi ro nào do để lộ thông tin tài khoản cho bên thứ bat sẽ do người dùng hoàn toàn chịu trách nhiệm.</li>
              </ul>
            </section>

            <section id="services" className="terms-section">
              <h2>3. Quy định Sử dụng Dịch vụ & Hành vi</h2>
              <p>
                Nền tảng của chúng tôi khuyến khích sự tương tác tôn trọng. Bạn không được phép sử dụng dịch vụ để truyền bá nội dung không phù hợp, quấy rối thành viên khác, hoặc thực hiện các giao dịch ngầm nhằm lách phí duy trì của nền tảng.
              </p>
              <p>
                Nếu hệ thống phát hiện hành vi cung cấp thông tin sai lệch để mở lớp hoặc gửi yêu cầu giảng dạy, chúng tôi có quyền thu hồi tài khoản vĩnh viễn không cần báo trước.
              </p>
            </section>

            <section id="payments" className="terms-section">
              <h2>4. Thanh toán và Chính sách Hoàn phí (Dành cho Gia Sư)</h2>
              <p>
                Gia Sư Tinh Hoa thu phí nhận lớp (Phí dịch vụ / GSE Fee) đối với mỗi lớp học được giao thành công cho Gia Sư. Nhằm đảm bảo quyền lợi công bằng và minh bạch, nền tảng áp dụng chính sách xử lý sự cố và hoàn phí như sau:
              </p>
              
              <div className="terms-highlight-box" style={{ marginBottom: 16 }}>
                <strong>Trường hợp lớp hỏng do lỗi Phụ huynh / Học sinh:</strong>
                <ul style={{ marginTop: 8, marginBottom: 0 }}>
                  <li><strong>Trước khi dạy hoặc Dạy buổi đầu tiên:</strong> Nếu sau buổi học đầu tiên Phụ huynh cảm thấy không phù hợp và quyết định hủy lớp, Gia Sư Tinh Hoa cam kết <strong style={{color: 'var(--color-primary)'}}>hoàn lại 100% phí nhận lớp</strong> cho Gia Sư.</li>
                  <li><strong>Từ buổi học thứ 2 trở đi:</strong> Nếu Phụ huynh báo hủy lớp do các lý do khách quan (không phải lỗi chuyên môn của Gia sư), Trung tâm sẽ <strong>trừ 20% định mức phí nhận lớp cho mỗi buổi đã dạy</strong>. (Ví dụ: Dạy 2 buổi hoàn 80%, dạy 3 buổi hoàn 60%). <strong>Lưu ý:</strong> Nếu hủy sau 5 buổi dạy, Gia Sư sẽ không được hỗ trợ hoàn phí.</li>
                </ul>
              </div>

              <div className="terms-highlight-box" style={{ background: 'rgba(239, 68, 68, 0.05)', borderLeftColor: 'var(--color-danger)' }}>
                <strong>Trường hợp lớp hỏng do lỗi Gia Sư:</strong>
                <p style={{ marginTop: 8, marginBottom: 0 }}>
                  Nếu lớp học bị hủy hoàn toàn do phía Gia Sư (tự ý bỏ lớp, thái độ không chuẩn mực, sai lệch thông tin hồ sơ chuyên môn, trễ giờ liên tục phá vỡ cam kết...), Gia Sư sẽ bị <strong>từ chối hoàn phí 100%</strong> và có thể bị khóa tài khoản theo điều khoản ở Mục 3.
                </p>
              </div>
            </section>

            <section id="tuition" className="terms-section">
              <h2>5. Chính sách Học phí và Đổi Gia Sư (Dành cho Phụ Huynh/Học sinh)</h2>
              <div className="terms-highlight-box" style={{ background: 'rgba(99, 102, 241, 0.05)', borderLeftColor: 'var(--color-primary)' }}>
                <strong>Quy định về học thử và đổi gia sư:</strong>
                <p style={{ marginTop: 8, marginBottom: 8 }}>
                  Nền tảng <strong>không áp dụng chính sách học thử miễn phí</strong>. Mọi ca dạy đều được tính công minh bạch cho Gia sư.
                </p>
                <ul style={{ marginTop: 8, marginBottom: 0 }}>
                  <li><strong>Nếu không đồng ý tiếp tục sau buổi 1:</strong> Phụ huynh chỉ cần thanh toán <strong>50% học phí</strong> của buổi dạy đầu tiên đó. Số tiền này hệ thống sẽ gửi cho Gia sư như một phần thù lao công sức. Đồng thời, Trung tâm sẽ hỗ trợ <strong>đổi sang gia sư khác hoàn toàn miễn phí</strong>.</li>
                  <li><strong>Hủy lớp khi đang học:</strong> Trường hợp Phụ huynh đơn phương quyết định ngừng học khi lớp đã diễn ra ổn định nhiều buổi, Phụ huynh có trách nhiệm <strong>thanh toán đầy đủ 100% học phí</strong> tương ứng với tất cả các buổi học đã diễn ra trong tháng đó.</li>
                  <li>Trung tâm luôn đảm bảo trả lương đúng và đủ cho Gia sư dựa vào đúng số buổi đã dạy thực tế sau khi đối soát trên hệ thống.</li>
                </ul>
              </div>
            </section>
          </article>
        </div>
      </main>

      </div>
  );
};
