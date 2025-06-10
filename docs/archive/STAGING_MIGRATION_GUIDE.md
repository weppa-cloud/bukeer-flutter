# Guía de Migración y Sincronización Staging

## 📋 Resumen de la Migración

### Fecha de Migración
- **Fecha**: 9 de Junio de 2025
- **Datos migrados desde**: Producción (wzlxbpicdcdvxvdcvgas)
- **Datos migrados hacia**: Staging (wrgkiastpqituocblopg)

### Proceso Realizado

1. **Backup de Producción**
   ```bash
   # Generado con Supabase CLI
   supabase db dump --db-url "postgresql://postgres:aqe9KRCreA4D0X6n@db.wzlxbpicdcdvxvdcvgas.supabase.co:5432/postgres" --data-only -f ./backups/prod_supabase_20250609_190924.sql
   ```

2. **Extracción del Esquema**
   ```bash
   # Esquema completo desde producción
   pg_dump "postgresql://postgres.wzlxbpicdcdvxvdcvgas:aqe9KRCreA4D0X6n@aws-0-us-west-1.pooler.supabase.com:6543/postgres" --schema-only --no-owner --no-privileges --schema=public -f ./backups/production_schema.sql
   ```

3. **Importación a Staging**
   - Primero se aplicó el esquema
   - Luego se importaron los datos
   - Se crearon usuarios de prueba
   - Se otorgaron permisos necesarios

## 🔗 Credenciales y Enlaces

### Producción
- **Project ID**: wzlxbpicdcdvxvdcvgas
- **URL**: https://wzlxbpicdcdvxvdcvgas.supabase.co
- **Database (Pooler)**: 
  ```
  postgresql://postgres.wzlxbpicdcdvxvdcvgas:[PASSWORD]@aws-0-us-west-1.pooler.supabase.com:6543/postgres
  ```
- **Dashboard**: https://supabase.com/dashboard/project/wzlxbpicdcdvxvdcvgas

### Staging
- **Project ID**: wrgkiastpqituocblopg
- **URL**: https://wrgkiastpqituocblopg.supabase.co
- **Anon Key**: 
  ```
  eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndyZ2tpYXN0cHFpdHVvY2Jsb3BnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3OTE0NjIsImV4cCI6MjA0OTM2NzQ2Mn0.J7fLWMhMQiRvRr8mPQ0h-YZ7JTQMUVwNkROOSTU8MZU
  ```
- **Database (Pooler)**: 
  ```
  postgresql://postgres.wrgkiastpqituocblopg:[PASSWORD]@aws-0-us-east-2.pooler.supabase.com:6543/postgres
  ```
- **Dashboard**: https://supabase.com/dashboard/project/wrgkiastpqituocblopg

### Usuario de Prueba en Staging
- **Email**: admin@staging.com
- **Password**: password123
- **Rol**: super_admin
- **Account**: ColombiaTours.Travel

## 🔄 Script de Sincronización Futura

Para futuras sincronizaciones de producción a staging, usar este script:

