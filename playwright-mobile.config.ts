import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  reporter: [['html', { open: 'never' }], ['list']],
  
  use: {
    baseURL: 'http://localhost:3000',
    video: 'on',  // Grabar todos los tests móviles
    screenshot: 'only-on-failure',
    trace: 'on-first-retry',
  },

  projects: [
    // 📱 DISPOSITIVOS iOS
    {
      name: 'iPhone 13',
      use: { ...devices['iPhone 13'] },
    },
    {
      name: 'iPhone 13 Pro Max',
      use: { ...devices['iPhone 13 Pro Max'] },
    },
    {
      name: 'iPhone SE',
      use: { ...devices['iPhone SE'] },
    },
    {
      name: 'iPad Pro',
      use: { ...devices['iPad Pro'] },
    },
    {
      name: 'iPad Mini',
      use: { ...devices['iPad Mini'] },
    },

    // 📱 DISPOSITIVOS ANDROID
    {
      name: 'Pixel 5',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'Galaxy S21',
      use: { ...devices['Galaxy S21'] },
    },
    {
      name: 'Galaxy Tab S7',
      use: { ...devices['Galaxy Tab S7'] },
    },

    // 🖥️ DESKTOP (para comparación)
    {
      name: 'Desktop Chrome',
      use: { ...devices['Desktop Chrome'] },
    },

    // 📱 ORIENTACIONES
    {
      name: 'iPhone 13 Landscape',
      use: { 
        ...devices['iPhone 13 landscape'],
      },
    },
  ],
});