import { Link, useOutletContext } from 'react-router-dom';
import { Calendar, Clock, ArrowRight, ChevronRight } from 'lucide-react';

import { SEO } from '../../components/common/SEO';
import { ArticleLeadMagnet } from '../../components/blog/ArticleLeadMagnet';
import { ArticleStickyBanner } from '../../components/blog/ArticleStickyBanner';
import './ArticleDetail.css';

const TABLE_OF_CONTENTS = [
  { id: 'xac-dinh', label: '1. Xác định nhu cầu' },
  { id: 'tieu-chi', label: '2. 6 tiêu chí vàng' },
  { id: 'quy-trinh', label: '3. Quy trình 4 bước' },
  { id: 'luu-y', label: '4. Lưu ý quan trọng' },
  { id: 'checklist', label: '5. Checklist đánh giá' },
];

const ARTICLE_SCHEMA = {
  '@context': 'https://schema.org',
  '@type': 'Article',
  headline: 'Cách Chọn Gia Sư Giỏi Cho Con: Hướng Dẫn Toàn Diện Dành Cho Phụ Huynh',
  description: 'Hướng dẫn phụ huynh cách chọn gia sư phù hợp cho con với 6 tiêu chí vàng và quy trình 4 bước sàng lọc.',
  author: { '@type': 'Organization', name: 'Gia Sư Tinh Hoa' },
  publisher: { '@type': 'Organization', name: 'Gia Sư Tinh Hoa', url: 'https://giasutinhhoa.com' },
  datePublished: '2026-04-03',
  mainEntityOfPage: 'https://giasutinhhoa.com/bai-viet/cach-chon-gia-su-gioi',
};

