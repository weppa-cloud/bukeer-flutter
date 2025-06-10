import { test, expect } from '@playwright/test';

test.describe('Login Simple - Bukeer', () => {
  test('login básico', async ({ page }) => {
    // Navegar a la página
    await page.goto('/', { waitUntil: 'networkidle' });
    
    // Esperar que Flutter cargue
    await page.waitForTimeout(5000);
    
    // Encontrar y llenar el primer input (email)
    const emailInput = page.locator('input').first();
    await emailInput.waitFor({ state: 'visible' });
    await emailInput.click();
    await emailInput.fill('admin@staging.com');
    
    // Presionar Tab para ir al siguiente campo
    await page.keyboard.press('Tab');
    
    // Llenar el password (debería ser el campo activo después del Tab)
    await page.keyboard.type('password123');
    
    // Tomar screenshot antes de enviar
    await page.screenshot({ path: 'screenshots/before-login-submit.png', fullPage: true });
    
    // Presionar Enter para enviar el formulario
    await page.keyboard.press('Enter');
    
    // Esperar navegación o cambios en la página
    await page.waitForTimeout(5000);
    
    // Tomar screenshot después del intento de login
    await page.screenshot({ path: 'screenshots/after-login-attempt.png', fullPage: true });
    
    // Verificar si hubo navegación
    const currentUrl = page.url();
    console.log('URL después del login:', currentUrl);
    
    // Buscar indicadores de éxito
    const successIndicators = [
      'Dashboard',
      'Inicio',
      'Itinerarios',
      'Productos',
      'Contactos',
      'Bienvenido',
      'Welcome'
    ];
    
    let loginSuccess = false;
    for (const indicator of successIndicators) {
      const found = await page.getByText(indicator, { exact: false }).count();
      if (found > 0) {
        console.log(`✅ Indicador de éxito encontrado: "${indicator}"`);
        loginSuccess = true;
      }
    }
    
    // También verificar si la URL cambió
    if (currentUrl !== 'http://localhost:8080/') {
      console.log('✅ La URL cambió, posible login exitoso');
      loginSuccess = true;
    }
    
    expect(loginSuccess).toBeTruthy();
  });

  test('login con clicks directos', async ({ page }) => {
    // Navegar
    await page.goto('/', { waitUntil: 'networkidle' });
    await page.waitForTimeout(5000);
    
    // Método alternativo: buscar todos los inputs y llenarlos por índice
    const inputs = await page.locator('input').all();
    console.log(`Encontrados ${inputs.length} inputs`);
    
    if (inputs.length >= 2) {
      // Primer input - email
      await inputs[0].click();
      await inputs[0].fill('admin@staging.com');
      
      // Segundo input - password
      await inputs[1].click();
      await inputs[1].fill('password123');
      
      // Buscar y hacer click en cualquier botón
      const buttons = await page.locator('button').all();
      console.log(`Encontrados ${buttons.length} botones`);
      
      if (buttons.length > 0) {
        await buttons[0].click();
      } else {
        // Si no hay botones, presionar Enter en el último input
        await inputs[1].press('Enter');
      }
    }
    
    // Esperar resultado
    await page.waitForTimeout(5000);
    await page.screenshot({ path: 'screenshots/login-method2-result.png', fullPage: true });
    
    // Verificar URL
    const finalUrl = page.url();
    console.log('URL final:', finalUrl);
    
    // El test pasa si la URL cambió
    expect(finalUrl).not.toBe('http://localhost:8080/');
  });
});