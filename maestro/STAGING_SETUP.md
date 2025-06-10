# 🚀 Configuración de Tests con Ambiente Staging

## 📋 Pasos para Configurar

### 1. Crear Usuario de Test en Staging

```sql
-- Conectarse a la base de datos de staging
-- Crear un usuario específico para tests automatizados

-- Opción 1: Crear usuario nuevo
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'maestro_test@bukeer.com',
  crypt('MaestroTest2024!', gen_salt('bf')),
  NOW(),
  NOW(),
  NOW()
);

-- Obtener el ID del usuario creado
SELECT id FROM auth.users WHERE email = 'maestro_test@bukeer.com';

-- Asignar rol (reemplazar USER_ID con el ID obtenido)
INSERT INTO public.user_roles (user_id, role_id)
SELECT 
  'USER_ID',
  id
FROM public.roles 
WHERE name = 'admin';

-- Crear perfil de usuario
INSERT INTO public.user_contact_info (
  user_id,
  name,
  email,
  phone
) VALUES (
  'USER_ID',
  'Maestro Test User',
  'maestro_test@bukeer.com',
  '+1234567890'
);
```

### 2. Configurar Credenciales Locales

```bash
# Copiar plantilla
npm run maestro:setup

# Editar con credenciales de staging
nano maestro/.env.maestro
```

Contenido del archivo:
```env
# Credenciales de Staging
TEST_EMAIL=maestro_test@bukeer.com
TEST_PASSWORD=MaestroTest2024!

# URL de Staging (ajustar según tu configuración)
TEST_BASE_URL=https://staging.bukeer.com
# o si es local:
# TEST_BASE_URL=http://localhost:3000

# Usuario secundario (opcional)
TEST_EMAIL_2=maestro_test2@bukeer.com
TEST_PASSWORD_2=MaestroTest2024!

# Timeouts más largos para staging
TEST_TIMEOUT=45000
```

### 3. Crear Datos de Prueba en Staging

```sql
-- Crear algunos datos de prueba para el usuario

-- Itinerario de prueba
INSERT INTO public.itineraries (
  id,
  name,
  description,
  start_date,
  end_date,
  user_id,
  created_at
) VALUES (
  gen_random_uuid(),
  'Test Itinerary - Maestro',
  'Itinerario creado para tests automatizados',
  CURRENT_DATE + INTERVAL '7 days',
  CURRENT_DATE + INTERVAL '10 days',
  'USER_ID',
  NOW()
);

-- Productos de prueba
INSERT INTO public.hotels (name, location_id, description)
SELECT 
  'Test Hotel ' || generate_series,
  1, -- Ajustar según tu tabla locations
  'Hotel de prueba para Maestro tests'
FROM generate_series(1, 3);

-- Contactos de prueba
INSERT INTO public.contacts (
  user_id,
  name,
  email,
  phone,
  type
)
SELECT 
  'USER_ID',
  'Test Contact ' || generate_series,
  'contact' || generate_series || '@test.com',
  '+123456789' || generate_series,
  'client'
FROM generate_series(1, 5);
```

### 4. Verificar Configuración

```bash
# Test rápido de login
cd maestro && maestro test flows/auth/01_login_success.yaml

# Si funciona, ver los logs
cat maestro/.maestro/tests/*/logs/maestro.log
```

### 5. Configurar Variables de Entorno para la App

```bash
# En tu archivo de configuración de Flutter para staging
# lib/config/app_config.dart o similar

# Asegurarse de que apunta a staging
SUPABASE_URL=https://tu-proyecto-staging.supabase.co
SUPABASE_ANON_KEY=tu-anon-key-staging
```

## 🧪 Tests Recomendados para Staging

### Tests Seguros (no modifican datos críticos):
```bash
# 1. Navegación y login
npm run maestro:test:auth

# 2. Búsquedas y filtros
cd maestro && maestro test flows/contacts/02_search_contact.yaml
```

### Tests que Crean Datos (usar con precaución):
```bash
# Crear un producto de test
cd maestro && maestro test flows/products/01_create_product.yaml

# El producto se llamará "Test Product [timestamp]"
# Fácil de identificar y limpiar después
```

## 🧹 Limpieza de Datos de Test

Script SQL para limpiar datos creados por Maestro:
```sql
-- Limpiar datos de test (ejecutar periódicamente)
-- Identificamos por patrones en nombres

-- Eliminar productos de test
DELETE FROM products 
WHERE name LIKE 'Test Product%' 
AND created_at < NOW() - INTERVAL '1 day';

-- Eliminar contactos de test
DELETE FROM contacts 
WHERE name LIKE 'Test Contact%'
AND user_id = (SELECT id FROM auth.users WHERE email = 'maestro_test@bukeer.com');

-- Eliminar itinerarios de test antiguos
DELETE FROM itineraries 
WHERE name LIKE '%E2E Test%' 
AND created_at < NOW() - INTERVAL '1 day';
```

## 🚨 Precauciones para Staging

1. **No usar emails reales** - Usa dominios de test
2. **Prefijos en nombres** - Todos los datos de test deben tener prefijos
3. **Limpieza regular** - Ejecutar scripts de limpieza semanalmente
4. **Monitorear uso** - No saturar staging con demasiados tests
5. **Coordinar con equipo** - Avisar cuando se ejecutan tests masivos

## 🔄 Workflow Recomendado

```bash
# 1. Antes de empezar
git pull
npm install

# 2. Configurar credenciales (una sola vez)
npm run maestro:setup
# Editar maestro/.env.maestro

# 3. Ejecutar tests de smoke
npm run test:e2e

# 4. Si todo está bien, ejecutar suite completa
npm run test:e2e:all

# 5. Revisar resultados
open maestro/screenshots/
open maestro/.maestro/tests/*/video.mp4

# 6. Limpiar después
npm run maestro:clean
```

## 📊 Monitoreo

Para verificar que no estamos afectando staging:
```sql
-- Ver actividad reciente del usuario de test
SELECT 
  action,
  created_at,
  metadata
FROM audit_logs
WHERE user_id = (SELECT id FROM auth.users WHERE email = 'maestro_test@bukeer.com')
ORDER BY created_at DESC
LIMIT 20;

-- Contar objetos creados por tests
SELECT 
  COUNT(*) as test_products
FROM products 
WHERE name LIKE 'Test%';
```

---

**IMPORTANTE**: Aunque staging es más seguro que producción, sigue siendo un ambiente compartido. Usa los tests con responsabilidad.