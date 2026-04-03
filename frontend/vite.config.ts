import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// Plugin set header cho local dev và preview để giả lập Vercel Cache
const localCacheHeaderPlugin = () => ({
  name: 'vite-plugin-local-cache-headers',
  configureServer(server) {
    server.middlewares.use((req, res, next) => {
      // Vercel asset paths (Vite assets have hash in filename usually but locally we use cache too to test)
      if (req.url && req.url.includes('/assets/')) {
        res.setHeader('Cache-Control', 'public, max-age=31536000, immutable');
      } else if (req.url && req.url.match(/\.(ico|png|svg|jpg|jpeg|gif|webp|woff2?|css|js)$/)) {
        res.setHeader('Cache-Control', 'public, max-age=86400, stale-while-revalidate=86400');
      } else {
        // HTML and data routes
        res.setHeader('Cache-Control', 'public, max-age=0, must-revalidate');
      }
      next();
    });
  },
  configurePreviewServer(server) {
    server.middlewares.use((req, res, next) => {
      if (req.url && req.url.includes('/assets/')) {
        res.setHeader('Cache-Control', 'public, max-age=31536000, immutable');
      } else if (req.url && req.url.match(/\.(ico|png|svg|jpg|jpeg|gif|webp|woff2?|css|js)$/)) {
        res.setHeader('Cache-Control', 'public, max-age=86400, stale-while-revalidate=86400');
      } else {
        res.setHeader('Cache-Control', 'public, max-age=0, must-revalidate');
      }
      next();
    });
  }
});

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), localCacheHeaderPlugin()],
})
