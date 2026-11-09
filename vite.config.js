import { defineConfig } from 'vite';

// Em desenvolvimento, repassa /api para a API Express.
export default defineConfig({
  server: {
    proxy: { '/api': 'http://localhost:3000' },
  },
});
