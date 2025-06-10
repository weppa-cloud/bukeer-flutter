# 🏠 Configuración de Base de Datos Local

## 🚀 Opción 1: Supabase Local (Recomendado)

### Instalación
```bash
# 1. Instalar Supabase CLI
brew install supabase/tap/supabase

# 2. Verificar instalación
supabase --version
```

### Configuración Inicial
```bash
# En la raíz del proyecto
cd /path/to/bukeer-flutter

# 1. Inicializar Supabase (solo primera vez)
supabase init

# 2. Configurar para usar el schema existente
cp ./backups/production_schema.sql ./supabase/migrations/00000000000000_initial_schema.sql

# 3. Iniciar servicios locales
supabase start
```

### URLs Locales
Después de `supabase start`, obtendrás:
```
API URL: http://localhost:54321
DB URL: postgresql://postgres:postgres@localhost:54322/postgres
Studio URL: http://localhost:54323
Anon Key: eyJ...local...key
Service Key: eyJ...service...key
```

### Configurar Flutter
```dart
// lib/config/app_config.dart
// Agregar configuración local
case 'local':
  return {
    'supabaseUrl': 'http://localhost:54321',
    'supabaseAnonKey': 'TU_LOCAL_ANON_KEY',
    'apiBaseUrl': 'http://localhost:54321/rest/v1',
    'googleMapsApiKey': googleMapsApiKey,
  };
```

### Ejecutar con BD Local
```bash
# Desarrollo con base de datos local
flutter run -d chrome --dart-define=ENVIRONMENT=local
```

### Cargar Datos de Prueba
```bash
# Opción A: Datos mínimos de prueba
cat > ./supabase/seed.sql << 'EOF'
-- Datos de prueba para desarrollo local
INSERT INTO public.accounts (id, name, created_at) VALUES
('9fc24733-b127-4184-aa22-12f03b98927a', 'Test Company Local', now());

INSERT INTO public.contacts (id, name, email, account_id, created_at) VALUES
(gen_random_uuid(), 'Test User', 'test@local.com', '9fc24733-b127-4184-aa22-12f03b98927a', now());

-- Agregar más datos de prueba según necesites
EOF

# Aplicar seed
psql "postgresql://postgres:postgres@localhost:54322/postgres" < ./supabase/seed.sql
```

```bash
# Opción B: Copiar subset de staging
./scripts/sync_prod_to_staging.sh  # Primero actualizar staging
pg_dump "postgresql://postgres.wrgkiastpqituocblopg:fZGE3YShagCIeTON@aws-0-us-east-2.pooler.supabase.com:6543/postgres" \
  --data-only \
  --table=accounts \
  --table=contacts \
  --table=hotels \
  --table=activities \
  --rows-per-insert=100 \
  | psql "postgresql://postgres:postgres@localhost:54322/postgres"
```

### Comandos Útiles
```bash
# Ver logs
supabase logs

# Resetear base de datos
supabase db reset

# Detener servicios
supabase stop

# Estado de servicios
supabase status
```

## 🐘 Opción 2: PostgreSQL Simple

### Instalación
```bash
# Instalar PostgreSQL
brew install postgresql@16
brew services start postgresql@16

# Crear base de datos
createdb bukeer_local

# Aplicar schema
psql bukeer_local < ./backups/production_schema.sql
```

### Configuración
```bash
# Crear usuario
psql bukeer_local -c "CREATE USER bukeer_dev WITH PASSWORD 'localpass123';"
psql bukeer_local -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO bukeer_dev;"
```

### Actualizar Flutter
```dart
// En app_config.dart para local
'supabaseUrl': 'http://localhost:5432',  // No funcionará auth/storage
'databaseUrl': 'postgresql://bukeer_dev:localpass123@localhost:5432/bukeer_local',
```

## 🎯 Flujo de Desarrollo Recomendado

### Con Supabase Local:
```bash
# 1. Mañana: Levantar servicios
supabase start

# 2. Desarrollar
flutter run -d chrome --dart-define=ENVIRONMENT=local

# 3. Ver cambios en BD
open http://localhost:54323  # Studio UI

# 4. Al terminar
supabase stop
```

### Ventajas de BD Local:
- ✅ No afectas staging/producción
- ✅ Puedes borrar/recrear datos libremente
- ✅ Pruebas destructivas sin miedo
- ✅ Sin latencia de red
- ✅ Funciona offline

### Sincronización Periódica:
```bash
# Actualizar schema local con cambios de producción
supabase db pull --schema public
# O manualmente:
pg_dump [STAGING_URL] --schema-only | psql [LOCAL_URL]
```

## 🔄 Migración de Datos

### Script para copiar datos específicos:
```bash
#!/bin/bash
# sync_local_data.sh

LOCAL_DB="postgresql://postgres:postgres@localhost:54322/postgres"
STAGING_DB="postgresql://postgres.wrgkiastpqituocblopg:fZGE3YShagCIeTON@aws-0-us-east-2.pooler.supabase.com:6543/postgres"

# Limpiar local
psql $LOCAL_DB -c "TRUNCATE accounts, contacts, hotels, activities CASCADE;"

# Copiar datos básicos de staging
pg_dump $STAGING_DB \
  --data-only \
  --table=accounts \
  --table=contacts \
  --table=hotels \
  --table=activities \
  | psql $LOCAL_DB

echo "✅ Datos copiados a local"
```

## 🚨 Troubleshooting

### Error: "Cannot connect to Supabase"
```bash
# Verificar que está corriendo
supabase status

# Ver logs
supabase logs --tail 100
```

### Error: "Port already in use"
```bash
# Detener servicios existentes
supabase stop --no-backup
lsof -ti:54321 | xargs kill -9  # Si persiste
```

### Reset completo
```bash
supabase stop --no-backup
supabase db reset
supabase start
```

## 📝 Resumen

1. **Usa Supabase local** para desarrollo día a día
2. **Staging** para pruebas de integración
3. **Nunca** desarrolles contra producción
4. **Sincroniza** schema periódicamente

```
Local (Supabase) → Staging (Test) → Production
   ↓                    ↓
Dev rápido         Pruebas reales
```