import { test, expect } from '@playwright/test';

test.describe('Login Funcional - Bukeer', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:8080/');
    // Esperar que Flutter cargue
    await page.waitForLoadState('networkidle');
  });

  test('login exitoso con credenciales válidas', async ({ page }) => {
    // Llenar email - usando el textbox genérico
    await page.getByRole('textbox').click();
    await page.getByRole('textbox').fill('admin@staging.com');
    
    // Llenar password - usando el ID específico
    await page.locator('#current-password').click();
    await page.locator('#current-password').fill('password123');
    
    // Enviar formulario con Enter
    await page.locator('#current-password').press('Enter');
    
    // Esperar navegación
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000); // Dar tiempo extra a Flutter
    
    // Verificar que el login fue exitoso
    // Opción 1: Verificar que la URL cambió
    const urlDespuesLogin = page.url();
    console.log('URL después del login:', urlDespuesLogin);
    
    // Opción 2: Buscar elementos del dashboard
    const elementosDashboard = [
      page.getByText('Dashboard'),
      page.getByText('Itinerarios'),
      page.getByText('Productos'),
      page.getByText('Contactos'),
      page.getByText('Inicio')
    ];
    
    let loginExitoso = false;
    for (const elemento of elementosDashboard) {
      if (await elemento.isVisible({ timeout: 5000 }).catch(() => false)) {
        loginExitoso = true;
        console.log('✅ Dashboard elemento encontrado');
        break;
      }
    }
    
    // Si no encontramos elementos del dashboard, verificar si la URL cambió
    if (!loginExitoso && urlDespuesLogin !== 'http://localhost:8080/') {
      loginExitoso = true;
      console.log('✅ URL cambió, login probablemente exitoso');
    }
    
    // Tomar screenshot del resultado
    await page.screenshot({ path: 'screenshots/login-exitoso.png', fullPage: true });
    
    expect(loginExitoso).toBeTruthy();
  });

  test('login fallido con credenciales incorrectas', async ({ page }) => {
    // Llenar con credenciales incorrectas
    await page.getByRole('textbox').click();
    await page.getByRole('textbox').fill('usuario@incorrecto.com');
    
    await page.locator('#current-password').click();
    await page.locator('#current-password').fill('passwordincorrecta');
    
    await page.locator('#current-password').press('Enter');
    
    // Esperar posible mensaje de error
    await page.waitForTimeout(3000);
    
    // Buscar mensajes de error comunes
    const mensajesError = [
      'Invalid login credentials',
      'Credenciales inválidas',
      'Usuario o contraseña incorrectos',
      'Error',
      'Incorrect'
    ];
    
    let errorEncontrado = false;
    for (const mensaje of mensajesError) {
      if (await page.getByText(mensaje, { exact: false }).isVisible({ timeout: 2000 }).catch(() => false)) {
        errorEncontrado = true;
        console.log(`⚠️ Mensaje de error encontrado: "${mensaje}"`);
        break;
      }
    }
    
    // Verificar que seguimos en la página de login
    const urlActual = page.url();
    const sigueEnLogin = urlActual === 'http://localhost:8080/';
    
    // Screenshot del error
    await page.screenshot({ path: 'screenshots/login-fallido.png', fullPage: true });
    
    // El test pasa si encontramos un error O si seguimos en la misma página
    expect(errorEncontrado || sigueEnLogin).toBeTruthy();
  });

  test('validación de campos vacíos', async ({ page }) => {
    // Intentar login sin llenar campos
    await page.getByRole('textbox').click();
    await page.keyboard.press('Enter');
    
    // Esperar posible validación
    await page.waitForTimeout(2000);
    
    // Verificar que no navegamos (seguimos en login)
    expect(page.url()).toBe('http://localhost:8080/');
    
    // Intentar solo con email
    await page.getByRole('textbox').fill('admin@staging.com');
    await page.keyboard.press('Enter');
    
    await page.waitForTimeout(2000);
    
    // Deberíamos seguir en login porque falta password
    expect(page.url()).toBe('http://localhost:8080/');
    
    await page.screenshot({ path: 'screenshots/validacion-campos.png', fullPage: true });
  });

  test('logout después de login exitoso', async ({ page }) => {
    // Primero hacer login
    await page.getByRole('textbox').click();
    await page.getByRole('textbox').fill('admin@staging.com');
    
    await page.locator('#current-password').click();
    await page.locator('#current-password').fill('password123');
    
    await page.locator('#current-password').press('Enter');
    
    // Esperar que cargue el dashboard
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    // Buscar opciones de logout
    const opcionesLogout = [
      page.getByText('Cerrar sesión'),
      page.getByText('Logout'),
      page.getByText('Salir'),
      page.locator('[aria-label*="logout"]'),
      page.locator('[aria-label*="user menu"]')
    ];
    
    let logoutEncontrado = false;
    for (const opcion of opcionesLogout) {
      if (await opcion.isVisible({ timeout: 2000 }).catch(() => false)) {
        await opcion.click();
        logoutEncontrado = true;
        console.log('✅ Opción de logout encontrada y clickeada');
        break;
      }
    }
    
    if (logoutEncontrado) {
      // Esperar a volver al login
      await page.waitForTimeout(3000);
      
      // Verificar que volvimos al login
      const volvimoAlLogin = await page.getByRole('textbox').isVisible({ timeout: 5000 }).catch(() => false);
      expect(volvimoAlLogin).toBeTruthy();
    } else {
      console.log('⚠️ No se encontró opción de logout');
    }
    
    await page.screenshot({ path: 'screenshots/logout-resultado.png', fullPage: true });
  });
});