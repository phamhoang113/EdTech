import { Link, useOutletContext } from 'react-router-dom';
import { Calendar, Clock, ArrowRight, ChevronRight } from 'lucide-react';
import { useScrollSpy } from '../../hooks/useScrollSpy';

import { SEO } from '../../components/common/SEO';
import { ArticleLeadMagnet } from '../../components/blog/ArticleLeadMagnet';
import { ArticleStickyBanner } from '../../components/blog/ArticleStickyBanner';
import './ArticleDetail.css';

const TABLE_OF_CONTENTS = [
  { id: 'tai-sao', label: '1. Tại sao chọn Gia Sư Tinh Hoa?' },
  { id: 'so-sanh', label: '2. So sánh với các hình thức khác' },
  { id: 'quy-trinh', label: '3. Quy trình minh bạch' },
  { id: 'cam-nhan', label: '4. Phụ huynh nói gì?' },
  { id: 'chi-phi', label: '5. Chi phí & giá trị' },
  { id: 'bat-dau', label: '6. Bắt đầu ngay hôm nay' },
];

const ARTICLE_SCHEMA = {
  '@context': 'https://schema.org',
  '@type': 'Article',
  headline: 'Tại Sao Hàng Ngàn Phụ Huynh Chọn Gia Sư Tinh Hoa? Phân Tích 6 Lợi Ích Vượt Trội',
  description: 'Phân tích chi tiết 6 lợi ích khi sử dụng dịch vụ Gia Sư Tinh Hoa: gia sư xác thực, lộ trình cá nhân hóa, theo dõi tiến độ real-time. So sánh với trung tâm truyền thống và tự tìm gia sư.',
  author: { '@type': 'Organization', name: 'Gia Sư Tinh Hoa' },
  publisher: { '@type': 'Organization', name: 'Gia Sư Tinh Hoa', url: 'https://giasutinhhoa.com' },
  datePublished: '2026-04-12',
  dateModified: '2026-04-12',
  mainEntityOfPage: 'https://giasutinhhoa.com/bai-viet/tai-sao-chon-gia-su-tinh-hoa/',
};

