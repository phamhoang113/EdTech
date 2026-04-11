/**
 * Post-build pre-render script for SEO.
 *
 * After Vite builds the SPA into dist/, this script:
 * 1. Starts a local static server serving dist/
 * 2. Uses Puppeteer to visit each public route
 * 3. Captures the fully-rendered HTML (with React Helmet meta tags)
 * 4. Cleans up duplicate tags injected by Helmet
 * 5. Writes the clean HTML to dist/<route>/index.html
 *
 * Result: Googlebot receives full HTML with correct title, description,
 * canonical, Open Graph, and article content — no JavaScript needed.
 */

import { createServer } from 'http';
import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'fs';
import { join, extname } from 'path';
import puppeteer from 'puppeteer';

/* ─── Routes to pre-render (public SEO pages only) ─── */
const SEO_ROUTES = [
  '/',
  '/bai-viet',
  '/bai-viet/tai-sao-con-hoc-hoai-khong-vo',
  '/bai-viet/phuong-phap-day-con-hoc-tai-nha',
  '/bai-viet/cach-chon-gia-su-gioi',
  '/bai-viet/loi-ich-hoc-1-kem-1',
  '/bai-viet/tai-sao-chon-gia-su-tinh-hoa',
  '/tutors',
  '/classes',
  '/about',
  '/contact',
  '/faq',
  '/pricing',
  '/terms',
  '/privacy',
  '/careers',
];

const DIST_DIR = join(import.meta.dirname, '..', 'dist');
const PORT = 4173;
const NAVIGATE_TIMEOUT_MS = 30000;
const SETTLE_DELAY_MS = 3000;

/* ─── MIME types for static file server ─── */
const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.js':   'application/javascript',
  '.css':  'text/css',
  '.json': 'application/json',
  '.png':  'image/png',
  '.jpg':  'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.gif':  'image/gif',
  '.svg':  'image/svg+xml',
  '.webp': 'image/webp',
  '.ico':  'image/x-icon',
  '.woff': 'font/woff',
  '.woff2':'font/woff2',
  '.webmanifest': 'application/manifest+json',
};

function resolveFilePath(urlPath) {
  const exactPath = join(DIST_DIR, urlPath);
  if (existsSync(exactPath) && extname(exactPath)) return exactPath;

  const indexPath = join(DIST_DIR, urlPath, 'index.html');
  if (existsSync(indexPath)) return indexPath;

  return join(DIST_DIR, 'index.html');
}

function startStaticServer() {
  return new Promise((resolve) => {
    const server = createServer((req, res) => {
      const urlPath = decodeURIComponent(req.url.split('?')[0]);
      const filePath = resolveFilePath(urlPath);
      const ext = extname(filePath);
      const contentType = MIME_TYPES[ext] || 'application/octet-stream';
      try {
        const content = readFileSync(filePath);
        res.writeHead(200, { 'Content-Type': contentType });
        res.end(content);
      } catch {
        res.writeHead(404);
        res.end('Not found');
      }
    });
    server.listen(PORT, () => {
      console.log(`  Static server on http://localhost:${PORT}`);
      resolve(server);
    });
  });
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

/**
 * Clean duplicate meta/title/link tags that react-helmet-async injects.
 * Helmet adds data-rh="true" to its injected tags. We keep those and
 * remove the original static tags from index.html.
 */
function cleanDuplicateTags(html) {
  // Remove the original static <title> from index.html
  // Keep only the last <title> tag (Helmet's version)
  const titleMatches = [...html.matchAll(/<title[^>]*>.*?<\/title>/g)];
  if (titleMatches.length > 1) {
    // Helmet injects with data-rh, keep those. Remove originals.
    const helmetTitle = titleMatches.find(m => m[0].includes('data-rh'));
    if (helmetTitle) {
      // Remove all titles except the Helmet one
      for (const m of titleMatches) {
        if (m !== helmetTitle) {
          html = html.replace(m[0], '');
        }
      }
    } else {
      // No data-rh marker, keep only the last one
      for (let i = 0; i < titleMatches.length - 1; i++) {
        html = html.replace(titleMatches[i][0], '');
      }
    }
  }

  // Remove the original static meta tags that Helmet will override
  // Original static tags from index.html (without data-rh attribute)
  const staticMetaPatterns = [
    /<meta name="description" content="Nền tảng Gia Sư Tinh Hoa[^"]*"[^>]*>/g,
    /<meta name="keywords" content="gia sư, tìm gia sư[^"]*"[^>]*>/g,
    /<meta name="robots"[^>]*>/g,
    /<meta property="og:type" content="website"[^>]*>/g,
    /<meta property="og:title" content="Gia Sư Tinh Hoa - Nền Tảng[^"]*"[^>]*>/g,
    /<meta property="og:description" content="Nền tảng Gia Sư Tinh Hoa[^"]*"[^>]*>/g,
    /<meta property="og:image" content="\/logo\.webp"[^>]*>/g,
    /<meta property="og:url" content="https:\/\/giasutinhhoa\.com\/"[^>]*>/g,
    /<meta property="og:site_name"[^>]*>[^<]*(?=<meta)/g,
    /<meta name="twitter:card" content="summary_large_image"[^>]*>/g,
    /<meta name="twitter:title" content="Gia Sư Tinh Hoa - Nền Tảng[^"]*"[^>]*>/g,
    /<meta name="twitter:description" content="Nền tảng Gia Sư Tinh Hoa[^"]*"[^>]*>/g,
    /<meta name="twitter:image" content="\/logo\.png"[^>]*>/g,
  ];

  for (const pattern of staticMetaPatterns) {
    html = html.replace(pattern, '');
  }

  // Remove the original static canonical from index.html
  html = html.replace(
    /<link rel="canonical" href="https:\/\/giasutinhhoa\.com\/">/,
    ''
  );

  // Clean up excessive whitespace from removals
  html = html.replace(/\n\s*\n\s*\n/g, '\n');

  return html;
}

