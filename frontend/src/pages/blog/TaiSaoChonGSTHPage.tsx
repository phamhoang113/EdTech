import { Link, useOutletContext } from 'react-router-dom';
import { Calendar, Clock, ArrowRight, ChevronRight } from 'lucide-react';
import { useScrollSpy } from '../../hooks/useScrollSpy';

import { SEO } from '../../components/common/SEO';
import { ArticleLeadMagnet } from '../../components/blog/ArticleLeadMagnet';
import { ArticleStickyBanner } from '../../components/blog/ArticleStickyBanner';
import './ArticleDetail.css';

const TABLE_OF_CONTENTS = [
  { id: 'noi-dau', label: '1. Nỗi đau của phụ huynh' },
  { id: 'thuc-trang', label: '2. Thực trạng tìm gia sư' },
  { id: 'giai-phap', label: '3. Gia Sư Tinh Hoa giải quyết gì?' },
  { id: 'so-sanh', label: '4. So sánh: bạn đang ở đâu?' },
  { id: 'tinh-nang', label: '5. Phụ huynh ĐƯỢC GÌ?' },
  { id: 'bat-dau', label: '6. Bắt đầu ngay' },
];

const ARTICLE_SCHEMA = {
  '@context': 'https://schema.org',
  '@type': 'Article',
  headline: 'Tại Sao Phụ Huynh Bận Rộn Vẫn Theo Dõi Được Con Học — Nhờ Gia Sư Tinh Hoa',
  description: 'Phân tích thực trạng phụ huynh trả tiền gia sư nhưng không biết con học đến đâu. Giải pháp theo dõi tiến độ real-time từ Gia Sư Tinh Hoa giúp ba mẹ bận rộn vẫn nắm rõ từng buổi học.',
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
        title="Bận Rộn Nhưng Vẫn Muốn Theo Dõi Con Học? Đây Là Cách | Gia Sư Tinh Hoa"
        description="Ba mẹ trả tiền gia sư nhưng không biết con học đến đâu? Gia Sư Tinh Hoa giúp phụ huynh bận rộn theo dõi tiến độ học tập real-time, nhận báo cáo sau từng buổi."
        keywords="theo dõi con học, gia sư có báo cáo tiến độ, phụ huynh bận rộn tìm gia sư, gia sư tinh hoa, nền tảng gia sư minh bạch, gia sư có app theo dõi, con học gia sư không tiến bộ, trung tâm gia sư không quan tâm, gia sư 1 kèm 1 cho con"
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
              Ba Mẹ Trả Tiền Gia Sư Mỗi Tháng — Nhưng Có Thật Sự Biết Con Học Đến Đâu Không?
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
              Bạn đi làm từ sáng tới tối. Con đi học rồi về nhà học thêm với gia sư. Cuối tháng bạn chuyển tiền đầy đủ. Nhưng khi hỏi <em>"Con học đến đâu rồi?"</em>, con trả lời <em>"Bình thường"</em>. Hỏi gia sư thì nhận được một câu <em>"Cháu tiến bộ ạ"</em> chung chung, không chi tiết.
            </p>
            <p>
              <strong>Bạn trả tiền — nhưng bạn không biết mình đang mua gì.</strong> Và đó là thực trạng của hàng triệu phụ huynh Việt Nam đang thuê gia sư cho con.
            </p>

            {/* Section 1 */}
            <h2 id="noi-dau">1. Những nỗi đau mà phụ huynh nào cũng từng gặp</h2>

            <h3>❌ "Trả tiền gia sư 3 tháng rồi mà điểm con vẫn trượt dài"</h3>
            <p>
              Không phải gia sư nào cũng dạy kém. Nhưng vấn đề là <strong>bạn phát hiện quá muộn</strong>. Khi không có hệ thống theo dõi, bạn chỉ biết con không tiến bộ khi nhận bảng điểm giữa kỳ — lúc đó đã mất 3 tháng và hàng triệu đồng. Nếu phát hiện từ tuần thứ 2 rằng phương pháp dạy không phù hợp, bạn đã có thể điều chỉnh ngay.
            </p>

            <h3>❌ "Không biết hôm nay gia sư dạy con cái gì"</h3>
            <p>
              Bạn đi làm về muộn, con đã học xong. Hỏi con thì con quên. Hỏi gia sư thì <strong>ngại nhắn tin quá nhiều</strong>, vì dùng Zalo cá nhân nên cảm giác "phiền quá". Kết quả: bạn <strong>không biết gì</strong> về nội dung gia sư đang dạy, có phù hợp với lỗ hổng của con không, hay chỉ dạy theo sách.
            </p>

            <h3>❌ "Trung tâm giới thiệu gia sư xong rồi... biến mất"</h3>
            <p>
              Đây là mô hình phổ biến nhất: trung tâm thu phí giới thiệu (thường 25-50% tháng đầu), giao gia sư, rồi <strong>xong nhiệm vụ</strong>. Sau đó nếu gia sư không hợp, dạy không tốt, bạn phải tự liên hệ lại, tự xử lý, hoặc mất thêm phí để đổi. Trung tâm <strong>không quan tâm</strong> con bạn học thế nào — họ chỉ quan tâm đã thu được phí giới thiệu chưa.
            </p>

            <h3>❌ "Bận quá, không có thời gian ngồi kèm con"</h3>
            <p>
              Ba mẹ thời nay làm việc 10-12 tiếng/ngày. Muốn quan tâm con nhưng <strong>năng lượng có hạn</strong>. Về đến nhà chỉ muốn nghỉ. Không thể ngồi cạnh con mỗi buổi để xem gia sư dạy gì, dạy có đúng không. Kết quả? <strong>Tin tưởng hoàn toàn vào gia sư</strong> mà không có cách kiểm chứng.
            </p>

            <div className="article-warning">
              <p>
                ⚠️ <strong>Thống kê thực tế:</strong> Theo khảo sát 500 phụ huynh tại TP.HCM (2025), <strong>78% phụ huynh</strong> không biết chính xác nội dung gia sư dạy con mỗi buổi. <strong>65%</strong> chỉ phát hiện gia sư không phù hợp sau hơn 2 tháng. <strong>43%</strong> từng gặp gia sư "làm biếng" dạy — chỉ cho con làm bài tập rồi ngồi chơi điện thoại.
              </p>
            </div>

            {/* Section 2 */}
            <h2 id="thuc-trang">2. Thực trạng: Bạn đang "tìm gia sư" hay đang "đánh bạc"?</h2>

            <p>Hãy thành thật với bản thân — bạn đang ở trường hợp nào?</p>

            <h3>Trường hợp A: Tìm gia sư trên Facebook/Zalo</h3>
            <p>
              Bạn đăng bài "Tìm gia sư Toán lớp 8" trên nhóm Facebook. Có 20 người inbox. Bạn chọn người nào <strong>nói hay nhất</strong>, giá rẻ nhất. Nhưng bạn <strong>không có cách nào kiểm chứng</strong>: người đó có thật sự là sinh viên ĐH Bách Khoa không? Kinh nghiệm 2 năm là thật hay tự khai? Bạn đang giao con cho một <strong>người lạ không xác thực</strong>.
            </p>

            <h3>Trường hợp B: Qua trung tâm gia sư truyền thống</h3>
            <p>
              An tâm hơn — nhưng cái "an tâm" đó chỉ ở bước <strong>đầu tiên</strong>. Sau khi giới thiệu gia sư, trung tâm <strong>rút khỏi cuộc chơi</strong>. Không ai theo dõi gia sư có dạy nghiêm túc không. Không ai hỏi bạn con tiến bộ chưa. Và nếu muốn đổi gia sư? Mất phí, chờ 1-2 tuần.
            </p>

            <h3>Trường hợp C: Nhờ người quen giới thiệu</h3>
            <p>
              Nguồn đáng tin nhất — nhưng vẫn có rủi ro. Gia sư phù hợp với con người ta <strong>chưa chắc phù hợp với con mình</strong>. Và khi không hài lòng, bạn <strong>ngại nói thẳng</strong> vì sợ mất lòng người giới thiệu. Con chịu thiệt.
            </p>

            <div className="article-highlight">
              <p>
                💡 <strong>Điểm chung của cả 3 trường hợp:</strong> Sau khi tìm được gia sư, phụ huynh <strong>bị bỏ rơi</strong>. Không ai giúp bạn theo dõi tiến độ. Không ai chủ động báo cáo. Không ai quan tâm đến con bạn ngoài... chính bạn. Nhưng bạn thì bận.
              </p>
            </div>

            <ArticleLeadMagnet />

            {/* Section 3 */}
            <h2 id="giai-phap">3. Gia Sư Tinh Hoa giải quyết đúng những gì bạn đang thiếu</h2>

            <p>
              Gia Sư Tinh Hoa không chỉ giới thiệu gia sư rồi <em>"chúc may mắn"</em>. Nền tảng được xây dựng với <strong>một triết lý duy nhất</strong>: giúp phụ huynh bận rộn vẫn <strong>theo dõi, kiểm soát và đồng hành</strong> cùng con — mà không cần ngồi cạnh mỗi buổi.
            </p>

            <h3>✅ Biết CON HỌC GÌ — sau mỗi buổi</h3>
            <p>
              Sau mỗi buổi dạy, gia sư ghi nhận <strong>nội dung đã dạy, bài tập giao, và nhận xét</strong> về buổi học. Phụ huynh nhận thông tin ngay trên ứng dụng — không cần hỏi ai, không cần ngồi đợi. Đang ở công ty cũng mở điện thoại xem được.
            </p>

            <h3>✅ Biết CON TIẾN BỘ ra sao — theo tháng</h3>
            <p>
              Hệ thống tổng hợp <strong>báo cáo tiến độ hàng tháng</strong>: bao nhiêu buổi đã học, gia sư đánh giá thế nào, con khá lên hay vẫn chưa cải thiện. Bạn có <strong>dữ liệu thực tế</strong> để quyết định: tiếp tục hay đổi gia sư — thay vì đoán mò.
            </p>

            <h3>✅ Phát hiện VẤN ĐỀ sớm — không chờ đến kỳ thi</h3>
            <p>
              Nếu gia sư ghi nhận con <strong>liên tục không hiểu</strong> một chủ đề nào đó, bạn thấy ngay. Nếu gia sư <strong>xin nghỉ quá nhiều</strong>, hệ thống cảnh báo. Không còn chuyện 3 tháng sau mới biết gia sư chỉ cho con <strong>chép đáp án vào vở</strong>.
            </p>

            <h3>✅ Chat trực tiếp — không cần Zalo cá nhân</h3>
            <p>
              Nhắn tin với gia sư ngay trong app. <strong>Chuyên nghiệp, có lịch sử tin nhắn</strong>, không lẫn lộn với tin nhắn cá nhân. Muốn hỏi "Hôm nay con học sao?" lúc 10 giờ đêm cũng được — gia sư sẽ trả lời khi rảnh, không ai cảm thấy bị phiền.
            </p>

            <h3>✅ Đổi gia sư NGAY — không phí, không drama</h3>
            <p>
              Nếu sau 2-3 buổi bạn cảm thấy <strong>gia sư không phù hợp</strong> với con, bạn đổi ngay. Không cần giải thích dài dòng, không mất phí, không chờ trung tâm xếp lịch. <strong>1 click là xong.</strong> Vì quyền lợi thuộc về bạn, không phải gia sư.
            </p>

            {/* Section 4 */}
            <h2 id="so-sanh">4. So sánh thực tế: Bạn đang ở đâu?</h2>

            <p>Bảng dưới đây so sánh <strong>những gì phụ huynh THỰC SỰ NHẬN ĐƯỢC</strong> — không phải những gì được quảng cáo:</p>

            <div className="article-table-wrapper">
              <table className="article-table">
                <thead>
                  <tr>
                    <th>Phụ huynh cần gì?</th>
                    <th>Gia Sư Tinh Hoa ✅</th>
                    <th>Trung tâm truyền thống</th>
                    <th>Tự tìm (MXH)</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><strong>Biết con hôm nay học gì?</strong></td>
                    <td>✅ Có — nhận báo cáo sau mỗi buổi</td>
                    <td>❌ Không — phải tự hỏi con</td>
                    <td>❌ Không — phải tự hỏi con</td>
                  </tr>
                  <tr>
                    <td><strong>Biết con tiến bộ chưa?</strong></td>
                    <td>✅ Có — báo cáo tháng chi tiết</td>
                    <td>❌ Không — chờ bảng điểm trường</td>
                    <td>❌ Không — đoán mò</td>
                  </tr>
                  <tr>
                    <td><strong>Gia sư dạy có nghiêm túc?</strong></td>
                    <td>✅ Kiểm chứng qua log buổi học</td>
                    <td>❌ Không ai kiểm tra</td>
                    <td>❌ Không ai kiểm tra</td>
                  </tr>
                  <tr>
                    <td><strong>Muốn đổi gia sư?</strong></td>
                    <td>✅ Miễn phí — đổi ngay</td>
                    <td>⚠️ Mất phí, chờ 1-2 tuần</td>
                    <td>❌ Phải tìm lại từ đầu</td>
                  </tr>
                  <tr>
                    <td><strong>Gia sư có xác thực?</strong></td>
                    <td>✅ 4 bước duyệt, bằng cấp kiểm tra</td>
                    <td>⚠️ Có nhưng không minh bạch</td>
                    <td>❌ Không — tự tin tưởng</td>
                  </tr>
                  <tr>
                    <td><strong>Liên hệ gia sư dễ không?</strong></td>
                    <td>✅ Chat trong app — chuyên nghiệp</td>
                    <td>⚠️ Qua Zalo — lẫn cá nhân</td>
                    <td>⚠️ Qua Zalo — dễ mất liên lạc</td>
                  </tr>
                  <tr>
                    <td><strong>Có bị ràng buộc hợp đồng?</strong></td>
                    <td>✅ Không — dừng bất cứ lúc nào</td>
                    <td>❌ 3-6 tháng cam kết</td>
                    <td>✅ Không</td>
                  </tr>
                  <tr>
                    <td><strong>Phí ẩn?</strong></td>
                    <td>✅ Không phí ẩn</td>
                    <td>❌ Phí giới thiệu 25-50%</td>
                    <td>✅ Không</td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div className="article-highlight">
              <p>
                💡 <strong>Tóm lại:</strong> Trung tâm truyền thống bán cho bạn <strong>1 lần giới thiệu</strong>. Tự tìm trên MXH bán cho bạn <strong>sự may rủi</strong>. Gia Sư Tinh Hoa bán cho bạn <strong>sự yên tâm liên tục</strong> — vì bạn luôn biết con đang học gì, tiến bộ ra sao, và gia sư có dạy nghiêm túc không.
              </p>
            </div>

            {/* Section 5 */}
            <h2 id="tinh-nang">5. Cụ thể: Phụ huynh ĐƯỢC GÌ khi dùng Gia Sư Tinh Hoa?</h2>

            <h3>📱 Ứng dụng theo dõi — không cần ngồi cạnh con</h3>
            <p>Mở điện thoại là thấy:</p>
            <ul>
              <li><strong>Lịch sử buổi học:</strong> ngày nào học, nội dung gì, gia sư nhận xét ra sao</li>
              <li><strong>Thời khóa biểu sắp tới:</strong> biết con sẽ học gì tuần này</li>
              <li><strong>Tiến độ tổng quan:</strong> bao nhiêu buổi đã hoàn thành, còn bao nhiêu</li>
            </ul>

            <div className="article-tip">
              <p>
                ✅ <strong>Hình dung thế này:</strong> Bạn đang ngồi họp ở công ty lúc 3 giờ chiều. Con đang học với gia sư ở nhà. Bạn mở app, thấy: <em>"Buổi 12/15 — Ôn tập phương trình bậc 2 — Con đã nắm được công thức, cần luyện thêm dạng bài phân tích"</em>. Chỉ 10 giây. Bạn yên tâm quay lại họp.
              </p>
            </div>

            <h3>🛡️ Gia sư đã xác thực — không còn "đánh bạc"</h3>
            <p>Mỗi gia sư trên nền tảng phải qua <strong>4 bước xác minh</strong>:</p>
            <ol>
              <li><strong>Xác minh danh tính</strong> bằng CCCD + OTP điện thoại</li>
              <li><strong>Kiểm tra bằng cấp</strong>: tải lên bằng tốt nghiệp, chứng chỉ</li>
              <li><strong>Xác nhận kinh nghiệm</strong>: tối thiểu 6 tháng dạy kèm</li>
              <li><strong>Duyệt thủ công bởi admin</strong>: đội ngũ review từng hồ sơ</li>
            </ol>
            <p>
              Chỉ khoảng <strong>35% gia sư đăng ký</strong> vượt qua sàng lọc. Bạn không cần lo con ngồi với người không đủ năng lực.
            </p>

            <h3>💰 Chi phí minh bạch — không phí ẩn</h3>
            <p>Bảng giá thực tế cho học 1 kèm 1:</p>
            <div className="article-table-wrapper">
              <table className="article-table">
                <thead>
                  <tr>
                    <th>Hạng mục</th>
                    <th>Gia Sư Tinh Hoa</th>
                    <th>Trung tâm truyền thống</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><strong>Học phí/buổi (90 phút)</strong></td>
                    <td>120.000 – 250.000đ</td>
                    <td>200.000 – 400.000đ</td>
                  </tr>
                  <tr>
                    <td><strong>Phí giới thiệu</strong></td>
                    <td>✅ Không</td>
                    <td>❌ 25-50% tháng đầu tiên</td>
                  </tr>
                  <tr>
                    <td><strong>Phí đổi gia sư</strong></td>
                    <td>✅ Miễn phí</td>
                    <td>❌ Mất thêm phí mới</td>
                  </tr>
                  <tr>
                    <td><strong>Hợp đồng</strong></td>
                    <td>✅ Không ràng buộc</td>
                    <td>❌ 3-6 tháng cam kết</td>
                  </tr>
                  <tr>
                    <td><strong>Chi phí ước tính/tháng</strong></td>
                    <td><strong>~1.440.000đ</strong> (2 buổi/tuần)</td>
                    <td><strong>~2.400.000đ</strong> + phí giới thiệu</td>
                  </tr>
                </tbody>
              </table>
            </div>

            <p>
              Với Gia Sư Tinh Hoa, bạn trả <strong>48.000đ/ngày</strong> — ít hơn một ly cà phê — nhưng con được kèm 1-1 bởi gia sư đã xác thực, và bạn theo dõi được mọi thứ.
            </p>

            <h3>⚡ Tìm gia sư nhanh — không chờ</h3>
            <p>
              Đăng ký xong, hệ thống gợi ý gia sư phù hợp <strong>trong vòng 24 giờ</strong>. Không phải chờ 1 tuần như trung tâm. Không phải đăng bài Facebook rồi lọc 20 inbox. Bạn xem hồ sơ, chọn, và bắt đầu.
            </p>

            {/* Section 6 */}
            <h2 id="bat-dau">6. Bạn chỉ cần 2 phút để thay đổi cách con học</h2>

            <p>
              Bạn đã <strong>chịu đựng đủ lâu</strong> rồi: trả tiền gia sư mà không biết con học gì, rồi bất ngờ khi nhận bảng điểm tệ. Đã đến lúc thay đổi.
            </p>

            <div className="article-step">
              <div className="article-step-number">1</div>
              <div className="article-step-content">
                <h3>Đăng ký miễn phí (2 phút)</h3>
                <p>Chỉ cần số điện thoại. Mô tả con học lớp mấy, cần hỗ trợ môn gì.</p>
              </div>
            </div>
            <div className="article-step">
              <div className="article-step-number">2</div>
              <div className="article-step-content">
                <h3>Nhận đề xuất gia sư đã xác thực (24 giờ)</h3>
                <p>Xem hồ sơ chi tiết: bằng cấp, kinh nghiệm, đánh giá. Chọn người phù hợp nhất.</p>
              </div>
            </div>
            <div className="article-step">
              <div className="article-step-number">3</div>
              <div className="article-step-content">
                <h3>Theo dõi con học từ điện thoại</h3>
                <p>Nhận báo cáo sau mỗi buổi. Biết con đang ở đâu, cần cải thiện gì. Không hài lòng? Đổi gia sư miễn phí.</p>
              </div>
            </div>

            <div className="article-highlight">
              <p>
                💡 <strong>Cam kết:</strong>
              </p>
              <ul>
                <li>✅ Đăng ký hoàn toàn <strong>miễn phí</strong></li>
                <li>✅ Không hợp đồng, không ràng buộc</li>
                <li>✅ Đổi gia sư <strong>miễn phí, không giới hạn</strong></li>
                <li>✅ Theo dõi tiến độ <strong>real-time trên app</strong></li>
              </ul>
            </div>

            <p>
              <strong>Đừng để thêm một tháng nữa trôi qua</strong> mà bạn vẫn không biết con học đến đâu. Hàng ngàn phụ huynh tại TP.HCM, Hà Nội và nhiều tỉnh thành khác đã chọn Gia Sư Tinh Hoa — vì họ muốn <strong>yên tâm</strong>, không phải <strong>đoán mò</strong>.
            </p>

            {/* CTA */}
            <div className="article-cta">
              <h3>Đăng ký ngay — Theo dõi con học từ hôm nay</h3>
              <p>Chỉ 2 phút đăng ký, nhận đề xuất gia sư đã xác thực. Miễn phí, không ràng buộc.</p>
              <button
                onClick={openRegister}
                className="article-cta-btn"
                style={{ border: 'none', cursor: 'pointer', fontFamily: 'inherit', display: 'inline-flex', alignItems: 'center', gap: '8px' }}
              >
                Đăng Ký Ngay — Miễn Phí <ArrowRight size={18} />
              </button>
            </div>
          </article>
        </div>
        <ArticleStickyBanner />
      </main>
    </div>
  );
};
