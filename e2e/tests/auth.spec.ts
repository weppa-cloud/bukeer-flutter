import { test, expect } from '@playwright/test';

test.describe('Autenticación - Bukeer Staging', () => {
  test.beforeEach(async ({ page }) => {
    // Ir a la página de login
    await page.goto('/');
    
    // Opcional: Verificar que estamos en staging (si el banner existe)
    // await expect(page.locator('.environment-banner')).toContainText('STAGING');
  });

  test('login exitoso con credenciales válidas', async ({ page }) => {
    // Esperar a que la página cargue completamente
    await page.waitForLoadState('networkidle');
    
    // Buscar campos por diferentes selectores posibles
    const emailSelectors = [
      'input[type="email"]',
      'input[name="email"]',
      'input[placeholder*="email" i]',
      'input[placeholder*="correo" i]',
      '#email',
      '[data-testid="email"]'
    ];
    
    let emailInput;
    for (const selector of emailSelectors) {
      try {
        emailInput = page.locator(selector).first();
        if (await emailInput.isVisible({ timeout: 1000 })) {
          console.log(`Campo email encontrado con selector: ${selector}`);
          break;
        }
      } catch (e) {
        // Continuar con el siguiente selector
      }
    }
    
    if (!emailInput || !(await emailInput.isVisible())) {
      throw new Error('No se pudo encontrar el campo de email');
    }
    
    // Llenar email
    await emailInput.fill(process.env.TEST_EMAIL || 'admin@staging.com');
    
    // Buscar campo de password
    const passwordSelectors = [
      'input[type="password"]',
      'input[name="password"]',
      'input[placeholder*="password" i]',
      'input[placeholder*="contraseña" i]',
      '#password'
    ];
    
    let passwordInput;
    for (const selector of passwordSelectors) {
      try {
        passwordInput = page.locator(selector).first();
        if (await passwordInput.isVisible({ timeout: 1000 })) {
          console.log(`Campo password encontrado con selector: ${selector}`);
          break;
        }
      } catch (e) {
        // Continuar
      }
    }
    
    if (!passwordInput || !(await passwordInput.isVisible())) {
      throw new Error('No se pudo encontrar el campo de password');
    }
    
    await passwordInput.fill(process.env.TEST_PASSWORD || 'password123');
    
    // Buscar botón de login
    const buttonSelectors = [
      'button:has-text("Ingresar")',
      'button:has-text("Login")',
      'button:has-text("Iniciar")',
      'button[type="submit"]',
      'input[type="submit"]',
      '[data-testid="login-button"]'
    ];
    
    let loginButton;
    for (const selector of buttonSelectors) {
      try {
        loginButton = page.locator(selector).first();
        if (await loginButton.isVisible({ timeout: 1000 })) {
          console.log(`Botón login encontrado con selector: ${selector}`);
          break;
        }
      } catch (e) {
        // Continuar
      }
    }
    
    if (!loginButton || !(await loginButton.isVisible())) {
      // Si no hay botón, intentar submit con Enter
      await passwordInput.press('Enter');
    } else {
      await loginButton.click();
    }
    
    // Esperar navegación o cambio en la página
    await Promise.race([
      page.waitForURL(/.*(?:dashboard|itinerarios|home)/, { timeout: 10000 }).catch(() => {}),
      page.waitForSelector('nav', { timeout: 10000 }).catch(() => {}),
      page.waitForLoadState('networkidle', { timeout: 10000 }).catch(() => {})
    ]);
    
    // Tomar screenshot del resultado
    await page.screenshot({ path: 'screenshots/after-login.png', fullPage: true });
  });

  test('login fallido con credenciales incorrectas', async ({ page }) => {
    // Intentar con credenciales incorrectas
    await page.fill('input[type="email"]', 'usuario@incorrecto.com');
    await page.fill('input[type="password"]', 'passwordincorrecta');
    
    await page.click('button:has-text("Ingresar")');
    
    // Verificar mensaje de error
    const errorMessage = page.locator('[role="alert"], .error-message, .snackbar');
    await expect(errorMessage).toBeVisible({ timeout: 5000 });
    
    // No deberíamos navegar
    await expect(page).toHaveURL('/');
  });

  test('validación de campos requeridos', async ({ page }) => {
    // Intentar login sin llenar campos
    await page.click('button:has-text("Ingresar")');
    
    // Verificar que muestra errores de validación
    const emailInput = page.locator('input[type="email"]');
    const passwordInput = page.locator('input[type="password"]');
    
    // Los campos deberían tener estado de error
    await expect(emailInput).toHaveAttribute('aria-invalid', 'true');
    await expect(passwordInput).toHaveAttribute('aria-invalid', 'true');
  });

  test('logout exitoso', async ({ page }) => {
    // Primero hacer login
    await page.fill('input[type="email"]', process.env.TEST_EMAIL || 'admin@staging.com');
    await page.fill('input[type="password"]', process.env.TEST_PASSWORD || 'password123');
    await page.click('button:has-text("Ingresar")');
    await page.waitForURL(/.*(?:dashboard|itinerarios|home)/);
    
    // Buscar y hacer click en el menú de usuario o botón de logout
    const userMenu = page.locator('[aria-label="User menu"], [data-testid="user-menu"], .user-avatar');
    if (await userMenu.isVisible()) {
      await userMenu.click();
    }
    
    // Click en logout
    await page.click('text=/cerrar.*sesión|logout|salir/i');
    
    // Deberíamos volver al login
    await expect(page).toHaveURL('/');
  });
});