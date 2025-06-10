# 🔐 Credenciales de Entornos - Bukeer

> **DOCUMENTO CONFIDENCIAL** - No compartir ni subir a Git
> Última actualización: 2025-01-09

## 🌍 Entornos Disponibles

### 1. 🔴 PRODUCCIÓN (Datos Reales)
- **Organización**: Weppa Group
- **Plan**: Pro ($25/mes)
- **Región**: US West 1 (North California)
- **Project ID**: `wzlxbpicdcdvxvdcvgas`

#### URLs
- **Dashboard**: https://supabase.com/dashboard/project/wzlxbpicdcdvxvdcvgas
- **App URL**: https://wzlxbpicdcdvxvdcvgas.supabase.co
- **API URL**: https://wzlxbpicdcdvxvdcvgas.supabase.co/rest/v1

#### Credenciales API
```
SUPABASE_URL=https://wzlxbpicdcdvxvdcvgas.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0NjQyODAsImV4cCI6MjA0MTA0MDI4MH0.dSh-yGzemDC7DL_rf7fwgWlMoEKv1SlBCxd8ElFs_d8
```

#### Connection String (para backups)
```
postgresql://postgres.[PROJECT_ID]:[PASSWORD]@aws-0-us-west-1.pooler.supabase.com:5432/postgres
```
⚠️ Reemplazar [PASSWORD] con el password actual de la base de datos

---

### 2. 🟡 STAGING (Datos de Prueba)
- **Organización**: Bukeer Development (Free)
- **Plan**: Free ($0)
- **Región**: US West 1 (North California)
- **Project ID**: `wrgkiastpqituocblopg`

#### URLs
- **Dashboard**: https://supabase.com/dashboard/project/wrgkiastpqituocblopg
- **App URL**: https://wrgkiastpqituocblopg.supabase.co
- **API URL**: https://wrgkiastpqituocblopg.supabase.co/rest/v1

#### Credenciales API
```
STAGING_URL=https://wrgkiastpqituocblopg.supabase.co
STAGING_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndyZ2tpYXN0cHFpdHVvY2Jsb3BnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk1MDg2NzAsImV4cCI6MjA2NTA4NDY3MH0.a-hvVJGE0UqggMJPuxB6VLFpBDFP5RlUDHhtjr5B_K4
STAGING_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndyZ2tpYXN0cHFpdHVvY2Jsb3BnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0OTUwODY3MCwiZXhwIjoyMDY1MDg0NjcwfQ.0fwZLHpUc8PHeT89klrqgTQ1EAR5GF3GSZSVQiXx8Pk
```

#### Connection String (para migraciones)
```
postgresql://postgres.[PROJECT_ID]:[PASSWORD]@aws-0-us-west-1.pooler.supabase.com:5432/postgres
```
⚠️ Reemplazar [PASSWORD] con el password de staging

---

### 3. 🟢 LOCAL (Desarrollo)
- **Plan**: N/A (usa staging como backend)
- **Puerto**: 5000 (por defecto)

#### Configuración
- Usa las credenciales de STAGING
- Se ejecuta en: http://localhost:5000

---

## 🚀 Comandos Rápidos

### Ejecutar en cada entorno:

```bash
# Desarrollo local (usa staging como backend)
flutter run -d chrome

# Staging
./run_staging.sh
# o manualmente:
flutter run -d chrome --dart-define=ENVIRONMENT=staging --web-port 5001

# Producción (solo para verificar, no desarrollar)
flutter run -d chrome --dart-define=ENVIRONMENT=production --web-port 5002
```

### Cambiar entre entornos:

El archivo `lib/config/app_config.dart` detecta automáticamente el entorno basado en `--dart-define=ENVIRONMENT`

---

## 🔧 Operaciones Comunes

### Backup de Producción
```bash
./scripts/backup_production.sh
```

### Migrar esquema a Staging
```bash
./scripts/migrate_to_staging.sh
```

### Verificar qué entorno está activo
```dart
// En el código Flutter
print('Entorno actual: ${AppConfig.environment}');
print('URL: ${AppConfig.supabaseUrl}');
```

---

## 🔑 Gestión de Passwords

### Cambiar password de Base de Datos

1. **Producción**:
   - Dashboard → Settings → Database → Reset database password
   - Actualizar en todos los lugares donde se use

2. **Staging**:
   - Mismo proceso pero en el proyecto de staging

### ⚠️ Nunca:
- Compartir passwords en chats o emails
- Hardcodear passwords en el código
- Usar el mismo password en producción y staging
- Subir este archivo a Git

---

## 📱 Otros Servicios

### Google Maps API
- **Key**: `AIzaSyDEUekXeyIKJUreRydJyv05gCexdSjUdBc`
- **Uso**: Todos los entornos (misma key)

### Edge Functions (Solo Producción)
- OpenAI API
- Serper API
- Gotenberg
- Duffel API

---

## 🚨 En caso de emergencia

### Si se compromete una credencial:
1. Cambiar inmediatamente en Supabase Dashboard
2. Actualizar en este documento
3. Actualizar en `app_config.dart`
4. Notificar al equipo

### Contactos de emergencia:
- Admin Principal: [COMPLETAR]
- Backup Admin: [COMPLETAR]

---

## 📝 Historial de Cambios

- **2025-01-09**: Documento creado
  - Configurado entorno de producción
  - Creado entorno de staging
  - Documentadas todas las credenciales

---

**Recordatorio**: Revisar y actualizar este documento cada vez que:
- Se cambien passwords
- Se creen nuevos entornos
- Se modifiquen credenciales
- Se agreguen nuevos servicios