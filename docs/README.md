# 📚 Documentación Bukeer

## 🚀 Inicio Rápido

### Desarrollo con Staging
```bash
# Ejecutar app
flutter run -d chrome --dart-define=ENVIRONMENT=staging

# Login
admin@staging.com / password123

# Sincronizar datos
./scripts/sync_prod_to_staging.sh
```

## 📁 Estructura de Documentación

### `/setup`
- `STAGING_COMPLETE_GUIDE.md` - Guía completa de staging

### `/development`
- `DEVELOPMENT_WORKFLOW_STAGING.md` - Flujo de desarrollo
- `LOCAL_DATABASE_SETUP.md` - Configurar BD local (opcional)

### `/guides`
- `PLAYWRIGHT_SETUP.md` - Testing E2E
- `PLAYWRIGHT_QUICK_START.md` - Quick start testing

### `/reference`
- `SUPABASE_GUIDE.md` - Referencia de Supabase

### `/historical`
- Documentación del proceso de migración inicial

### `/archive`
- Documentos obsoletos o reemplazados

## 🔗 Enlaces Rápidos

- [Staging Dashboard](https://supabase.com/dashboard/project/wrgkiastpqituocblopg)
- [Production Dashboard](https://supabase.com/dashboard/project/wzlxbpicdcdvxvdcvgas)

## 📋 Scripts Importantes

```bash
# Sincronizar staging con producción
./scripts/sync_prod_to_staging.sh

# Crear usuario en staging
psql $STAGING_DB -f scripts/create_complete_user_staging.sql
```

---
*Última actualización: $(date)*