```bash
#!/bin/bash
# sync_prod_to_staging.sh

echo "🔄 Sincronización Producción → Staging"
echo "======================================"
echo ""

# Configuración
PROD_DB="postgresql://postgres.wzlxbpicdcdvxvdcvgas:aqe9KRCreA4D0X6n@aws-0-us-west-1.pooler.supabase.com:6543/postgres"
STAGING_DB="postgresql://postgres.wrgkiastpqituocblopg:fZGE3YShagCIeTON@aws-0-us-east-2.pooler.supabase.com:6543/postgres"
BACKUP_DIR="./backups/sync_$(date +%Y%m%d_%H%M%S)"

# Crear directorio para backup
mkdir -p $BACKUP_DIR

# 1. Backup de producción (solo datos)
echo "📦 Creando backup de producción..."
pg_dump "$PROD_DB" --data-only --exclude-schema=auth --exclude-schema=storage \
    -f "$BACKUP_DIR/prod_data.sql"

# 2. Limpiar staging (excepto usuarios)
echo "🧹 Limpiando datos en staging..."
psql "$STAGING_DB" << EOF
-- Desactivar triggers
SET session_replication_role = replica;

-- Limpiar tablas en orden inverso de dependencias
TRUNCATE TABLE 
    public.transactions,
    public.passenger,
    public.itinerary_items,
    public.itineraries,
    public.transfer_rates,
    public.transfers,
    public.activities_rates,
    public.activities,
    public.hotel_rates,
    public.hotels,
    public.images,
    public.user_roles,
    public.contacts,
    public.locations,
    public.accounts
CASCADE;

-- Reactivar triggers
SET session_replication_role = origin;
EOF

# 3. Importar datos a staging
echo "📥 Importando datos a staging..."
psql "$STAGING_DB" -f "$BACKUP_DIR/prod_data.sql"

# 4. Recrear usuario admin
echo "👤 Recreando usuario admin..."
psql "$STAGING_DB" << EOF
-- Verificar/crear usuario admin
INSERT INTO auth.users (
    id,
    email,
    encrypted_password,
    email_confirmed_at,
    created_at,
    updated_at,
    raw_app_meta_data,
    raw_user_meta_data,
    aud,
    role
) VALUES (
    'a08ae0ff-24c0-4895-b552-96a4bead229e',
    'admin@staging.com',
    crypt('password123', gen_salt('bf')),
    now(),
    now(),
    now(),
    jsonb_build_object('provider', 'email', 'providers', array['email']),
    jsonb_build_object(),
    'authenticated',
    'authenticated'
) ON CONFLICT (id) DO NOTHING;

-- Asegurar rol super_admin
INSERT INTO public.user_roles (
    user_id,
    role_id,
    created_at,
    account_id
) VALUES (
    'a08ae0ff-24c0-4895-b552-96a4bead229e',
    1,
    now(),
    '9fc24733-b127-4184-aa22-12f03b98927a'
) ON CONFLICT DO NOTHING;
EOF

echo "✅ Sincronización completada"
echo "📊 Verificando datos..."
psql "$STAGING_DB" -c "
SELECT 
    'itineraries' as tabla, COUNT(*) as registros FROM public.itineraries
UNION ALL SELECT 'activities', COUNT(*) FROM public.activities
UNION ALL SELECT 'hotels', COUNT(*) FROM public.hotels
ORDER BY tabla;"
```

## 📝 Notas Importantes

1. **Permisos en Staging**: Se otorgaron permisos completos a los roles `anon` y `authenticated` para facilitar el desarrollo.

2. **Datos Sensibles**: Los datos de producción en staging contienen información real. Considerar anonimizar datos sensibles en futuras sincronizaciones.

3. **Edge Functions**: No se migraron las Edge Functions. Estas deben desplegarse manualmente si son necesarias.

4. **Storage**: Los archivos de Storage no se migraron. Las referencias existen pero los archivos físicos no.

## 🛠️ Comandos Útiles

### Verificar conexión
```bash
psql "postgresql://postgres.wrgkiastpqituocblopg:fZGE3YShagCIeTON@aws-0-us-east-2.pooler.supabase.com:6543/postgres" -c "SELECT version();"
```

### Ejecutar la app en staging
```bash
flutter run -d chrome --dart-define=ENVIRONMENT=staging
```

### Ver logs de staging
```bash
supabase logs --project-ref wrgkiastpqituocblopg
```

## 🔐 Seguridad

**IMPORTANTE**: 
- Cambiar la contraseña de producción que fue expuesta durante la configuración
- No commitear credenciales en el repositorio
- Usar variables de entorno para credenciales sensibles

## 📅 Historial de Sincronizaciones

| Fecha | Tipo | Registros | Notas |
|-------|------|-----------|-------|
| 2025-06-09 | Migración inicial | 906 itinerarios, 594 actividades | Primera configuración de staging |