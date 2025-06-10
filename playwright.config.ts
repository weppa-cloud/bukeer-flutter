import { defineConfig, devices } from '@playwright/test';
import * as dotenv from 'dotenv';

// Cargar variables de entorno
dotenv.config({ path: '.env.playwright' });

export default defineConfig({
  testDir: './e2e/tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html', { open: 'never' }],
    ['list'],
  ],

  use: {
    // URL base para Bukeer staging
    baseURL: process.env.BASE_URL || 'http://localhost:8080',
    
    // 🎥 GRABACIÓN DE VIDEOS
    video: {
      mode: 'retain-on-failure',  // Solo guardar videos cuando falla
      size: { width: 1280, height: 720 }  // Tamaño del video
    },
    
    // 📸 SCREENSHOTS
    screenshot: {
      mode: 'only-on-failure',  // Solo cuando falla
      fullPage: true            // Página completa
    },
    
    // 🔍 TRACE (mejor que video)
    trace: 'on-first-retry',    // Trace en reintentos
    
    // Configuración general
    actionTimeout: 10000,
    navigationTimeout: 30000,
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'iPhone 13',
      use: { ...devices['iPhone 13'] },
    },
  ],

  // No necesitamos webServer ya que Flutter ya está corriendo
  // webServer: {
  //   command: 'flutter run -d chrome --dart-define=ENVIRONMENT=staging',
  //   port: 59931,
  //   reuseExistingServer: true,
  // },
});