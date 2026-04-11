import { Link, useOutletContext } from 'react-router-dom';
import { Calendar, Clock, ArrowRight, ChevronRight } from 'lucide-react';
import { useScrollSpy } from '../../hooks/useScrollSpy';

import { SEO } from '../../components/common/SEO';
import { ArticleLeadMagnet } from '../../components/blog/ArticleLeadMagnet';
import { ArticleStickyBanner } from '../../components/blog/ArticleStickyBanner';
import './ArticleDetail.css';

const TABLE_OF_CONTENTS = [
  { id: 'nguyen-nhan', label: '1. Nguyên nhân khoa học' },
  { id: 'nao-bo', label: '2. Cơ chế não bộ' },
  { id: 'giai-phap', label: '3. Giải pháp hiệu quả' },
  { id: 'vai-tro-gia-su', label: '4. Vai trò của gia sư' },
];

const ARTICLE_SCHEMA = {
  '@context': 'https://schema.org',
  '@type': 'Article',
  headline: 'Tại Sao Con Học Hoài Không Vô? Nguyên Nhân Khoa Học Và Giải Pháp Từ Chuyên Gia',
  description: 'Phân tích 5 nguyên nhân khoa học khiến não bộ trẻ khó tiếp thu bài học và giải pháp cụ thể giúp con học giỏi hơn từ chuyên gia giáo dục.',
  author: { '@type': 'Organization', name: 'Gia Sư Tinh Hoa' },
  publisher: { '@type': 'Organization', name: 'Gia Sư Tinh Hoa', url: 'https://giasutinhhoa.com' },
  datePublished: '2026-04-03',
  dateModified: '2026-04-03',
  mainEntityOfPage: 'https://giasutinhhoa.com/bai-viet/tai-sao-con-hoc-hoai-khong-vo/',
};

