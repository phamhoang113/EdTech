import { Link, useOutletContext } from 'react-router-dom';
import { Calendar, Clock, ArrowRight, ChevronRight } from 'lucide-react';
import { useScrollSpy } from '../../hooks/useScrollSpy';

import { SEO } from '../../components/common/SEO';
import { ArticleLeadMagnet } from '../../components/blog/ArticleLeadMagnet';
import { ArticleStickyBanner } from '../../components/blog/ArticleStickyBanner';
import './ArticleDetail.css';

const TABLE_OF_CONTENTS = [
  { id: 'nen-tang', label: '1. Thiết lập nền tảng' },
  { id: 'dong-hanh', label: '2. Phương pháp đồng hành' },
  { id: 'tu-hoc', label: '3. Rèn luyện kỹ năng tự học' },
  { id: 'sai-lam', label: '4. Sai lầm cần tránh' },
  { id: 'cong-cu', label: '5. Công cụ hỗ trợ' },
];

const ARTICLE_SCHEMA = {
  '@context': 'https://schema.org',
  '@type': 'Article',
  headline: '7 Phương Pháp Dạy Con Học Hiệu Quả Tại Nhà Mà Bất Kỳ Phụ Huynh Nào Cũng Làm Được',
  description: 'Hướng dẫn chi tiết cách dạy con học tại nhà hiệu quả dựa trên khoa học giáo dục, tâm lý trẻ và kinh nghiệm thực tế của các gia sư chuyên nghiệp.',
  author: { '@type': 'Organization', name: 'Gia Sư Tinh Hoa' },
  publisher: { '@type': 'Organization', name: 'Gia Sư Tinh Hoa', url: 'https://giasutinhhoa.com' },
  datePublished: '2026-04-03',
  dateModified: '2026-04-03',
  mainEntityOfPage: 'https://giasutinhhoa.com/bai-viet/phuong-phap-day-con-hoc-tai-nha',
};

