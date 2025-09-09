import { defineConfig } from 'vite'

export default defineConfig({
  server: {
    host: true, // écoute 0.0.0.0 en conteneur
    port: 5173,
    // proxy: {
    //   '/api': {
    //     target: 'http://back:3000',
    //     changeOrigin: true,
    //   }
    // }
  }
})
