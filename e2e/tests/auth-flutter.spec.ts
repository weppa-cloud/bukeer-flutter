import { test, expect } from '@playwright/test';

test.describe('Autenticación Flutter - Bukeer', () => {
  test.beforeEach(async ({ page }) => {
    // Ir a la página de login
    await page.goto('/');
    
    // Esperar a que Flutter cargue completamente
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000); // Flutter puede necesitar tiempo extra para renderizar
  });

  test('login exitoso con selectores de Flutter', async ({ page }) => {
    // Los campos en Flutter se renderizan como divs con contenteditable o inputs dentro de divs
    // Buscar por texto del label o placeholder
    
    // Opción 1: Buscar por texto "Email" y luego el input cercano
    const emailLabel = page.getByText('Email', { exact: false });
    const emailInput = page.locator('input').near(emailLabel).first();
    
    // Si no funciona, intentar con selectores más generales
    if (!(await emailInput.isVisible({ timeout: 2000 }))) {
      // Buscar todos los inputs y usar el primero (email suele ser primero)
      const allInputs = page.locator('input[type="text"], input[type="email"], input:not([type="password"])');
      const firstInput = allInputs.first();
      await firstInput.fill('admin@staging.com');
    } else {
      await emailInput.fill('admin@staging.com');
    }
    
    // Para password, buscar por tipo o por texto "Contraseña"
    const passwordLabel = page.getByText('Contraseña', { exact: false });
    const passwordInput = page.locator('input[type="password"]').or(page.locator('input').near(passwordLabel)).first();
    
    if (await passwordInput.isVisible()) {
      await passwordInput.fill('password123');
    } else {
      // Buscar el segundo input si no encontramos por tipo password
      const allInputs = await page.locator('input').all();
      if (allInputs.length >= 2) {
        await allInputs[1].fill('password123');
      }
    }
    
    // Buscar botón por texto "Iniciar sesión" o "Ingresar"
    const loginButton = page.getByRole('button', { name: /iniciar sesión|ingresar/i })
      .or(page.getByText('Iniciar sesión', { exact: false }))
      .or(page.getByText('Ingresar', { exact: false }));
    
    // Hacer click en el botón
    await loginButton.click();
    
    // Esperar navegación
    await Promise.race([
      page.waitForURL(/.*(?:home|dashboard|itinerarios)/, { timeout: 15000 }).catch(() => {}),
      page.waitForSelector('text=/inicio|dashboard|itinerarios/i', { timeout: 15000 }).catch(() => {})
    ]);
    
    // Tomar screenshot del resultado
    await page.screenshot({ path: 'screenshots/flutter-login-success.png', fullPage: true });
    
    // Verificar que estamos logueados buscando elementos del dashboard
    const dashboardElements = [
      page.getByText('Itinerarios', { exact: false }),
      page.getByText('Productos', { exact: false }),
      page.getByText('Contactos', { exact: false }),
      page.getByText('Dashboard', { exact: false }),
      page.getByText('Inicio', { exact: false })
    ];
    
    let foundDashboard = false;
    for (const element of dashboardElements) {
      if (await element.isVisible({ timeout: 2000 })) {
        foundDashboard = true;
        break;
      }
    }
    
    expect(foundDashboard).toBeTruthy();
  });

  test('login con enfoque en widgets Flutter', async ({ page }) => {
    // Flutter renderiza inputs de forma especial, intentemos diferentes enfoques
    
    // Método 1: Click en el área donde debería estar el campo y escribir
    await page.click('text=Email', { position: { x: 100, y: 10 } });
    await page.keyboard.type('admin@staging.com');
    
    // Tab para ir al siguiente campo
    await page.keyboard.press('Tab');
    await page.keyboard.type('password123');
    
    // Buscar y clickear el botón
    await page.click('text=/iniciar sesión|ingresar/i');
    
    // Esperar resultado
    await page.waitForTimeout(5000);
    await page.screenshot({ path: 'screenshots/flutter-login-method2.png', fullPage: true });
  });

  test('debug - analizar estructura de la página', async ({ page }) => {
    // Tomar screenshot inicial
    await page.screenshot({ path: 'screenshots/flutter-page-initial.png', fullPage: true });
    
    // Buscar todos los elementos interactivos
    const inputs = await page.locator('input').all();
    const buttons = await page.locator('button').all();
    const clickableTexts = await page.locator('text=/iniciar|ingresar|login|email|contraseña/i').all();
    
    console.log(`Inputs encontrados: ${inputs.length}`);
    console.log(`Botones encontrados: ${buttons.length}`);
    console.log(`Textos clickeables encontrados: ${clickableTexts.length}`);
    
    // Intentar encontrar el formulario por estructura
    const forms = await page.locator('form').all();
    console.log(`Formularios encontrados: ${forms.length}`);
    
    // Buscar por atributos de Flutter
    const flutterWidgets = await page.locator('[class*="flutter"], [class*="flt"]').all();
    console.log(`Widgets Flutter encontrados: ${flutterWidgets.length}`);
    
    // Imprimir toda la estructura HTML para debug
    const bodyHTML = await page.locator('body').innerHTML();
    console.log('Primeros 1000 caracteres del HTML:', bodyHTML.substring(0, 1000));
  });
});