export const TaiSaoChonGSTHPage = () => {
  const { openRegister } = useOutletContext<{ openRegister: () => void }>();
  const activeId = useScrollSpy(TABLE_OF_CONTENTS.map(item => item.id), '-20% 0px -60% 0px');

  return (
    <div className="article-page">
      <SEO
        title="Tại Sao Chọn Gia Sư Tinh Hoa? 6 Lợi Ích Vượt Trội So Với Cách Tìm Gia Sư Truyền Thống"
        description="Phân tích chi tiết 6 lợi ích khi dùng Gia Sư Tinh Hoa: gia sư xác thực hồ sơ, lộ trình cá nhân hóa, theo dõi tiến độ. So sánh minh bạch với trung tâm truyền thống."
        keywords="gia sư tinh hoa, tìm gia sư uy tín, dịch vụ gia sư chất lượng, gia sư 1 kèm 1 cho con, so sánh trung tâm gia sư, nền tảng gia sư online, gia sư được xác thực, lộ trình học cá nhân hóa, đăng ký gia sư miễn phí"
        url="https://giasutinhhoa.com/bai-viet/tai-sao-chon-gia-su-tinh-hoa"
        type="article"
        schema={ARTICLE_SCHEMA}
      />

      <main className="article-main">
        {/* Hero */}
        <div className="article-hero">
          <div className="container">
            <div className="article-breadcrumb">
              <Link to="/">Trang chủ</Link>
              <ChevronRight size={14} className="separator" />
              <Link to="/bai-viet">Bài viết</Link>
              <ChevronRight size={14} className="separator" />
              <span>Tại sao chọn Gia Sư Tinh Hoa?</span>
            </div>
            <h1 className="article-hero-title">
              Tại Sao Hàng Ngàn Phụ Huynh Chọn Gia Sư Tinh Hoa? Phân Tích 6 Lợi Ích Vượt Trội
            </h1>
            <div className="article-hero-meta">
              <span><Calendar size={16} /> 12/04/2026</span>
              <span><Clock size={16} /> 12 phút đọc</span>
            </div>
          </div>
        </div>

        {/* Body */}
        <div className="article-content-wrapper">
          {/* TOC Sidebar */}
          <aside className="article-toc">
            <nav className="article-toc-inner">
              <p className="article-toc-title">Mục lục</p>
              <ul className="article-toc-list">
                {TABLE_OF_CONTENTS.map(({ id, label }) => (
                  <li key={id}>
                    <a href={`#${id}`} className={activeId === id ? 'active' : ''}>
                      {label}
                    </a>
                  </li>
                ))}
              </ul>
            </nav>
          </aside>

          {/* Article */}
          <article className="article-body">
            <p>
              Khi quyết định tìm gia sư cho con, phụ huynh thường đối mặt với hàng loạt lựa chọn: tự tìm trên mạng xã hội, nhờ người quen giới thiệu, qua trung tâm gia sư truyền thống, hay sử dụng nền tảng công nghệ? Mỗi cách đều có ưu/nhược điểm riêng. Bài viết này <strong>phân tích khách quan</strong> tại sao Gia Sư Tinh Hoa đang trở thành lựa chọn hàng đầu của phụ huynh Việt Nam, dựa trên số liệu thực tế và so sánh cụ thể.
            </p>

            {/* Section 1 */}
            <h2 id="tai-sao">1. Sáu lợi ích cốt lõi khi chọn Gia Sư Tinh Hoa</h2>

            <h3>🔍 1.1. Gia sư được xác thực 100% hồ sơ</h3>
            <p>
              Khác với việc tìm gia sư trên Facebook hay Zalo — nơi bất kỳ ai cũng có thể tự nhận mình là "gia sư kinh nghiệm" — tại Gia Sư Tinh Hoa, <strong>mỗi gia sư phải qua quy trình xác minh 4 bước</strong>:
            </p>
            <ol>
              <li><strong>Xác minh danh tính</strong> qua CCCD và số điện thoại (OTP)</li>
              <li><strong>Kiểm tra bằng cấp</strong>: tải lên bằng tốt nghiệp, chứng chỉ sư phạm</li>
              <li><strong>Xác nhận kinh nghiệm</strong>: ít nhất 6 tháng kinh nghiệm dạy kèm</li>
              <li><strong>Duyệt bởi Admin</strong>: đội ngũ quản lý review thủ công từng hồ sơ</li>
            </ol>
            <div className="article-highlight">
              <p>💡 <strong>Kết quả:</strong> Chỉ khoảng <strong>35% gia sư đăng ký</strong> được duyệt thành công. Điều này đảm bảo chất lượng gia sư luôn ở mức cao nhất.</p>
            </div>

            <h3>📋 1.2. Lộ trình học tập cá nhân hóa</h3>
            <p>
              Gia sư tại Gia Sư Tinh Hoa không dạy theo "giáo trình có sẵn". Mỗi học sinh được đánh giá năng lực qua <strong>1-2 buổi đầu tiên</strong>, từ đó gia sư xây dựng lộ trình riêng biệt dựa trên:
            </p>
            <ul>
              <li>Lỗ hổng kiến thức hiện tại của con</li>
              <li>Mục tiêu cụ thể (lấy gốc, nâng cao, luyện thi)</li>
              <li>Phong cách học của con (nhìn, nghe, làm)</li>
              <li>Tốc độ tiếp thu cá nhân</li>
            </ul>

            <h3>📊 1.3. Theo dõi tiến độ minh bạch</h3>
            <p>
              Phụ huynh được <strong>cập nhật tiến trình học tập real-time</strong> qua ứng dụng: lịch sử buổi học, nội dung đã dạy, nhận xét của gia sư sau mỗi buổi, và báo cáo tiến bộ hàng tháng. Không còn cảnh "trả tiền mà không biết con học được gì".
            </p>

            <h3>⏰ 1.4. Lịch học linh hoạt, không ràng buộc</h3>
            <p>
              Khác với trung tâm gia sư có lịch cố định, tại Gia Sư Tinh Hoa, phụ huynh và gia sư <strong>tự thỏa thuận lịch học</strong>. Con bận thi giữa kỳ? Dời lịch. Muốn tăng tần suất trước kỳ thi? Thêm buổi. Mọi thứ linh hoạt theo nhu cầu thực tế.
            </p>

            <h3>💬 1.5. Chat trực tiếp, hỏi bài mọi lúc</h3>
            <p>
              Hệ thống nhắn tin <strong>tích hợp ngay trong nền tảng</strong> cho phép phụ huynh trao đổi với gia sư bất cứ lúc nào, không cần Zalo hay số điện thoại cá nhân. An toàn, chuyên nghiệp và có lịch sử tin nhắn để tra cứu.
            </p>

            <h3>🛡️ 1.6. Bảo vệ quyền lợi phụ huynh</h3>
            <p>
              Nếu gia sư không phù hợp, phụ huynh có thể <strong>đổi gia sư miễn phí</strong> bất cứ lúc nào. Không phải ký hợp đồng dài hạn, không phí cam kết, không ràng buộc. Quyền lợi luôn thuộc về phụ huynh.
            </p>

            {/* Section 2 */}
            <h2 id="so-sanh">2. So sánh toàn diện: Gia Sư Tinh Hoa vs các hình thức khác</h2>

            <div className="article-table-wrapper">
              <table className="article-table">
                <thead>
                  <tr>
                    <th>Tiêu chí</th>
                    <th>Gia Sư Tinh Hoa 🏆</th>
                    <th>Trung tâm truyền thống</th>
                    <th>Tự tìm (MXH, quen)</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><strong>Xác minh gia sư</strong></td>
                    <td>✅ 4 bước, duyệt thủ công</td>
                    <td>⚠️ Có nhưng không minh bạch</td>
                    <td>❌ Không có</td>
                  </tr>
                  <tr>
                    <td><strong>Chi phí</strong></td>
                    <td>120.000 – 250.000đ/buổi</td>
                    <td>200.000 – 400.000đ/buổi</td>
                    <td>100.000 – 300.000đ/buổi</td>
                  </tr>
                  <tr>
                    <td><strong>Phí trung gian</strong></td>
                    <td>✅ Không phí ẩn</td>
                    <td>❌ 25-50% tháng đầu</td>
                    <td>✅ Không phí</td>
                  </tr>
                  <tr>
                    <td><strong>Thay đổi gia sư</strong></td>
                    <td>✅ Miễn phí, bất cứ lúc nào</td>
                    <td>⚠️ Mất phí, chờ 1-2 tuần</td>
                    <td>❌ Phải tự tìm lại từ đầu</td>
                  </tr>
                  <tr>
                    <td><strong>Theo dõi tiến độ</strong></td>
                    <td>✅ App real-time, báo cáo tháng</td>
                    <td>⚠️ Họp phụ huynh định kỳ</td>
                    <td>❌ Không có hệ thống</td>
                  </tr>
                  <tr>
                    <td><strong>Lịch học</strong></td>
                    <td>✅ Linh hoạt, tự thỏa thuận</td>
                    <td>❌ Cố định theo ca</td>
                    <td>⚠️ Tùy thỏa thuận</td>
                  </tr>
                  <tr>
                    <td><strong>Hợp đồng</strong></td>
                    <td>✅ Không ràng buộc</td>
                    <td>❌ 3-6 tháng cam kết</td>
                    <td>✅ Không ràng buộc</td>
                  </tr>
                  <tr>
                    <td><strong>Rủi ro</strong></td>
                    <td>✅ Thấp (đã xác thực)</td>
                    <td>⚠️ Trung bình</td>
                    <td>❌ Cao (không kiểm chứng)</td>
                  </tr>
                  <tr>
                    <td><strong>Thời gian tìm</strong></td>
                    <td>✅ Dưới 24 giờ</td>
                    <td>⚠️ 3-7 ngày</td>
                    <td>❌ 1-4 tuần</td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div className="article-highlight">
              <p>
                💡 <strong>Nhận xét:</strong> Gia Sư Tinh Hoa kết hợp <strong>ưu điểm của cả hai hình thức</strong>: sự an toàn và chuyên nghiệp của trung tâm, cộng với sự linh hoạt và tiết kiệm khi tự thuê gia sư. Trong khi loại bỏ nhược điểm của cả hai: phí ẩn, ràng buộc hợp đồng, và rủi ro gia sư không xác thực.
              </p>
            </div>

            <ArticleLeadMagnet />

            {/* Section 3 */}
            <h2 id="quy-trinh">3. Quy trình sử dụng đơn giản, minh bạch</h2>
            <p>Chỉ cần <strong>3 bước</strong> để con có gia sư phù hợp:</p>

            <div className="article-step">
              <div className="article-step-number">1</div>
              <div className="article-step-content">
                <h3>Đăng ký miễn phí (2 phút)</h3>
                <p>Tạo tài khoản bằng số điện thoại, xác thực OTP. Mô tả nhu cầu: con học lớp mấy, môn gì, mục tiêu cụ thể (lấy gốc, nâng cao, luyện thi).</p>
              </div>
            </div>
            <div className="article-step">
              <div className="article-step-number">2</div>
              <div className="article-step-content">
                <h3>Nhận đề xuất gia sư phù hợp (trong 24 giờ)</h3>
                <p>Hệ thống gợi ý gia sư dựa trên nhu cầu. Phụ huynh xem hồ sơ chi tiết: bằng cấp, kinh nghiệm, đánh giá từ phụ huynh khác, môn và cấp giảng dạy.</p>
              </div>
            </div>
            <div className="article-step">
              <div className="article-step-number">3</div>
              <div className="article-step-content">
                <h3>Học thử & bắt đầu</h3>
                <p>Buổi học đầu tiên gia sư đánh giá năng lực con, xây dựng lộ trình. Phụ huynh theo dõi tiến trình qua ứng dụng. Không hài lòng? Đổi gia sư ngay, hoàn toàn miễn phí.</p>
              </div>
            </div>

            {/* Section 4 */}
            <h2 id="cam-nhan">4. Phụ huynh đã trải nghiệm nói gì?</h2>

            <div className="article-tip">
              <p>
                ✅ <strong>Chị Nguyễn Thị Minh Anh (Q.7, TP.HCM):</strong> <em>"Con trai tôi bị mất gốc Toán lớp 8. Sau 2 tháng học với gia sư từ Gia Sư Tinh Hoa, điểm Toán từ 3.5 lên 7.0. Điều tôi thích nhất là được cập nhật tiến trình mỗi buổi, không phải hỏi con 'hôm nay học gì?'"</em>
              </p>
            </div>

            <div className="article-tip">
              <p>
                ✅ <strong>Anh Trần Văn Hùng (Q. Bình Thạnh):</strong> <em>"Trước đây tôi thuê gia sư qua mạng, 2 lần gặp người không đúng trình độ như giới thiệu. Từ khi dùng Gia Sư Tinh Hoa, yên tâm hơn nhiều vì gia sư đã được kiểm chứng bằng cấp."</em>
              </p>
            </div>

            <div className="article-tip">
              <p>
                ✅ <strong>Chị Lê Thị Hồng (Q.1, TP.HCM):</strong> <em>"Con gái chuẩn bị thi vào lớp 10, tôi cần gia sư luyện thi gấp. Đăng ký trưa thì chiều đã có gia sư liên hệ. Nhanh hơn hẳn so với trung tâm phải chờ 1 tuần."</em>
              </p>
            </div>

            {/* Section 5 */}
            <h2 id="chi-phi">5. Chi phí — Đầu tư xứng đáng cho tương lai con</h2>

            <div className="article-table-wrapper">
              <table className="article-table">
                <thead>
                  <tr>
                    <th>Hình thức</th>
                    <th>Chi phí/buổi (90 phút)</th>
                    <th>Phí ẩn</th>
                    <th>Giá trị nhận được</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><strong>Gia Sư Tinh Hoa</strong></td>
                    <td>120.000 – 250.000đ</td>
                    <td>Không</td>
                    <td>Gia sư xác thực + lộ trình + tracking</td>
                  </tr>
                  <tr>
                    <td><strong>Lớp dạy thêm</strong></td>
                    <td>50.000 – 100.000đ</td>
                    <td>Không</td>
                    <td>Học chung 20-30 HS, không cá nhân hóa</td>
                  </tr>
                  <tr>
                    <td><strong>Trung tâm gia sư</strong></td>
                    <td>200.000 – 400.000đ</td>
                    <td>Phí trung gian 25-50% tháng 1</td>
                    <td>Gia sư có kiểm tra, nhưng phí cao</td>
                  </tr>
                  <tr>
                    <td><strong>Tự tìm gia sư online</strong></td>
                    <td>100.000 – 300.000đ</td>
                    <td>Không</td>
                    <td>Rủi ro cao, không bảo đảm chất lượng</td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div className="article-warning">
              <p>
                ⚠️ <strong>Lưu ý:</strong> Nhiều trung tâm quảng cáo "học phí từ 100.000đ/buổi" nhưng thực tế thu phí trung gian rất cao từ gia sư (25-50% tháng đầu). Điều này khiến gia sư giỏi thường <strong>không muốn hợp tác</strong> với trung tâm, dẫn đến chất lượng giảm. Tại Gia Sư Tinh Hoa, gia sư nhận <strong>100% học phí</strong> từ phụ huynh, nên thu hút được đội ngũ chất lượng cao nhất.
              </p>
            </div>

            <h3>Tính nhanh: đầu tư bao nhiêu mỗi tháng?</h3>
            <p>Với 2 buổi/tuần × 4 tuần × 180.000đ/buổi (mức trung bình):</p>
            <ul>
              <li><strong>Chi phí: 1.440.000đ/tháng</strong> — tương đương 48.000đ/ngày</li>
              <li>Ít hơn một ly cà phê mỗi ngày, nhưng con được <strong>kèm cặp 1-1 bởi gia sư đã xác thực</strong></li>
              <li>So với lớp dạy thêm: rẻ hơn <strong>nhưng hiệu quả gấp 2-3 lần</strong> nhờ cá nhân hóa hoàn toàn</li>
            </ul>

            {/* Section 6 */}
            <h2 id="bat-dau">6. Bắt đầu ngay hôm nay — chỉ 2 phút</h2>

            <p>
              <strong>Đừng để con tụt hậu thêm một ngày nào nữa.</strong> Mỗi tuần trôi qua mà con không được hỗ trợ đúng cách, lỗ hổng kiến thức càng lớn, việc lấy lại gốc càng khó.
            </p>

            <div className="article-highlight">
              <p>
                💡 <strong>Cam kết của Gia Sư Tinh Hoa:</strong>
              </p>
              <ul>
                <li>✅ Đăng ký hoàn toàn <strong>miễn phí</strong></li>
                <li>✅ Nhận đề xuất gia sư trong <strong>24 giờ</strong></li>
                <li>✅ Không hài lòng? <strong>Đổi gia sư miễn phí</strong>, không ràng buộc</li>
                <li>✅ Không phí ẩn, không hợp đồng dài hạn</li>
              </ul>
            </div>

            <p>
              Hàng ngàn phụ huynh tại TP.HCM, Hà Nội, Đà Nẵng và nhiều tỉnh thành khác đã tin tưởng Gia Sư Tinh Hoa. <strong>Bạn chỉ cần 2 phút để đăng ký</strong> và bắt đầu hành trình giúp con tiến bộ.
            </p>

            {/* CTA */}
            <div className="article-cta">
              <h3>Đăng ký ngay — Miễn phí, không ràng buộc</h3>
              <p>Chỉ cần số điện thoại, nhận tư vấn và đề xuất gia sư phù hợp nhất cho con trong 24 giờ.</p>
              <button
                onClick={openRegister}
                className="article-cta-btn"
                style={{ border: 'none', cursor: 'pointer', fontFamily: 'inherit', display: 'inline-flex', alignItems: 'center', gap: '8px' }}
              >
                Đăng Ký Ngay <ArrowRight size={18} />
              </button>
            </div>
          </article>
        </div>
        <ArticleStickyBanner />
      </main>
    </div>
  );
};
