/* ──────────────────────────────────────────────────────────────────────────
   MarkdownRenderer.tsx — Render markdown + LaTeX (KaTeX) cho AI messages
   Hỗ trợ: headings, bold/italic, lists, code blocks, tables, math ($..$ / $$..$$)
   ────────────────────────────────────────────────────────────────────────── */

import ReactMarkdown from 'react-markdown';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';
import remarkGfm from 'remark-gfm';
import 'katex/dist/katex.min.css';

import './MarkdownRenderer.css';

interface MarkdownRendererProps {
  content: string;
  className?: string;
}

/**
 * Preprocess nội dung AI trả về:
 * - Chuẩn hóa LaTeX delimiters: \( \) → $, \[ \] → $$
 * - Đảm bảo block math ($$) có newline trước/sau
 * - Auto-close unclosed $ delimiters
 */
function preprocessContent(raw: string): string {
  let processed = raw;

  // \( ... \) → $ ... $ (inline math)
  processed = processed.replace(/\\\((.*?)\\\)/g, ' $$$1$$ ');

  // \[ ... \] → $$ ... $$ (block math)
  processed = processed.replace(/\\\[([\s\S]*?)\\\]/g, '\n$$$$$1$$$$\n');

  // Auto-close unclosed inline math: tìm $ lẻ không có $ đóng
  processed = fixUnclosedDollars(processed);

  return processed;
}

/**
 * Tìm và đóng các $ inline math bị thiếu $ đóng.
 * VD: "$x_1" → "$x_1$"
 * Bỏ qua $$ (block math) — chỉ xử lý single $.
 */
function fixUnclosedDollars(text: string): string {
  const lines = text.split('\n');

  return lines.map(line => {
    // Bỏ qua dòng block math ($$)
    const trimmed = line.trim();
    if (trimmed.startsWith('$$')) return line;

    // Đếm single $ (không phải $$)
    // Thay thế $$ tạm để đếm chính xác single $
    const withoutDoubleDollar = line.replace(/\$\$/g, '');
    const dollarCount = (withoutDoubleDollar.match(/\$/g) || []).length;

    // Nếu số $ lẻ → có $ không đóng → thêm $ cuối dòng
    if (dollarCount % 2 !== 0) {
      return line + '$';
    }

    return line;
  }).join('\n');
}

export function MarkdownRenderer({ content, className = '' }: MarkdownRendererProps) {
  const processed = preprocessContent(content);

  return (
    <div className={`md-renderer ${className}`}>
      <ReactMarkdown
        remarkPlugins={[remarkGfm, remarkMath]}
        rehypePlugins={[rehypeKatex]}
        components={{
          // Custom code block renderer
          code({ className: codeClass, children, ...props }) {
            const isInline = !codeClass;
            if (isInline) {
              return <code className="md-inline-code" {...props}>{children}</code>;
            }
            const language = codeClass?.replace('language-', '') || '';
            return (
              <div className="md-code-block">
                {language && <div className="md-code-block__lang">{language}</div>}
                <pre>
                  <code className={codeClass} {...props}>{children}</code>
                </pre>
              </div>
            );
          },
          // Mở link trong tab mới
          a({ children, ...props }) {
            return <a {...props} target="_blank" rel="noopener noreferrer">{children}</a>;
          },
        }}
      >
        {processed}
      </ReactMarkdown>
    </div>
  );
}
