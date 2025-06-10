# 🌐 Guía de Testing Manual para Web

Como Maestro no soporta nativamente testing web, aquí está la guía para probar manualmente en el navegador:

## 🚀 Pasos para Testing Web

### 1. Verificar que la app está corriendo en staging

La app ya está corriendo en: http://localhost:59931

Deberías ver:
- Banner naranja que dice "STAGING ENVIRONMENT"
- Página de login

### 2. Test Manual de Login

#### Pasos:
1. **Abrir navegador**: http://localhost:59931
2. **En el campo Email**: Escribir `admin@staging.com`
3. **En el campo Password**: Escribir `password123`
4. **Click en**: Botón "Ingresar"

#### Resultado esperado:
- ✅ Deberías ver el Dashboard o página principal
- ✅ El banner naranja de staging debe seguir visible
- ✅ Deberías ver opciones como: Itinerarios, Productos, Contactos

### 3. Test de Navegación

Una vez logueado, verifica:

1. **Click en "Itinerarios"**
   - Debe mostrar lista de itinerarios
   - Botón para crear nuevo

2. **Click en "Productos"**
   - Lista de productos
   - Opciones de filtro

3. **Click en "Contactos"**
   - Lista de contactos
   - Buscador

4. **Click en "Perfil"** (o ícono de usuario)
   - Información del usuario
   - Opción de cerrar sesión

### 4. Test de Creación (Ejemplo: Contacto)

1. Ir a **Contactos**
2. Click en **"Crear Contacto"** o **"+"**
3. Llenar:
   - Nombre: `Test Contact Web`
   - Email: `test@maestro.com`
   - Teléfono: `+1234567890`
4. Click en **Guardar**
5. Verificar que aparece en la lista

## 🛠️ Alternativas para Automatización Web

### Opción 1: Usar Playwright (Recomendado para Web)

```bash
# Instalar Playwright
npm init playwright@latest

# Crear test
cat > tests/login.spec.js << 'EOF'
const { test, expect } = require('@playwright/test');

test('login to staging', async ({ page }) => {
  await page.goto('http://localhost:59931');
  await page.fill('input[type="email"]', 'admin@staging.com');
  await page.fill('input[type="password"]', 'password123');
  await page.click('button:has-text("Ingresar")');
  await expect(page).toHaveURL(/.*dashboard|home|itinerarios/);
});
EOF

# Ejecutar
npx playwright test
```

### Opción 2: Usar Selenium

```javascript
const { Builder, By, until } = require('selenium-webdriver');

async function testLogin() {
  let driver = await new Builder().forBrowser('chrome').build();
  try {
    await driver.get('http://localhost:59931');
    await driver.findElement(By.css('input[type="email"]')).sendKeys('admin@staging.com');
    await driver.findElement(By.css('input[type="password"]')).sendKeys('password123');
    await driver.findElement(By.xpath('//button[contains(text(), "Ingresar")]')).click();
    await driver.wait(until.urlContains('dashboard'), 10000);
  } finally {
    await driver.quit();
  }
}
```

## 📸 Capturas de Pantalla Manuales

Para documentar los tests:

1. **macOS**: `Cmd + Shift + 4`
2. **Windows**: `Win + Shift + S`
3. **Chrome DevTools**: `Cmd/Ctrl + Shift + P` → "Capture screenshot"

## 🔍 Debugging en Chrome

1. Abrir **DevTools**: `F12` o `Cmd + Option + I`
2. **Console**: Ver errores
3. **Network**: Verificar llamadas a API
4. **Application**: Ver localStorage/sessionStorage

## 📊 Checklist de Testing Manual

- [ ] Login exitoso
- [ ] Login con credenciales incorrectas muestra error
- [ ] Navegación entre secciones funciona
- [ ] Crear nuevo itinerario
- [ ] Agregar producto a itinerario
- [ ] Crear nuevo contacto
- [ ] Buscar contactos
- [ ] Agregar pago
- [ ] Cerrar sesión

## 🚨 Verificaciones Importantes

1. **URL de API**: En Network, verificar que las llamadas van a `wrgkiastpqituocblopg.supabase.co`
2. **Banner Staging**: Siempre visible (naranja)
3. **Sin errores en consola**: Revisar Console de DevTools

---

**Nota**: Para automatización real en web, considera migrar a Playwright o Cypress que están diseñados específicamente para testing web.