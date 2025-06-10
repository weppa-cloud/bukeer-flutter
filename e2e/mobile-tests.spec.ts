import { test, expect, devices } from '@playwright/test';

test.describe('Bukeer Mobile Tests', () => {
  // Test específico para iPhone
  test.use({ ...devices['iPhone 13'] });

  test('mobile login flow', async ({ page }) => {
    await page.goto('/');
    
    // Verificar viewport móvil
    const viewport = page.viewportSize();
    expect(viewport?.width).toBeLessThan(500);
    
    // El login debería ser responsive
    await page.fill('input[type="email"]', 'admin@staging.com');
    await page.fill('input[type="password"]', 'password123');
    
    // En móvil el botón puede ser de ancho completo
    await page.click('button:has-text("Ingresar")');
    
    // Verificar navegación móvil (hamburger menu)
    await expect(page.locator('[data-testid="mobile-menu"]')).toBeVisible();
  });

  test('mobile navigation menu', async ({ page }) => {
    await page.goto('/');
    // Login primero
    await page.fill('input[type="email"]', 'admin@staging.com');
    await page.fill('input[type="password"]', 'password123');
    await page.click('button:has-text("Ingresar")');
    
    // En móvil debería haber menú hamburguesa
    await page.click('[data-testid="mobile-menu-toggle"]');
    
    // Verificar opciones del menú
    await expect(page.locator('text=Itinerarios')).toBeVisible();
    await expect(page.locator('text=Productos')).toBeVisible();
    await expect(page.locator('text=Contactos')).toBeVisible();
  });

  test('responsive forms on mobile', async ({ page }) => {
    await page.goto('/');
    // Login
    await page.fill('input[type="email"]', 'admin@staging.com');
    await page.fill('input[type="password"]', 'password123');
    await page.click('button:has-text("Ingresar")');
    
    // Navegar a crear contacto
    await page.click('[data-testid="mobile-menu-toggle"]');
    await page.click('text=Contactos');
    await page.click('button:has-text("Crear")');
    
    // Los campos deberían ser de ancho completo en móvil
    const input = page.locator('input[name="name"]');
    const inputBox = await input.boundingBox();
    const pageWidth = (await page.viewportSize())?.width || 0;
    
    // El input debería ocupar casi todo el ancho
    expect(inputBox?.width).toBeGreaterThan(pageWidth * 0.8);
  });
});

// Tests para diferentes dispositivos
test.describe('Multi-device testing', () => {
  const mobileDevices = [
    'iPhone 13',
    'iPhone SE',
    'Pixel 5',
    'Galaxy S21'
  ];

  for (const deviceName of mobileDevices) {
    test(`Login on ${deviceName}`, async ({ browser }) => {
      // Crear contexto con emulación del dispositivo
      const context = await browser.newContext({
        ...devices[deviceName],
        // Agregar permisos si necesitas
        permissions: ['geolocation'],
        geolocation: { latitude: 40.7128, longitude: -74.0060 },
      });
      
      const page = await context.newPage();
      await page.goto('/');
      
      // Tomar screenshot del dispositivo
      await page.screenshot({ 
        path: `screenshots/login-${deviceName.replace(' ', '-')}.png`,
        fullPage: true 
      });
      
      // Hacer el test
      await page.fill('input[type="email"]', 'admin@staging.com');
      await page.fill('input[type="password"]', 'password123');
      await page.click('button:has-text("Ingresar")');
      
      // Verificar que funciona en este dispositivo
      await expect(page).toHaveURL(/.*dashboard|itinerarios/);
      
      await context.close();
    });
  }
});

// Test de orientación
test.describe('Orientation tests', () => {
  test('rotate from portrait to landscape', async ({ browser }) => {
    // Empezar en portrait
    const context = await browser.newContext({
      ...devices['iPhone 13'],
    });
    
    const page = await context.newPage();
    await page.goto('/');
    
    // Screenshot en portrait
    await page.screenshot({ path: 'screenshots/portrait.png' });
    
    // Rotar a landscape
    await context.setViewportSize({ width: 844, height: 390 });
    
    // Screenshot en landscape
    await page.screenshot({ path: 'screenshots/landscape.png' });
    
    // Verificar que el layout se adapta
    await expect(page.locator('.main-content')).toBeVisible();
    
    await context.close();
  });
});

// Test de gestos táctiles
test.describe('Touch gestures', () => {
  test.use({ ...devices['iPhone 13'], hasTouch: true });

  test('swipe navigation', async ({ page }) => {
    await page.goto('/dashboard');
    
    // Simular swipe
    await page.locator('.swipeable-list').swipe('left');
    
    // Verificar que apareció el botón de eliminar
    await expect(page.locator('.delete-action')).toBeVisible();
  });

  test('pinch to zoom', async ({ page }) => {
    await page.goto('/itinerary/123/map');
    
    // Simular pinch zoom
    await page.locator('.map-container').pinch({
      scale: 2,
      position: { x: 200, y: 200 }
    });
  });
});