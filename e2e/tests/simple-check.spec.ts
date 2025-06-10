import { test, expect } from '@playwright/test';

test('verificar estado de la aplicación', async ({ page }) => {
  console.log('Navegando a:', process.env.BASE_URL || 'http://localhost:8080');
  
  // Navegar con más tiempo de espera
  await page.goto('/', { 
    waitUntil: 'networkidle',
    timeout: 30000 
  });
  
  // Esperar más tiempo para Flutter
  console.log('Esperando que Flutter cargue...');
  await page.waitForTimeout(5000);
  
  // Capturar información de la página
  const title = await page.title();
  console.log('Título de la página:', title);
  
  const url = page.url();
  console.log('URL actual:', url);
  
  // Verificar si hay algún error en la consola
  page.on('console', msg => {
    console.log('Console:', msg.type(), msg.text());
  });
  
  // Buscar cualquier texto visible
  const bodyText = await page.locator('body').innerText();
  console.log('Texto visible en la página:', bodyText);
  
  // Buscar elementos específicos de Flutter o Bukeer
  const flutterElements = [
    'flt-scene',
    'flt-semantics',
    'flutter-view',
    '.flutter-view'
  ];
  
  for (const selector of flutterElements) {
    const elements = await page.locator(selector).count();
    if (elements > 0) {
      console.log(`Encontrados ${elements} elementos con selector: ${selector}`);
    }
  }
  
  // Buscar por texto común en login
  const loginTexts = [
    'Login',
    'Ingresar', 
    'Iniciar sesión',
    'Email',
    'Correo',
    'Usuario',
    'Contraseña',
    'Password'
  ];
  
  for (const text of loginTexts) {
    const found = await page.getByText(text, { exact: false }).count();
    if (found > 0) {
      console.log(`Texto encontrado: "${text}" (${found} veces)`);
    }
  }
  
  // Tomar múltiples screenshots con diferentes tiempos de espera
  await page.screenshot({ path: 'screenshots/check-5s.png', fullPage: true });
  
  await page.waitForTimeout(5000);
  await page.screenshot({ path: 'screenshots/check-10s.png', fullPage: true });
  
  // Intentar interactuar con el primer input visible
  const firstInput = page.locator('input').first();
  if (await firstInput.isVisible({ timeout: 1000 })) {
    console.log('Input visible encontrado!');
    await firstInput.click();
    await firstInput.fill('test@example.com');
    await page.screenshot({ path: 'screenshots/check-after-input.png', fullPage: true });
  } else {
    console.log('No se encontró ningún input visible');
  }
  
  // Verificar si la app está en un estado de error
  const errorIndicators = [
    'error',
    'Error',
    'failed',
    'Failed',
    'exception',
    'Exception'
  ];
  
  for (const errorText of errorIndicators) {
    const errors = await page.getByText(errorText, { exact: false }).count();
    if (errors > 0) {
      console.log(`⚠️  Posible error encontrado: "${errorText}"`);
    }
  }
});