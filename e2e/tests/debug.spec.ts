import { test, expect } from '@playwright/test';

test('debug - ver qué hay en la página', async ({ page }) => {
  // Ir a la página
  await page.goto('/');
  
  // Esperar un poco para que cargue
  await page.waitForTimeout(2000);
  
  // Tomar screenshot completo
  await page.screenshot({ path: 'debug-full-page.png', fullPage: true });
  
  // Imprimir el título
  console.log('Título:', await page.title());
  
  // Buscar todos los inputs
  const inputs = await page.locator('input').all();
  console.log('Número de inputs encontrados:', inputs.length);
  
  // Buscar formularios
  const forms = await page.locator('form').all();
  console.log('Número de formularios:', forms.length);
  
  // Buscar botones
  const buttons = await page.locator('button').all();
  console.log('Número de botones:', buttons.length);
  
  // Imprimir algo del contenido
  const bodyText = await page.locator('body').innerText();
  console.log('Primeros 500 caracteres del body:', bodyText.substring(0, 500));
});