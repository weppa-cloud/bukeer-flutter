import { test, expect } from '@playwright/test';

test.describe('Bukeer Login Demo - Con Video', () => {
  test('login exitoso - este test será grabado en video', async ({ page }) => {
    // Ir a la página
    await page.goto('/');
    
    // Tomar screenshot inicial
    await page.screenshot({ path: 'screenshots/login-page.png' });
    
    // Verificar que estamos en staging
    await expect(page.locator('.environment-banner')).toContainText('STAGING');
    
    // Llenar credenciales
    await page.fill('input[type="email"]', 'admin@staging.com');
    await page.fill('input[type="password"]', 'password123');
    
    // Click en login
    await page.click('button:has-text("Ingresar")');
    
    // Esperar navegación
    await page.waitForURL(/.*dashboard|itinerarios/);
    
    // Verificar que estamos logueados
    await expect(page.locator('nav')).toBeVisible();
    
    // Tomar screenshot final
    await page.screenshot({ path: 'screenshots/dashboard.png' });
  });

  test('login fallido - también grabado en video', async ({ page }) => {
    await page.goto('/');
    
    // Credenciales incorrectas
    await page.fill('input[type="email"]', 'wrong@email.com');
    await page.fill('input[type="password"]', 'wrongpass');
    await page.click('button:has-text("Ingresar")');
    
    // Este test fallará y guardará el video
    await expect(page.locator('.error-message')).toBeVisible();
  });
});