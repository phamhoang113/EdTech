import { Link } from 'react-router-dom';
import { Calendar, Clock, ArrowRight } from 'lucide-react';

import { SEO } from '../../components/common/SEO';
import './BlogListPage.css';

interface BlogArticle {
  slug: string;
  title: string;
  excerpt: string;
  tag: string;
  date: string;
  readTime: string;
}

const ARTICLES: BlogArticle[] = [
  {
    slug: 'tai-sao-con-hoc-hoai-khong-vo',
    title: 'Tại Sao Con Học Hoài Không Vô? Nguyên Nhân Khoa Học Và Giải Pháp',
    excerpt: 'Phân tích 5 nguyên nhân khoa học khiến não bộ trẻ khó tiếp thu và 4 giải pháp hiệu quả giúp con ghi nhớ tốt hơn.',
    tag: 'Phương pháp học',
    date: '03/04/2026',
    readTime: '8 phút',
  },
  {
    slug: 'phuong-phap-day-con-hoc-tai-nha',
    title: '7 Phương Pháp Dạy Con Học Hiệu Quả Tại Nhà',
    excerpt: 'Hướng dẫn chi tiết cách đồng hành cùng con tại nhà: thiết lập không gian, rèn kỹ năng tự học và tránh 5 sai lầm phổ biến.',
    tag: 'Dành cho phụ huynh',
    date: '03/04/2026',
    readTime: '10 phút',
  },
  {
    slug: 'cach-chon-gia-su-gioi',
    title: 'Cách Chọn Gia Sư Giỏi Cho Con: 6 Tiêu Chí Vàng & Hướng Dẫn A-Z',
    excerpt: 'Hướng dẫn phụ huynh cách đánh giá gia sư theo 6 tiêu chí chuyên môn, quy trình sàng lọc 4 bước và checklist đánh giá nhanh.',
    tag: 'Tìm gia sư',
    date: '03/04/2026',
    readTime: '9 phút',
  },
  {
    slug: 'loi-ich-hoc-1-kem-1',
    title: 'Lợi Ích Vượt Trội Của Học 1 Kèm 1 Với Gia Sư So Với Học Nhóm',
    excerpt: 'So sánh toàn diện giữa học 1-1 và học nhóm dựa trên nghiên cứu giáo dục, giúp bạn chọn hình thức phù hợp nhất.',
    tag: 'Giáo dục',
    date: '03/04/2026',
    readTime: '7 phút',
  },
];

const PAGE_SCHEMA = {
  '@context': 'https://schema.org',
  '@type': 'CollectionPage',
  name: 'Blog Gia Sư Tinh Hoa — Kiến thức giáo dục & gia sư',
  description: 'Tổng hợp các bài viết chia sẻ kiến thức giáo dục, phương pháp học tập hiệu quả và hướng dẫn chọn gia sư phù hợp.',
  url: 'https://giasutinhhoa.com/bai-viet',
};

export const BlogListPage = () => {
  return (
    <div className="blog-page">
      <SEO
        title="Blog Chia Sẻ Kiến Thức Giáo Dục | Gia Sư Tinh Hoa"
        description="Tổng hợp bài viết chất lượng về phương pháp học tập khoa học, cách dạy con hiệu quả, hướng dẫn chọn gia sư và các mẹo giáo dục thực tế."
        keywords="blog gia sư, kiến thức giáo dục, phương pháp học tập, cách dạy con, kinh nghiệm chọn gia sư, tìm gia sư cho con, giáo dục gia đình, trung tâm gia sư uy tín"
        url="https://giasutinhhoa.com/bai-viet"
        schema={PAGE_SCHEMA}
      />

      <main className="blog-main">
        <div className="blog-hero">
          <div className="container">
            <h1 className="blog-hero-title">Blog Chia Sẻ Kiến Thức</h1>
            <p className="blog-hero-subtitle">
              Các bài viết chuyên sâu về phương pháp học tập, giáo dục và hướng dẫn thực tế dành cho phụ huynh và học sinh.
            </p>
          </div>
        </div>

        <div className="blog-grid">
          {ARTICLES.map((article) => (
            <div className="blog-card" key={article.slug}>
              <div className="blog-card-gradient" />
              <div className="blog-card-body">
                <span className="blog-card-tag">{article.tag}</span>
                <h2 className="blog-card-title">{article.title}</h2>
                <p className="blog-card-excerpt">{article.excerpt}</p>
                <div className="blog-card-footer">
                  <div className="blog-card-meta">
                    <span><Calendar size={14} /> {article.date}</span>
                    <span><Clock size={14} /> {article.readTime}</span>
                  </div>
                  <Link to={`/bai-viet/${article.slug}`} className="blog-card-link">
                    Đọc tiếp <ArrowRight size={16} />
                  </Link>
                </div>
              </div>
            </div>
          ))}
        </div>
      </main>
    </div>
  );
};