export const HocHoaiKhongVoPage = () => {
  const { openRegister } = useOutletContext<{ openRegister: () => void }>();
  const activeId = useScrollSpy(TABLE_OF_CONTENTS.map(item => item.id), '-20% 0px -60% 0px');

  return (
    <div className="article-page">
      <SEO
        title="Tại Sao Con Học Hoài Không Vô? Nguyên Nhân Khoa Học & Giải Pháp | Gia Sư Tinh Hoa"
        description="Phân tích 5 nguyên nhân khoa học khiến não bộ trẻ khó tiếp thu bài học và giải pháp cụ thể, hiệu quả giúp con học giỏi hơn."
        keywords="con học hoài không vô, tại sao con học kém, trẻ mất gốc, phương pháp giúp trẻ tập trung, kỹ năng ghi nhớ, spaced repetition, active recall, vượt qua áp lực học tập, gia sư 1 kèm 1 lấy lại căn bản"
        url="https://giasutinhhoa.com/bai-viet/tai-sao-con-hoc-hoai-khong-vo"
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
              <span>Tại sao con học hoài không vô?</span>
            </div>
            <h1 className="article-hero-title">
              Tại Sao Con Học Hoài Không Vô? Nguyên Nhân Khoa Học Và Giải Pháp Từ Chuyên Gia
            </h1>
            <div className="article-hero-meta">
              <span><Calendar size={16} /> 03/04/2026</span>
              <span><Clock size={16} /> 8 phút đọc</span>
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
              <strong>"Con tôi ngồi học cả ngày mà vẫn không nhớ gì cả!"</strong> — Đây là lời than thở mà rất nhiều phụ huynh Việt Nam chia sẻ. Nhưng sự thật là, vấn đề không nằm ở sự chăm chỉ của con, mà ở <strong>cách não bộ hoạt động</strong> khi tiếp nhận thông tin. Bài viết này sẽ phân tích các nguyên nhân khoa học và đưa ra giải pháp cụ thể từ góc nhìn của các chuyên gia giáo dục.
            </p>

            {/* Section 1 */}
            <h2 id="nguyen-nhan">1. Năm nguyên nhân khoa học khiến con "học hoài không vô"</h2>

            <h3>1.1. Học tập thụ động và "nhồi nhét"</h3>
            <p>
              Não bộ con người không được thiết kế để ghi nhớ dữ liệu một cách máy móc. Khi trẻ chỉ đọc đi đọc lại sách giáo khoa mà không tương tác với kiến thức, thông tin chỉ dừng lại ở <strong>trí nhớ ngắn hạn</strong> và bị quên sau vài giờ. Hiện tượng này được nhà tâm lý học Hermann Ebbinghaus gọi là <strong>"Đường cong lãng quên"</strong> (Forgetting Curve).
            </p>

            <h3>1.2. Thiếu kế hoạch và mục tiêu rõ ràng</h3>
            <p>
              Khi học không có lộ trình, não bộ dễ rơi vào trạng thái <strong>quá tải nhận thức</strong> (Cognitive Overload). Trẻ phải xử lý quá nhiều thông tin rời rạc mà không thấy được sự kết nối giữa chúng, dẫn đến mệt mỏi và chán nản.
            </p>

            <h3>1.3. Bỏ qua cơ chế "hai chế độ" của não</h3>
            <p>
              Theo nghiên cứu Thần kinh học, não bộ có hai chế độ hoạt động: <strong>Focused Mode</strong> (tập trung sâu) và <strong>Diffuse Mode</strong> (phân tán, nghỉ ngơi). Nếu chỉ tập trung liên tục mà không cho não nghỉ, trẻ sẽ gặp tình trạng <strong>"bế tắc tư duy"</strong> — càng cố học càng không hiểu.
            </p>

            <h3>1.4. Xao nhãng bởi điện thoại và mạng xã hội</h3>
            <p>
              Các nghiên cứu gần đây cho thấy: chỉ cần điện thoại <strong>nằm trong tầm mắt</strong> (dù tắt nguồn) cũng đủ làm giảm 10–15% khả năng tập trung của trẻ. Mạng xã hội, thông báo liên tục phá vỡ quá trình hình thành liên kết thần kinh, khiến việc ghi nhớ sâu (deep encoding) trở nên bất khả thi.
            </p>

            <h3>1.5. Học sai "giờ vàng" sinh học</h3>
            <p>
              Mỗi người có một "chronotype" riêng — khoảng thời gian trong ngày đạt đỉnh cao năng lượng. Nhiều trẻ bị ép học vào buổi tối muộn khi não đã mệt mỏi, dẫn đến hiệu suất tiếp thu giảm đến 40% so với giờ cao điểm.
            </p>

            {/* Section 2 */}
            <h2 id="nao-bo">2. Cơ chế não bộ: Vì sao "chăm" chưa chắc đã "giỏi"?</h2>
            <p>
              Nhiều phụ huynh lầm tưởng rằng <strong>số giờ ngồi học = kết quả</strong>. Nhưng khoa học thần kinh chứng minh điều ngược lại: não bộ ghi nhớ tốt nhất khi được <strong>kích thích chủ động</strong> — tức là phải "vật lộn" với thông tin, chứ không phải thụ động đọc lại.
            </p>

            <div className="article-highlight">
              <p>
                💡 <strong>Nghiên cứu của ĐH Washington (2024):</strong> Sinh viên sử dụng phương pháp Active Recall (nhớ lại chủ động) ghi nhớ được gấp <strong>2.5 lần</strong> so với sinh viên chỉ đọc lại tài liệu, dù thời gian học bằng nhau.
              </p>
            </div>

            <p>
              Điều này giải thích tại sao có nhiều trẻ "ngồi học 5-6 tiếng mỗi ngày" nhưng điểm vẫn không cải thiện: vì các em đang học theo cách <strong>não bộ không ưa thích</strong>.
            </p>

            {/* Section 3 */}
            <ArticleLeadMagnet />
            <h2 id="giai-phap">3. Bốn giải pháp khoa học giúp con học "vào" ngay</h2>

            <div className="article-step">
              <div className="article-step-number">1</div>
              <div className="article-step-content">
                <h3>Active Recall — Nhớ lại chủ động</h3>
                <p>
                  Thay vì đọc lại sách, hãy hướng dẫn con <strong>gấp sách lại và tự trả lời câu hỏi</strong> về bài vừa học. Cha mẹ có thể hỏi: "Con vừa học xong, con giải thích lại cho ba/mẹ nghe nào?". Phương pháp này buộc não bộ chủ động truy xuất, từ đó củng cố mạch thần kinh mạnh mẽ hơn bất kỳ cách nào khác.
                </p>
              </div>
            </div>

            <div className="article-step">
              <div className="article-step-number">2</div>
              <div className="article-step-content">
                <h3>Spaced Repetition — Lặp lại ngắt quãng</h3>
                <p>
                  Ôn tập kiến thức vào các khoảng thời gian tăng dần: <strong>sau 1 ngày → 3 ngày → 7 ngày → 14 ngày</strong>. Đây là phương pháp được hàng triệu sinh viên trên thế giới sử dụng để chuẩn bị cho các kỳ thi lớn. Con chỉ cần ôn lại 10–15 phút mỗi lần là đủ.
                </p>
              </div>
            </div>

            <div className="article-step">
              <div className="article-step-number">3</div>
              <div className="article-step-content">
                <h3>Phương pháp Feynman — Giảng lại cho người khác</h3>
                <p>
                  Nobel laureate Richard Feynman nổi tiếng với câu nói: <em>"Nếu bạn không giải thích đơn giản được, bạn chưa hiểu rõ"</em>. Hãy cho con thử giảng lại bài cho em nhỏ, bạn bè hoặc thậm chí cho gấu bông. Khi nào "giảng" suôn sẻ, tức là con đã thực sự nắm vững.
                </p>
              </div>
            </div>

            <div className="article-step">
              <div className="article-step-number">4</div>
              <div className="article-step-content">
                <h3>Pomodoro — Học 30 phút, nghỉ 5 phút</h3>
                <p>
                  Kỹ thuật Pomodoro chia thời gian học thành các phiên tập trung cao độ (25–30 phút) xen kẽ nghỉ ngắn (5 phút). Sau 4 phiên thì nghỉ dài 15–20 phút. Phương pháp này tôn trọng cơ chế Focused–Diffuse Mode của não, giúp trẻ duy trì sự tỉnh táo suốt buổi học.
                </p>
              </div>
            </div>

            {/* Section 4 */}
            <h2 id="vai-tro-gia-su">4. Tại sao gia sư 1 kèm 1 là "chìa khóa vàng"?</h2>
            <p>
              Tất cả các phương pháp trên đều hiệu quả, nhưng đòi hỏi trẻ phải có <strong>người hướng dẫn ban đầu</strong> để hình thành thói quen. Đây chính là lý do gia sư 1 kèm 1 được coi là giải pháp tối ưu:
            </p>

            <ul>
              <li><strong>Chẩn đoán chính xác lỗ hổng:</strong> Gia sư sẽ dùng 1–2 buổi đầu để đánh giá năng lực thực sự của con, tìm ra gốc rễ vấn đề thay vì chỉ "dạy chạy theo chương trình".</li>
              <li><strong>Cá nhân hóa phương pháp:</strong> Mỗi trẻ có phong cách học riêng (thị giác, thính giác, vận động). Gia sư giỏi sẽ nhận biết và điều chỉnh cách truyền đạt cho phù hợp.</li>
              <li><strong>Khơi gợi hứng thú:</strong> Một gia sư tâm huyết không chỉ dạy kiến thức mà còn giúp con <strong>yêu thích môn học</strong>, đó mới là động lực lâu dài nhất.</li>
              <li><strong>Theo dõi tiến bộ liên tục:</strong> Phụ huynh sẽ được cập nhật tình hình học tập hàng tuần, từ đó cùng gia sư điều chỉnh kế hoạch kịp thời.</li>
            </ul>

            <div className="article-tip">
              <p>
                ✅ <strong>Mẹo:</strong> Hãy bắt đầu bằng một thay đổi nhỏ ngay hôm nay — cho con bỏ điện thoại ra xa khi học, thử hỏi "con giải thích lại cho ba/mẹ nghe" sau mỗi bài. Chỉ cần kiên trì 2 tuần, bạn sẽ thấy sự khác biệt rõ rệt!
              </p>
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
