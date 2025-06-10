import { test, expect } from '@playwright/test';

test.describe('Login en Staging - Bukeer', () => {
  test('verificar página de login staging', async ({ page }) => {
    // Navegar a la URL de staging
    await page.goto(process.env.BASE_URL || 'http://localhost:63831');
    
    // Esperar que cargue completamente
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(5000); // Flutter necesita tiempo extra
    
    // Tomar screenshot inicial
    await page.screenshot({ path: 'screenshots/staging-inicial.png', fullPage: true });
    
    // Verificar título
    const title = await page.title();
    console.log('Título de la página:', title);
    
    // Buscar elementos de la página
    const elementos = {
      inputs: await page.locator('input').count(),
      textboxes: await page.getByRole('textbox').count(),
      buttons: await page.locator('button').count(),
      forms: await page.locator('form').count()
    };
    
    console.log('Elementos encontrados:', elementos);
    
    // Buscar texto relacionado con login
    const textosLogin = ['Email', 'Correo', 'Usuario', 'Login', 'Iniciar', 'Ingresar'];
    for (const texto of textosLogin) {
      const encontrado = await page.getByText(texto, { exact: false }).count();
      if (encontrado > 0) {
        console.log(`✅ Texto encontrado: "${texto}"`);
      }
    }
    
    // Verificar que estamos en staging
    const urlActual = page.url();
    console.log('URL actual:', urlActual);
    expect(urlActual).toContain('localhost');
  });

  test('login staging con selectores correctos', async ({ page }) => {
    await page.goto(process.env.BASE_URL || 'http://localhost:63831');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(5000);
    
    try {
      // Paso 1: Llenar email (primer textbox)
      console.log('Llenando email...');
      await page.getByRole('textbox').click();
      await page.getByRole('textbox').fill('admin@staging.com');
      
      // Paso 2: Presionar Tab para revelar password
      console.log('Presionando Tab...');
      await page.keyboard.press('Tab');
      await page.waitForTimeout(1000);
      
      // Paso 3: Esperar que aparezca el campo de password
      console.log('Esperando campo de password...');
      await page.waitForSelector('#current-password', { 
        state: 'visible',
        timeout: 5000 
      });
      
      // Paso 4: Llenar password
      console.log('Llenando password...');
      await page.locator('#current-password').fill('password123');
      
      // Paso 5: Submit
      console.log('Enviando formulario...');
      await page.locator('#current-password').press('Enter');
      
      // Esperar resultado
      await page.waitForLoadState('networkidle');
      await page.waitForTimeout(5000);
      
      // Tomar screenshot final
      await page.screenshot({ path: 'screenshots/staging-login-resultado.png', fullPage: true });
      
      // Verificar resultado
      const urlFinal = page.url();
      console.log('URL final:', urlFinal);
      
      // Buscar indicadores de éxito
      const elementosDashboard = await page.getByText(/dashboard|itinerarios|productos|inicio/i).count();
      console.log('Elementos de dashboard encontrados:', elementosDashboard);
      
      // El test pasa si la URL cambió o encontramos elementos del dashboard
      const loginExitoso = urlFinal !== (process.env.BASE_URL || 'http://localhost:63831') || elementosDashboard > 0;
      expect(loginExitoso).toBeTruthy();
      
    } catch (error) {
      console.error('Error durante el login:', error);
      await page.screenshot({ path: 'screenshots/staging-login-error.png', fullPage: true });
      throw error;
    }
  });
});