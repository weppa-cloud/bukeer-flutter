# 🚀 Guía Completa de Staging

## Contenido
1. [Configuración](#configuración)
2. [Credenciales](#credenciales)
3. [Uso Diario](#uso-diario)
4. [Sincronización](#sincronización)
5. [Troubleshooting](#troubleshooting)

## Configuración

### Credenciales de Staging
- **Project ID**: wrgkiastpqituocblopg
- **URL**: https://wrgkiastpqituocblopg.supabase.co
- **Anon Key**: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndyZ2tpYXN0cHFpdHVvY2Jsb3BnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3OTE0NjIsImV4cCI6MjA0OTM2NzQ2Mn0.J7fLWMhMQiRvRr8mPQ0h-YZ7JTQMUVwNkROOSTU8MZU
- **Database**: postgresql://postgres.wrgkiastpqituocblopg:[PASSWORD]@aws-0-us-east-2.pooler.supabase.com:6543/postgres
- **Dashboard**: https://supabase.com/dashboard/project/wrgkiastpqituocblopg

### Usuario de Prueba
- **Email**: admin@staging.com
- **Password**: password123

## Uso Diario

### Ejecutar en Staging
```bash
flutter run -d chrome --dart-define=ENVIRONMENT=staging
```

### Sincronizar Datos
```bash
./scripts/sync_prod_to_staging.sh
```

## Sincronización

El script `sync_prod_to_staging.sh`:
1. Hace backup de staging actual
2. Extrae datos de producción
3. Limpia staging
4. Importa datos frescos
5. Recrea usuario admin

### Frecuencia Recomendada
- **Semanal**: Para desarrollo normal
- **Diaria**: Durante desarrollo intensivo
- **Bajo demanda**: Para pruebas específicas

## Troubleshooting

### Usuario no puede login
```bash
psql $STAGING_DB -f scripts/create_complete_user_staging.sql
```

### Datos desactualizados
```bash
./scripts/sync_prod_to_staging.sh
```

### Verificar conexión
```bash
psql "postgresql://postgres.wrgkiastpqituocblopg:fZGE3YShagCIeTON@aws-0-us-east-2.pooler.supabase.com:6543/postgres" -c "SELECT 1;"
```

---
*Última actualización: $(date)*