export const CachChonGiaSuPage = () => {
  const { openRegister } = useOutletContext<{ openRegister: () => void }>();
  return (
    <div className="article-page">
      <SEO
        title="Cách Chọn Gia Sư Giỏi Cho Con: 6 Tiêu Chí Vàng | Gia Sư Tinh Hoa"
        description="Hướng dẫn phụ huynh cách chọn gia sư phù hợp: 6 tiêu chí đánh giá, quy trình sàng lọc 4 bước và checklist thực tế."
        keywords="cách chọn gia sư, tiêu chí chọn gia sư, tìm gia sư giỏi, gia sư uy tín, đánh giá gia sư"
        url="https://giasutinhhoa.com/bai-viet/cach-chon-gia-su-gioi"
        type="article"
        schema={ARTICLE_SCHEMA}
      />
      <main className="article-main">
        <div className="article-hero">
          <div className="container">
            <div className="article-breadcrumb">
              <Link to="/">Trang chủ</Link>
              <ChevronRight size={14} className="separator" />
              <Link to="/bai-viet">Bài viết</Link>
              <ChevronRight size={14} className="separator" />
              <span>Cách chọn gia sư giỏi</span>
            </div>
            <h1 className="article-hero-title">Cách Chọn Gia Sư Giỏi Cho Con: Hướng Dẫn Toàn Diện Dành Cho Phụ Huynh</h1>
            <div className="article-hero-meta">
              <span><Calendar size={16} /> 03/04/2026</span>
              <span><Clock size={16} /> 9 phút đọc</span>
            </div>
          </div>
        </div>

        <div className="article-content-wrapper">
          <aside className="article-toc">
            <nav className="article-toc-inner">
              <p className="article-toc-title">Mục lục</p>
              <ul className="article-toc-list">
                {TABLE_OF_CONTENTS.map(({ id, label }) => (
                  <li key={id}><a href={`#${id}`}>{label}</a></li>
                ))}
              </ul>
            </nav>
          </aside>

          <article className="article-body">
            <p>Chọn gia sư không chỉ là tìm người giỏi — mà là tìm <strong>người phù hợp nhất</strong> với con. Một gia sư "đúng" giúp con tiến bộ vượt bậc, nhưng một gia sư "sai" có thể khiến con thêm chán học.</p>

            <h2 id="xac-dinh">1. Xác định nhu cầu trước khi tìm kiếm</h2>
            <p>Trả lời 3 câu hỏi: Con cần <strong>lấy lại gốc</strong>, <strong>nâng cao</strong> hay <strong>luyện thi</strong>? Mỗi mục đích dẫn đến lựa chọn gia sư khác nhau.</p>
            <div className="article-highlight">
              <p>💡 Gia sư sinh viên phù hợp cho kèm cặp hàng ngày. Gia sư là giáo viên trường phù hợp hơn cho luyện thi chuyên sâu.</p>
            </div>

            <h2 id="tieu-chi">2. Sáu tiêu chí vàng đánh giá gia sư</h2>
            <h3>2.1. Chuyên môn vững vàng</h3>
            <p>Ưu tiên người có bằng cấp liên quan, sinh viên trường top (ĐH Bách Khoa, ĐH Sư Phạm) hoặc giáo viên đang giảng dạy tại trường.</p>
            <h3>2.2. Kỹ năng sư phạm & truyền đạt</h3>
            <p>Gia sư phải biết <strong>phân tích phức tạp thành đơn giản</strong>, dùng ví dụ gần gũi để con dễ hiểu.</p>
            <h3>2.3. Tâm lý và kiên nhẫn</h3>
            <p>Quan trọng ngang chuyên môn. Gia sư phải hiểu tâm lý lứa tuổi, kiên nhẫn khi con sai, biết cách khích lệ.</p>
            <h3>2.4. Phương pháp linh hoạt</h3>
            <p>Nhận biết phong cách học của con (nhìn, nghe, làm) để điều chỉnh cách dạy phù hợp.</p>
            <h3>2.5. Tác phong chuyên nghiệp</h3>
            <p>Đúng giờ, có giáo án, phản hồi tình hình học tập cho phụ huynh hàng tuần.</p>
            <h3>2.6. Truyền cảm hứng</h3>
            <p>Gia sư tốt nhất là người khiến con <strong>yêu thích môn học</strong> và chủ động hỏi bài trước khi gia sư đến.</p>

            <ArticleLeadMagnet />
            <h2 id="quy-trinh">3. Quy trình 4 bước tìm gia sư</h2>
            <div className="article-step">
              <div className="article-step-number">1</div>
              <div className="article-step-content">
                <h3>Tìm nguồn uy tín</h3>
                <p>Ưu tiên người quen giới thiệu hoặc nền tảng trung gian (như Gia Sư Tinh Hoa) — nơi gia sư đã được xác thực hồ sơ.</p>
              </div>
            </div>
            <div className="article-step">
              <div className="article-step-number">2</div>
              <div className="article-step-content">
                <h3>Sàng lọc hồ sơ</h3>
                <p>Xem bằng cấp, kinh nghiệm (ưu tiên 1-2 năm trở lên), đánh giá từ phụ huynh khác.</p>
              </div>
            </div>
            <div className="article-step">
              <div className="article-step-number">3</div>
              <div className="article-step-content">
                <h3>Buổi học thử</h3>
                <p>Quan sát cách gia sư tương tác với con. Sau buổi học, hỏi con: "Con thấy thầy/cô dạy thế nào?"</p>
              </div>
            </div>
            <div className="article-step">
              <div className="article-step-number">4</div>
              <div className="article-step-content">
                <h3>Đánh giá sau 2-4 tuần</h3>
                <p>Con có tiến bộ? Có chủ động học hơn? Gia sư có phản hồi thường xuyên? 3 "Có" = bạn chọn đúng!</p>
              </div>
            </div>

            <h2 id="luu-y">4. Những lưu ý quan trọng</h2>
            <div className="article-warning">
              <p>⚠️ Cẩn thận với trung tâm quảng cáo "cam kết con đạt điểm 9-10". Không ai có thể cam kết kết quả tuyệt đối.</p>
            </div>
            <ul>
              <li><strong>Đừng chọn theo giá rẻ nhất:</strong> Gia sư quá rẻ thường thiếu kinh nghiệm hoặc không cam kết lâu dài.</li>
              <li><strong>Quan sát thái độ con:</strong> Nếu con sợ hoặc khóc trước giờ học — hãy đổi gia sư ngay.</li>
              <li><strong>Phối hợp chặt chẽ:</strong> Phụ huynh cần trao đổi với gia sư về tiến độ con hàng tuần.</li>
            </ul>

            <h2 id="checklist">5. Checklist đánh giá nhanh</h2>
            <div className="article-table-wrapper">
              <table className="article-table">
                <thead>
                  <tr><th>Tiêu chí</th><th>Gia sư tốt ✅</th><th>Cảnh báo ❌</th></tr>
                </thead>
                <tbody>
                  <tr><td><strong>Buổi đầu</strong></td><td>Đánh giá năng lực con</td><td>Mở sách dạy ngay</td></tr>
                  <tr><td><strong>Phương pháp</strong></td><td>Giải thích đa chiều</td><td>Đọc lại sách, máy móc</td></tr>
                  <tr><td><strong>Tương tác</strong></td><td>Kiên nhẫn, khích lệ</td><td>Nóng nảy, chê bai</td></tr>
                  <tr><td><strong>Phản hồi PH</strong></td><td>Báo cáo hàng tuần</td><td>Không liên lạc</td></tr>
                  <tr><td><strong>Kết quả</strong></td><td>Con chủ động hỏi bài</td><td>Con sợ, điểm không cải thiện</td></tr>
                </tbody>
              </table>
            </div>

            <div className="article-cta">
              <h3>Đăng ký ngay để nhận tư vấn lộ trình 1 kèm 1</h3>
              <p>Hãy để chuyên gia của Gia Sư Tinh Hoa giúp bạn phân tích năng lực và lựa chọn gia sư phù hợp nhất cho con hoàn toàn miễn phí.</p>
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
