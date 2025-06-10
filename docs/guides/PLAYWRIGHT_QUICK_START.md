# 🎭 Playwright - Guía Rápida para Bukeer

## ✅ Estado de Configuración

- **Playwright instalado** ✅
- **Configuración lista** ✅
- **Credenciales configuradas** ✅
- **Test de login creado** ✅
- **Flutter app corriendo en**: http://localhost:59931

## 🚀 Ejecutar Tests

### 1. Test Básico
```bash
npm run pw:test
```

### 2. Test con UI Visual (Recomendado)
```bash
npm run pw:test:ui
```
Esto abre una interfaz donde puedes:
- Ver tests ejecutándose en tiempo real
- Pausar y debuggear
- Ver logs y errores

### 3. Test con Navegador Visible
```bash
npm run pw:test:headed
```

### 4. Test Solo Chrome
```bash
npm run pw:test:chrome
```

### 5. Test Mobile
```bash
npm run pw:test:mobile
```

## 🎥 Ver Resultados

### Reporte HTML con Videos
```bash
npm run pw:report
```

### Screenshots y Videos
- Screenshots: `screenshots/`
- Videos: `test-results/*/video.webm`

## 🎬 Grabar Nuevos Tests

```bash
npm run pw:codegen
```

Esto abre un navegador donde:
1. Realizas acciones manualmente
2. Playwright genera el código automáticamente
3. Copias el código generado a un nuevo archivo `.spec.ts`

## 📝 Crear Nuevo Test

1. Crear archivo en `e2e/tests/nombre.spec.ts`:

```typescript
import { test, expect } from '@playwright/test';

test.describe('Mi Feature', () => {
  test('mi test', async ({ page }) => {
    await page.goto('/');
    // Tu test aquí
  });
});
```

## 🐛 Debugging

### Modo Debug
```bash
npm run pw:test:debug
```

### Ver Trace de Errores
Cuando un test falla:
1. Ejecuta `npm run pw:report`
2. Click en el test fallido
3. Click en "Trace" para ver paso a paso

## 📱 Testing Mobile

El proyecto está configurado para probar en:
- Desktop Chrome
- Firefox
- Safari
- Mobile Chrome (Pixel 5)
- iPhone 13

## 🔧 Configuración

- **Config**: `playwright.config.ts`
- **Credenciales**: `.env.playwright`
- **Tests**: `e2e/tests/`

## 📋 Tests Disponibles

### Autenticación (`auth.spec.ts`)
- ✅ Login exitoso
- ✅ Login fallido
- ✅ Validación de campos
- ✅ Logout

### Por Crear
- [ ] Itinerarios
- [ ] Productos
- [ ] Contactos
- [ ] Pagos

## 💡 Tips

1. **Siempre verifica** que la app está corriendo antes de tests
2. **Usa el modo UI** para debugging visual
3. **Los videos** se graban automáticamente cuando falla
4. **Codegen** es excelente para crear tests rápidos

## 🆘 Troubleshooting

### "No se puede conectar"
- Verifica que Flutter está corriendo en http://localhost:59931
- Revisa el puerto en `.env.playwright`

### "Elemento no encontrado"
- Usa el modo UI para inspeccionar selectores
- Usa codegen para obtener selectores correctos

### "Test muy lento"
- Reduce el número de proyectos en `playwright.config.ts`
- Ejecuta solo Chrome: `npm run pw:test:chrome`

---

**¡Listo para usar!** Ejecuta `npm run pw:test:ui` para empezar.