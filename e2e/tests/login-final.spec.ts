import { test, expect } from '@playwright/test';

test.describe('Login Final - Bukeer', () => {
  test('login exitoso - flujo completo', async ({ page }) => {
    // Navegar a la página
    await page.goto('http://localhost:8080/');
    await page.waitForLoadState('networkidle');
    
    // Llenar email
    await page.getByRole('textbox').click();
    await page.getByRole('textbox').fill('admin@staging.com');
    
    // IMPORTANTE: Después de llenar el email, puede ser necesario:
    // 1. Presionar Tab
    // 2. Presionar Enter
    // 3. Click en algún lugar para que aparezca el campo de password
    
    // Opción 1: Presionar Tab para ir al siguiente campo
    await page.keyboard.press('Tab');
    await page.waitForTimeout(1000);
    
    // Esperar a que el campo de password aparezca
    await page.waitForSelector('#current-password', { 
      state: 'visible',
      timeout: 10000 
    });
    
    // Ahora llenar el password
    await page.locator('#current-password').click();
    await page.locator('#current-password').fill('password123');
    
    // Enviar el formulario
    await page.locator('#current-password').press('Enter');
    
    // Esperar navegación o cambio de página
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    // Tomar screenshot del resultado
    await page.screenshot({ path: 'screenshots/login-final-resultado.png', fullPage: true });
    
    // Verificar éxito
    const urlFinal = page.url();
    console.log('URL final:', urlFinal);
    
    // El test pasa si la URL cambió o si encontramos elementos del dashboard
    const cambioUrl = urlFinal !== 'http://localhost:8080/';
    const tieneElementosDashboard = await page.getByText(/dashboard|itinerarios|productos|inicio/i).isVisible({ timeout: 5000 }).catch(() => false);
    
    expect(cambioUrl || tieneElementosDashboard).toBeTruthy();
  });

  test('login alternativo - sin esperar password', async ({ page }) => {
    // Este test asume que el password podría estar oculto pero presente
    await page.goto('http://localhost:8080/');
    await page.waitForLoadState('networkidle');
    
    // Llenar email
    await page.getByRole('textbox').click();
    await page.getByRole('textbox').fill('admin@staging.com');
    
    // Intentar llenar el password aunque no sea visible
    // A veces Flutter oculta elementos pero siguen siendo accesibles
    try {
      await page.locator('#current-password').fill('password123', { 
        force: true // Forzar la acción aunque el elemento no sea visible
      });
      console.log('✅ Password llenado con force');
    } catch (e) {
      console.log('❌ No se pudo llenar password con force');
    }
    
    // Intentar submit de varias formas
    // Opción 1: Enter en el campo actual
    await page.keyboard.press('Enter');
    await page.waitForTimeout(2000);
    
    // Si no funcionó, intentar Tab + llenar password + Enter
    const urlDespuesEnter = page.url();
    if (urlDespuesEnter === 'http://localhost:8080/') {
      console.log('Intentando con Tab...');
      await page.keyboard.press('Tab');
      await page.keyboard.type('password123');
      await page.keyboard.press('Enter');
    }
    
    await page.waitForTimeout(3000);
    await page.screenshot({ path: 'screenshots/login-alternativo.png', fullPage: true });
    
    const urlFinal = page.url();
    console.log('URL final método alternativo:', urlFinal);
    
    expect(urlFinal).not.toBe('http://localhost:8080/');
  });

  test('debug - analizar flujo de login', async ({ page }) => {
    await page.goto('http://localhost:8080/');
    await page.waitForLoadState('networkidle');
    
    console.log('=== ESTADO INICIAL ===');
    const inputsInicial = await page.locator('input').count();
    console.log('Inputs visibles al inicio:', inputsInicial);
    
    // Llenar email
    await page.getByRole('textbox').click();
    await page.getByRole('textbox').fill('admin@staging.com');
    
    console.log('\n=== DESPUÉS DE LLENAR EMAIL ===');
    
    // Probar diferentes acciones para revelar el password
    const acciones = [
      { nombre: 'Tab', accion: () => page.keyboard.press('Tab') },
      { nombre: 'Enter', accion: () => page.keyboard.press('Enter') },
      { nombre: 'Click fuera', accion: () => page.locator('body').click() },
      { nombre: 'Blur', accion: () => page.evaluate(() => document.activeElement?.blur()) }
    ];
    
    for (const { nombre, accion } of acciones) {
      console.log(`\nProbando: ${nombre}`);
      await accion();
      await page.waitForTimeout(1000);
      
      // Verificar si apareció el campo de password
      const passwordVisible = await page.locator('#current-password').isVisible().catch(() => false);
      const inputsActual = await page.locator('input').count();
      
      console.log(`- Password visible: ${passwordVisible}`);
      console.log(`- Total inputs: ${inputsActual}`);
      
      if (passwordVisible) {
        console.log(`✅ ¡El campo de password apareció con: ${nombre}!`);
        break;
      }
    }
    
    await page.screenshot({ path: 'screenshots/debug-flujo-login.png', fullPage: true });
  });
});