export const DayConHocTaiNhaPage = () => {
  const { openRegister } = useOutletContext<{ openRegister: () => void }>();
  const activeId = useScrollSpy(TABLE_OF_CONTENTS.map(item => item.id), '-20% 0px -60% 0px');
  return (
    <div className="article-page">
      <SEO
        title="7 Phương Pháp Dạy Con Học Hiệu Quả Tại Nhà | Gia Sư Tinh Hoa"
        description="Hướng dẫn chi tiết cách dạy con học tại nhà hiệu quả: thiết lập không gian, đồng hành tâm lý, rèn kỹ năng tự học. Áp dụng ngay hôm nay!"
        keywords="dạy con học tại nhà, phương pháp dạy con hiệu quả, cách kèm con học cấp 1, sai lầm khi dạy con học bài, bồi dưỡng con học giỏi, tâm lý giáo dục, gia sư tại nhà, kết nối cha mẹ và con cái"
        url="https://giasutinhhoa.com/bai-viet/phuong-phap-day-con-hoc-tai-nha"
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
              <span>Phương pháp dạy con học tại nhà</span>
            </div>
            <h1 className="article-hero-title">
              7 Phương Pháp Dạy Con Học Hiệu Quả Tại Nhà Mà Bất Kỳ Phụ Huynh Nào Cũng Làm Được
            </h1>
            <div className="article-hero-meta">
              <span><Calendar size={16} /> 03/04/2026</span>
              <span><Clock size={16} /> 10 phút đọc</span>
            </div>
          </div>
        </div>

        {/* Body */}
        <div className="article-content-wrapper">
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

          <article className="article-body">
            <p>
              Việc dạy con học tại nhà không đơn giản là ngồi cạnh con và bắt con giải bài tập. Đó là cả một nghệ thuật kết hợp giữa <strong>khoa học giáo dục</strong>, <strong>tâm lý trẻ em</strong> và sự kiên nhẫn. Bài viết này tổng hợp 7 phương pháp đã được các chuyên gia giáo dục và gia sư chuyên nghiệp kiểm chứng, giúp bạn biến việc kèm con học trở thành trải nghiệm tích cực cho cả nhà.
            </p>

            {/* Section 1 */}
            <h2 id="nen-tang">1. Thiết lập nền tảng học tập khoa học</h2>

            <h3>Tạo không gian học tập chuyên biệt</h3>
            <p>
              Theo nghiên cứu của Sở GD&ĐT TP.HCM, trẻ có <strong>góc học tập riêng</strong> tập trung tốt hơn 35% so với trẻ học trên giường hoặc sofa. Không gian lý tưởng cần đảm bảo:
            </p>
            <ul>
              <li><strong>Yên tĩnh:</strong> Cách xa tivi, phòng khách và tiếng ồn</li>
              <li><strong>Đủ ánh sáng:</strong> Ưu tiên ánh sáng tự nhiên, đèn bàn LED trắng ấm 4000K</li>
              <li><strong>Gọn gàng:</strong> Bàn học chỉ có sách vở cần thiết, không có đồ chơi hay điện thoại</li>
              <li><strong>Cá nhân hóa:</strong> Cho con tự trang trí góc học để tạo cảm giác "sở hữu"</li>
            </ul>

            <h3>Lập thời gian biểu cùng con</h3>
            <p>
              Đừng áp đặt lịch từ trên xuống. Hãy <strong>ngồi cùng con</strong> để lên thời gian biểu hàng ngày, bao gồm cả thời gian học, chơi, ăn và nghỉ. Khi con tham gia lập kế hoạch, con sẽ có trách nhiệm hơn với chính lịch trình của mình.
            </p>

            <div className="article-tip">
              <p>
                ✅ <strong>Mẹo:</strong> In thời gian biểu ra, dán lên tường cạnh bàn học. Cho con tự đánh dấu tick mỗi khi hoàn thành một mục — cảm giác "hoàn thành nhiệm vụ" sẽ tạo động lực rất lớn!
              </p>
            </div>

            {/* Section 2 */}
            <h2 id="dong-hanh">2. Phương pháp đồng hành — Làm "bạn" với con</h2>

            <h3>Thấu hiểu trước khi giảng giải</h3>
            <p>
              Trước khi quan tâm đến bài vở, hãy <strong>hỏi thăm tâm trạng</strong> của con. "Hôm nay ở trường con thế nào?" — câu hỏi đơn giản này giúp bạn nắm bắt cảm xúc của con, từ đó điều chỉnh cường độ học tập phù hợp. Trẻ đang buồn, đang mệt hoặc đang lo lắng sẽ không thể tập trung học, dù có ép bao lâu.
            </p>

            <h3>Tìm nguyên nhân gốc rễ</h3>
            <p>
              Khi con học yếu, <strong>đừng vội trách mắng</strong>. Hãy bình tĩnh tìm hiểu:
            </p>
            <ul>
              <li>Con thiếu kiến thức nền tảng? → Quay lại bổ sung từ đầu</li>
              <li>Con không hiểu cách dạy của cô/thầy? → Thử giải thích theo cách khác</li>
              <li>Con gặp vấn đề tâm lý (bạn bè, áp lực thi cử)? → Lắng nghe và an ủi trước</li>
              <li>Con chưa tìm được phương pháp học phù hợp? → Thử các kỹ thuật khác nhau</li>
            </ul>

            <h3>Kiên nhẫn và khích lệ</h3>
            <p>
              Thay vì nổi nóng khi con sai, hãy <strong>chia nhỏ bài học</strong> thành từng phần dễ nuốt. Sau mỗi phần nhỏ hoàn thành, hãy công nhận nỗ lực: <em>"Con làm tốt lắm, bước tiếp theo mình thử nhé!"</em>. Nghiên cứu tâm lý học cho thấy lời khen nỗ lực (effort-based praise) hiệu quả hơn khen kết quả đến 3 lần.
            </p>

            {/* Section 3 */}
            <ArticleLeadMagnet />
            <h2 id="tu-hoc">3. Rèn luyện kỹ năng tự học — Mục tiêu tối thượng</h2>

            <h3>Không làm bài thay con</h3>
            <p>
              Đây là <strong>sai lầm phổ biến nhất</strong> của phụ huynh Việt Nam. Khi con gặp bài khó, thay vì đưa đáp án, hãy đặt câu hỏi gợi mở: <em>"Con nghĩ bước đầu tiên là gì?", "Con đã thử cách nào rồi?"</em>. Mục tiêu là giúp con <strong>tự tư duy</strong>, không phải hoàn thành nhanh cho xong.
            </p>

            <h3>Dạy con kỹ năng ghi chú</h3>
            <p>
              Hướng dẫn con cách <strong>đánh dấu từ khóa</strong>, tạo sơ đồ tư duy (Mind Map) và viết tóm tắt sau mỗi bài học. Đây là kỹ năng sẽ theo con suốt đời, từ cấp 2 đến đại học và cả trong sự nghiệp.
            </p>

            <h3>Khơi gợi sự tò mò</h3>
            <p>
              Kết nối bài học với <strong>thực tế đời sống</strong>: Toán không chỉ là công thức mà còn là tính tiền đi chợ; Vật lý không chỉ là định luật mà còn giải thích tại sao máy bay bay được. Khi hiểu "học để làm gì", con sẽ tự muốn tìm hiểu thêm.
            </p>

            {/* Section 4 */}
            <h2 id="sai-lam">4. Năm sai lầm nghiêm trọng cần tránh</h2>

            <div className="article-warning">
              <p>
                ⚠️ Tránh những sai lầm phổ biến sau, vì chúng có thể khiến con <strong>ghét học</strong> thay vì tiến bộ:
              </p>
            </div>

            <ol>
              <li><strong>So sánh con với "con nhà người ta":</strong> Mỗi trẻ có tốc độ phát triển khác nhau. So sánh chỉ tạo thêm áp lực và tổn thương lòng tự trọng.</li>
              <li><strong>Ép con học quá nhiều giờ:</strong> Trẻ tiểu học chỉ nên học thêm tối đa 1–1.5 tiếng/ngày. Hơn mức đó sẽ phản tác dụng.</li>
              <li><strong>Chỉ chú trọng điểm số:</strong> Điểm 10 không quan trọng bằng việc con <strong>hiểu bản chất</strong>. Hãy hỏi "con học được gì hôm nay?" thay vì "con được mấy điểm?"</li>
              <li><strong>La mắng khi con làm sai:</strong> Trẻ bị la sẽ sợ sai → không dám thử → không học được gì. Sai lầm chính là cơ hội tốt nhất để học.</li>
              <li><strong>Bỏ mặc cho gia sư 100%:</strong> Gia sư chỉ đồng hành 2–3 buổi/tuần. Phụ huynh vẫn cần theo dõi tiến trình và phối hợp với gia sư hàng tuần.</li>
            </ol>

            {/* Section 5 */}
            <h2 id="cong-cu">5. Công cụ hỗ trợ hữu ích cho phụ huynh</h2>

            <div className="article-table-wrapper">
              <table className="article-table">
                <thead>
                  <tr>
                    <th>Công cụ</th>
                    <th>Mục đích</th>
                    <th>Chi phí</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><strong>Anki / Quizlet</strong></td>
                    <td>Flashcard — ôn tập lặp lại ngắt quãng</td>
                    <td>Miễn phí</td>
                  </tr>
                  <tr>
                    <td><strong>XMind / MindMeister</strong></td>
                    <td>Tạo sơ đồ tư duy</td>
                    <td>Miễn phí (cơ bản)</td>
                  </tr>
                  <tr>
                    <td><strong>Forest App</strong></td>
                    <td>Chặn điện thoại, tập trung học</td>
                    <td>~50.000đ</td>
                  </tr>
                  <tr>
                    <td><strong>Google Calendar</strong></td>
                    <td>Lập thời gian biểu, nhắc lịch ôn tập</td>
                    <td>Miễn phí</td>
                  </tr>
                  <tr>
                    <td><strong>Gia Sư Tinh Hoa</strong></td>
                    <td>Tìm gia sư 1-1 đã xác thực, kèm sát con</td>
                    <td>Từ 120.000đ/buổi</td>
                  </tr>
                </tbody>
              </table>
            </div>

            {/* CTA */}
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
