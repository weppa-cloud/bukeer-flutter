# 🎭 Configuración de Playwright para Bukeer

## 📋 Instalación Rápida

```bash
# 1. Instalar Playwright
npm init playwright@latest

# Seleccionar:
# - TypeScript
# - Carpeta tests: e2e/
# - Agregar GitHub Actions: Sí
# - Instalar navegadores: Sí
```

## 📁 Estructura Sugerida

```
bukeer-flutter/
├── e2e/                    # Tests de Playwright
│   ├── tests/
│   │   ├── auth.spec.ts
│   │   ├── itineraries.spec.ts
│   │   ├── products.spec.ts
│   │   └── contacts.spec.ts
│   ├── fixtures/
│   │   └── test-data.ts
│   ├── pages/             # Page Object Model
│   │   ├── login.page.ts
│   │   └── dashboard.page.ts
│   └── playwright.config.ts
```

## 🔧 Configuración Base

```typescript
// playwright.config.ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './e2e/tests',
  timeout: 30000,
  retries: 2,
  workers: 4,
  
  use: {
    baseURL: 'http://localhost:3000',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'on-first-retry',
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
  ],
});
```

## 🧪 Ejemplos de Tests para Bukeer

### Test de Login

```typescript
// e2e/tests/auth.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Authentication', () => {
  test('successful login to staging', async ({ page }) => {
    await page.goto('/');
    
    // Verificar que estamos en staging
    await expect(page.locator('.environment-banner')).toContainText('STAGING');
    
    // Login
    await page.fill('input[type="email"]', 'admin@staging.com');
    await page.fill('input[type="password"]', 'password123');
    await page.click('button:has-text("Ingresar")');
    
    // Verificar redirección
    await expect(page).toHaveURL(/.*dashboard|itinerarios/);
    await expect(page.locator('nav')).toContainText('Itinerarios');
  });
  
  test('login with invalid credentials', async ({ page }) => {
    await page.goto('/');
    
    await page.fill('input[type="email"]', 'invalid@test.com');
    await page.fill('input[type="password"]', 'wrongpass');
    await page.click('button:has-text("Ingresar")');
    
    // Verificar mensaje de error
    await expect(page.locator('.error-message')).toBeVisible();
  });
});
```

### Test de Itinerarios

```typescript
// e2e/tests/itineraries.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Itineraries', () => {
  test.beforeEach(async ({ page }) => {
    // Login antes de cada test
    await page.goto('/');
    await page.fill('input[type="email"]', 'admin@staging.com');
    await page.fill('input[type="password"]', 'password123');
    await page.click('button:has-text("Ingresar")');
    await page.waitForURL(/.*dashboard|itinerarios/);
  });
  
  test('create new itinerary', async ({ page }) => {
    await page.click('text=Itinerarios');
    await page.click('button:has-text("Crear Itinerario")');
    
    // Llenar formulario
    await page.fill('input[name="name"]', 'Test Itinerary Playwright');
    await page.fill('textarea[name="description"]', 'Automated test');
    
    // Fechas
    await page.click('input[name="startDate"]');
    await page.click('text=15');
    await page.click('input[name="endDate"]');
    await page.click('text=20');
    
    await page.click('button:has-text("Guardar")');
    
    // Verificar creación
    await expect(page.locator('h1')).toContainText('Test Itinerary Playwright');
  });
});
```

### Page Object Model

```typescript
// e2e/pages/login.page.ts
import { Page } from '@playwright/test';

export class LoginPage {
  constructor(private page: Page) {}
  
  async goto() {
    await this.page.goto('/');
  }
  
  async login(email: string, password: string) {
    await this.page.fill('input[type="email"]', email);
    await this.page.fill('input[type="password"]', password);
    await this.page.click('button:has-text("Ingresar")');
  }
  
  async expectError() {
    await expect(this.page.locator('.error-message')).toBeVisible();
  }
}

// Uso en tests
test('login with POM', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.goto();
  await loginPage.login('admin@staging.com', 'password123');
  await expect(page).toHaveURL(/.*dashboard/);
});
```

## 🚀 Comandos Útiles

```bash
# Ejecutar todos los tests
npx playwright test

# Ejecutar en modo UI (visual)
npx playwright test --ui

# Ejecutar un test específico
npx playwright test auth.spec.ts

# Ejecutar en modo debug
npx playwright test --debug

# Generar tests automáticamente
npx playwright codegen http://localhost:3000

# Ver último reporte
npx playwright show-report
```

## 🎥 Features Avanzadas

### 1. Capturas y Videos
```typescript
test('visual test', async ({ page }) => {
  await page.goto('/dashboard');
  await page.screenshot({ path: 'dashboard.png', fullPage: true });
});
```

### 2. API Testing
```typescript
test('api test', async ({ request }) => {
  const response = await request.get('/api/itineraries');
  expect(response.ok()).toBeTruthy();
  const data = await response.json();
  expect(data).toHaveLength(10);
});
```

### 3. Interceptar Requests
```typescript
test('mock api', async ({ page }) => {
  await page.route('**/api/itineraries', route => {
    route.fulfill({
      status: 200,
      body: JSON.stringify([{ id: 1, name: 'Mocked' }]),
    });
  });
  
  await page.goto('/itineraries');
  await expect(page.locator('text=Mocked')).toBeVisible();
});
```

## 📊 Integración con CI/CD

```yaml
# .github/workflows/playwright.yml
name: Playwright Tests
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    timeout-minutes: 60
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: actions/setup-node@v3
    - name: Install dependencies
      run: npm ci
    - name: Install Playwright Browsers
      run: npx playwright install --with-deps
    - name: Run Playwright tests
      run: npx playwright test
    - uses: actions/upload-artifact@v3
      if: always()
      with:
        name: playwright-report
        path: playwright-report/
        retention-days: 30
```

## 🔍 Debugging

### Trace Viewer
```bash
# Ejecutar con traces
npx playwright test --trace on

# Ver traces
npx playwright show-trace trace.zip
```

### Inspector
```bash
# Modo debug con pausa
npx playwright test --debug
```

## 🎯 Mejores Prácticas

1. **Usa Page Objects** para reutilizar código
2. **Evita selectores frágiles** - Usa data-testid
3. **Tests independientes** - No dependas del orden
4. **Limpia datos** después de cada test
5. **Paraleliza** para velocidad
6. **Usa fixtures** para setup común

## 📚 Recursos

- [Documentación oficial](https://playwright.dev)
- [Ejemplos](https://github.com/microsoft/playwright/tree/main/examples)
- [Best Practices](https://playwright.dev/docs/best-practices)
- [VS Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-playwright.playwright)