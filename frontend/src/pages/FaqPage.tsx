// @ts-nocheck
import { useOutletContext } from 'react-router-dom';
import type { PublicLayoutContext } from '../components/layout/PublicLayout';

import { ChevronDown, ChevronUp, HelpCircle } from 'lucide-react';


import './FaqPage.css';

const faqs = [
  {
    category: 'Dành cho Phụ Huynh & Học Sinh',
    items: [
      {
        q: 'Tôi đăng ký tìm gia sư như thế nào?',
        a: 'Bạn có thể nhấn vào nút "Tìm Gia Sư Ngay" trên trang chủ để xem danh sách gia sư hoặc bấm "Mở lớp nhanh qua Zalo" để được đội ngũ CSKH hỗ trợ tư vấn và tìm gia sư miễn phí trong vòng 24 giờ.'
      },
      {
        q: 'Làm sao để biết gia sư có uy tín không?',
        a: 'Toàn bộ gia sư trên hệ thống Gia Sư Tinh Hoa đều đã được xác thực 100% về căn cước công dân, bằng cấp (đối với giáo viên) và thẻ sinh viên/bảng điểm (đối với sinh viên). Bạn có thể xem ảnh chụp hồ sơ này ngay trong hồ sơ gia sư.'
      },
      {
        q: 'Chính sách đổi gia sư và thanh toán như thế nào?',
        a: 'Gia Sư Tinh Hoa không có chính sách học thử miễn phí. Nếu sau buổi học đầu tiên Phụ huynh không đồng ý tiếp tục, trung tâm sẽ thu 50% học phí của buổi đó để gửi cho gia sư và hỗ trợ đổi gia sư khác hoàn toàn miễn phí. Nếu quyết định hủy lớp đang dạy, Phụ huynh có trách nhiệm thanh toán đầy đủ học phí cho tất cả các buổi học đã diễn ra trong tháng. Trung tâm luôn đảm bảo thanh toán lương cho gia sư đúng và đủ theo số buổi đã dạy giảng thực tế.'
      }
    ]
  },
  {
    category: 'Dành cho Gia Sư',
    items: [
      {
        q: 'Mức phí nhận lớp tại Gia Sư Tinh Hoa là bao nhiêu?',
        a: 'Đối với mọi hợp đồng nhận lớp thành công, Gia Sư Tinh Hoa áp dụng mức phí (GSE Fee) cực kỳ ưu đãi, dao động từ 20% - 30% tháng lương đầu tiên tùy thuộc vào loại lớp và yêu cầu đặc biệt. Từ tháng thứ 2 trở đi gia sư không cần đóng thêm khoản chi phí nào.'
      },
      {
        q: 'Thủ tục hoàn phí nhận lớp nếu bị hỏng lớp như thế nào?',
        a: 'Nếu hỏng lớp do Phụ huynh trước 1 buổi, Gia sư được hoàn 100%. Nếu hỏng từ buổi thứ 2 trở đi, trung tâm sẽ khấu trừ lại 20% phí nhận lớp cho mỗi buổi đã diễn ra (Bạn có thể xem chi tiết ở mục Điều khoản Dịch vụ). Tiền hoàn phí sẽ được xử lý trong vòng 48h vào tài khoản ngân hàng của gia sư.'
      },
      {
        q: 'Làm thế nào để hồ sơ của tôi hiển thị ở trang đầu?',
        a: 'Hệ thống tự động ưu tiên các gia sư có thời gian phản hồi nhanh, điểm đánh giá trung bình từ học viên cao (trên 4.5/5) và số buổi dạy đều đặn. Đặc biệt, cập nhật hồ sơ với đầy đủ hình ảnh/chứng chỉ sẽ giúp tỷ lệ phụ huynh chọn bạn cao hơn 80%.'
      }
    ]
  }
];

export const FaqPage = () => {
  return (
    <div className="faq-page">
      <main className="faq-main">
        <div className="faq-header">
          <div className="container">
            <h1 className="faq-title">Câu hỏi thường gặp</h1>
            <p className="faq-subtitle">Giải đáp các thắc mắc nhanh chóng liên quan đến quy trình tìm và nhận lớp tại Gia Sư Tinh Hoa.</p>
          </div>
        </div>

        <div className="container faq-content-wrapper">
          <div className="faq-glass-card">
            {faqs.map((category, cIdx) => (
              <div key={cIdx} className="faq-category">
                <h2 className="faq-category-title">
                  <HelpCircle size={24} className="faq-category-icon" />
                  {category.category}
                </h2>
                
                <div className="accordion-list">
                  {category.items.map((item, iIdx) => {
                    const isOpen = !!openIndexes[`${cIdx}-${iIdx}`];
                    return (
                      <div className={`accordion-item ${isOpen ? 'active' : ''}`} key={iIdx}>
                        <button 
                          className="accordion-header" 
                          onClick={() => toggleAccordion(cIdx, iIdx)}
                        >
                          <span className="accordion-question">{item.q}</span>
                          {isOpen ? <ChevronUp size={20} className="accordion-icon"/> : <ChevronDown size={20} className="accordion-icon"/>}
                        </button>
                        <div className="accordion-collapse" style={{ height: isOpen ? 'auto' : 0, overflow: 'hidden' }}>
                          <div className="accordion-body">
                            {item.a}
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            ))}
          </div>
        </div>
      </main>

      </div>
  );
};
