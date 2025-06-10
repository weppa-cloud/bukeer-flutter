# ✅ Todo Listo para Testing con Maestro

## 🎯 Estado Actual

### Credenciales Configuradas ✅
- **Usuario**: admin@staging.com  
- **Password**: password123
- **URL Staging**: https://wrgkiastpqituocblopg.supabase.co
- **Archivo**: `maestro/.env.maestro` (ya configurado)

### Tests Disponibles ✅
- 15 tests automatizados
- Cobertura de todos los módulos principales
- Tests E2E completos

## 🚀 Cómo Ejecutar los Tests

### Opción 1: iOS Simulator (Recomendado)

```bash
# 1. Abrir iOS Simulator
open -a Simulator

# 2. Ejecutar la app en staging
flutter run --dart-define=ENVIRONMENT=staging -d iPhone

# 3. Ejecutar tests
npm run test:e2e
```

### Opción 2: Android Emulator

```bash
# 1. Abrir Android Emulator
emulator -avd <tu_emulador>

# 2. Ejecutar la app
flutter run --dart-define=ENVIRONMENT=staging -d emulator

# 3. Ejecutar tests
npm run test:e2e
```

### Opción 3: Dispositivo Físico

```bash
# 1. Conectar dispositivo
flutter devices

# 2. Ejecutar app
flutter run --dart-define=ENVIRONMENT=staging -d <device_id>

# 3. Ejecutar tests
npm run test:e2e
```

## 📋 Tests Recomendados para Empezar

### 1. Test de Login (Verificar credenciales)
```bash
cd maestro && maestro test flows/auth/01_login_success.yaml
```

### 2. Test de Navegación
```bash
cd maestro && maestro test flows/navigation/01_main_navigation.yaml
```

### 3. Suite de Smoke Tests
```bash
npm run maestro:test:smoke
```

## 🎥 Ejecutar con Video

Para grabar videos de los tests:
```bash
npm run maestro:test:video
```

## 📊 Ver Resultados

### Screenshots
```bash
open maestro/screenshots/
```

### Videos (si hay fallos)
```bash
find maestro/.maestro -name "*.mp4" -exec open {} \;
```

### Logs
```bash
cat maestro/.maestro/tests/*/logs/maestro.log
```

## 🔍 Debugging

Si necesitas ver qué está pasando:
```bash
# Abrir Maestro Studio (interfaz visual)
npm run maestro:studio
```

## ⚠️ Notas Importantes

1. **Maestro funciona mejor con apps móviles** (iOS/Android)
2. **Para web**, considera usar otras herramientas como Playwright o Cypress
3. **Siempre verifica** que estás en staging (banner naranja en la app)
4. **Los tests crean datos reales** en staging - úsalos con cuidado

## 🆘 Troubleshooting

### "App not found"
- Asegúrate de que la app está corriendo
- Verifica el bundle ID en los tests

### "Element not found"
- La UI puede ser diferente entre web y móvil
- Usa `maestro studio` para inspeccionar elementos

### "Login failed"
- Verifica las credenciales en `.env.maestro`
- Confirma que el usuario existe en staging

## 📱 Próximos Pasos

1. **Ejecutar primer test** de login para verificar setup
2. **Correr suite de smoke** para validación básica
3. **Revisar videos/screenshots** de cualquier fallo
4. **Ajustar selectores** si es necesario para tu UI

---

**¡Todo está listo!** Solo necesitas:
1. Levantar la app en un simulador/emulador
2. Ejecutar `npm run test:e2e`

¿Necesitas ayuda con algún paso específico?