# 🚀 Ejecutar Tests con Staging

## 📋 Información del Ambiente Staging

- **Proyecto Supabase**: `wrgkiastpqituocblopg`
- **URL**: `https://wrgkiastpqituocblopg.supabase.co`
- **Dashboard**: https://supabase.com/dashboard/project/wrgkiastpqituocblopg

## 🔧 Configuración Rápida

### 1. Crear usuario de test en Staging

```bash
# Opción A: Usar Supabase Dashboard
# 1. Ir a https://supabase.com/dashboard/project/wrgkiastpqituocblopg/editor
# 2. Ejecutar el script SQL: maestro/setup_staging_test_user.sql

# Opción B: Usar Supabase CLI
supabase db execute -f maestro/setup_staging_test_user.sql --project-ref wrgkiastpqituocblopg
```

### 2. Configurar credenciales locales

```bash
# Copiar plantilla
npm run maestro:setup

# Editar el archivo
nano maestro/.env.maestro
```

Contenido:
```env
# Credenciales del usuario de test
TEST_EMAIL=maestro_test@bukeer.com
TEST_PASSWORD=MaestroTest2024!

# Usuario secundario
TEST_EMAIL_2=maestro_test2@bukeer.com
TEST_PASSWORD_2=MaestroTest2024!

# URL de Staging (NO cambiar)
TEST_BASE_URL=https://wrgkiastpqituocblopg.supabase.co

# Configuración adicional
TEST_TIMEOUT=45000
ENABLE_SCREENSHOTS=true
ENABLE_VIDEO_RECORDING=true
```

### 3. Ejecutar Flutter con Staging

```bash
# Asegurarse de que la app apunta a staging
flutter run --dart-define=ENVIRONMENT=staging

# O para web
flutter run -d chrome --dart-define=ENVIRONMENT=staging
```

## 🧪 Ejecutar Tests

### Tests de verificación (no modifican datos)
```bash
# 1. Verificar login
cd maestro && maestro test flows/auth/01_login_success.yaml

# 2. Verificar navegación
cd maestro && maestro test flows/navigation/01_main_navigation.yaml

# 3. Búsquedas (solo lectura)
cd maestro && maestro test flows/contacts/02_search_contact.yaml
```

### Suite completa de tests
```bash
# Tests de smoke (básicos)
npm run test:e2e

# Todos los tests
npm run test:e2e:all

# Con grabación de video
npm run maestro:test:video
```

### Tests por módulo
```bash
# Solo autenticación
npm run maestro:test:auth

# Solo productos
npm run maestro:test:products

# Solo contactos
npm run maestro:test:contacts
```

## 📊 Monitorear Resultados

### Ver screenshots
```bash
open maestro/screenshots/
```

### Ver videos (si hay fallos)
```bash
open maestro/.maestro/tests/*/video.mp4
```

### Ver logs detallados
```bash
cat maestro/.maestro/tests/*/logs/maestro.log
```

## 🧹 Limpieza de Datos

### Script SQL para limpiar datos de test
```sql
-- Ejecutar periódicamente en staging
-- Elimina solo datos creados por los tests

-- Productos de test
DELETE FROM products 
WHERE name LIKE 'Test Product%' 
OR name LIKE 'Updated Product%';

-- Contactos de test  
DELETE FROM contacts 
WHERE (name LIKE 'Test Contact%' OR name LIKE 'Updated Contact%')
AND user_id IN (
  SELECT id FROM auth.users 
  WHERE email IN ('maestro_test@bukeer.com', 'maestro_test2@bukeer.com')
);

-- Itinerarios de test
DELETE FROM itineraries 
WHERE (name LIKE '%E2E Test%' OR name LIKE 'Test Itinerary%')
AND user_id IN (
  SELECT id FROM auth.users 
  WHERE email IN ('maestro_test@bukeer.com', 'maestro_test2@bukeer.com')
);
```

## ⚠️ Precauciones

1. **NO ejecutar en producción** - Verificar siempre que estás en staging
2. **Coordinar con el equipo** - Avisar si vas a ejecutar muchos tests
3. **Limpiar regularmente** - Los datos de test se acumulan
4. **Usar prefijos** - Todos los datos creados deben tener "Test" en el nombre

## 🔍 Verificación del Ambiente

Para confirmar que estás en staging:
```bash
# La app debe mostrar el banner de "STAGING" en la parte superior
# El banner es naranja y dice "STAGING ENVIRONMENT"
```

## 📱 Dispositivos de Test

### iOS Simulator
```bash
# Abrir simulador
open -a Simulator

# Ejecutar app en staging
flutter run --dart-define=ENVIRONMENT=staging -d iPhone
```

### Web
```bash
# Ejecutar en Chrome
flutter run -d chrome --dart-define=ENVIRONMENT=staging
```

## 🚨 Si algo sale mal

1. **Verificar credenciales**: ¿El usuario existe en staging?
2. **Verificar URL**: ¿Está apuntando a staging?
3. **Ver logs**: `maestro studio` para debugging visual
4. **Limpiar caché**: `npm run maestro:clean`

---

**RECORDATORIO**: Estás trabajando en STAGING (`wrgkiastpqituocblopg`), no en producción. Los datos aquí son de prueba.