/**
 * Render a single route and save the HTML to dist.
 */
async function renderRoute(page, route) {
  const url = `http://localhost:${PORT}${route}`;

  await page.goto(url, {
    waitUntil: 'networkidle0',
    timeout: NAVIGATE_TIMEOUT_MS,
  });

  // Wait for React to mount
  await page.waitForFunction(
    () => document.querySelector('#root')?.children.length > 0,
    { timeout: 10000 }
  );

  // Give Helmet extra time to update <head>
  await sleep(SETTLE_DELAY_MS);

  let html = await page.content();
  html = cleanDuplicateTags(html);

  // Determine output path
  const outputDir = route === '/'
    ? DIST_DIR
    : join(DIST_DIR, route);

  if (!existsSync(outputDir)) {
    mkdirSync(outputDir, { recursive: true });
  }

  const outputFile = join(outputDir, 'index.html');
  writeFileSync(outputFile, html, 'utf-8');

  // Verification
  const pageTitle = await page.title();
  const hasCanonical = html.includes('rel="canonical"');
  const hasOgTitle = html.includes('property="og:title"');
  const isDefaultTitle = pageTitle === 'Gia Sư Tinh Hoa - Nền Tảng Kết Nối Gia Sư Hàng Đầu';
  const hasUniqueTitle = route === '/' || !isDefaultTitle;
  const allGood = hasUniqueTitle && hasCanonical && hasOgTitle;

  const status = allGood ? '✅' : '⚠️';
  console.log(`  ${status} ${route.padEnd(50)} → ${outputFile.replace(DIST_DIR, 'dist')}`);
  if (!hasUniqueTitle) console.log(`     ↳ Title: "${pageTitle}"`);

  return allGood;
}

/* ─── Main ─── */
async function main() {
  console.log('\n🔍 Pre-rendering SEO pages...\n');

  if (!existsSync(join(DIST_DIR, 'index.html'))) {
    console.error('❌ dist/index.html not found. Run "vite build" first.');
    process.exit(1);
  }

  const server = await startStaticServer();

  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-gpu'],
  });

  const page = await browser.newPage();

  // Block images/fonts to speed up rendering
  await page.setRequestInterception(true);
  page.on('request', (req) => {
    const type = req.resourceType();
    if (['image', 'font', 'media'].includes(type)) {
      req.abort();
    } else {
      req.continue();
    }
  });

  let successCount = 0;
  let warningCount = 0;
  let failCount = 0;

  for (const route of SEO_ROUTES) {
    try {
      const allGood = await renderRoute(page, route);
      allGood ? successCount++ : warningCount++;
    } catch (error) {
      console.error(`  ❌ ${route} — ${error.message}`);
      failCount++;
    }
  }

  await browser.close();
  server.close();

  console.log(`\n📊 Pre-render: ${successCount} ✅, ${warningCount} ⚠️, ${failCount} ❌\n`);

  if (failCount > 0) process.exit(1);
}

main();
