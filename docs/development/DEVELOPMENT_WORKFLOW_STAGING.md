# 🚀 Flujo de Desarrollo con Staging Configurado

## 📋 Flujo Simplificado

```
Local Development → Staging (Test) → Production
                      ↑        ↓
                    Sync from Prod
```

## 🏠 1. Desarrollo Local

### Inicio del Día
```bash
# Actualizar código
git pull origin main

# Ejecutar en modo desarrollo (local)
flutter run -d chrome

# O para hot reload
flutter run -d chrome --hot
```

**Características:**
- ✅ Desarrollo rápido con hot reload
- ✅ Sin afectar datos reales
- ❌ Sin conexión a base de datos real

## 🧪 2. Pruebas en Staging

### Conectar a Staging
```bash
# Ejecutar app conectada a staging
flutter run -d chrome --dart-define=ENVIRONMENT=staging
```

### Login en Staging
- **URL**: http://localhost:[puerto]
- **Usuario**: admin@staging.com
- **Password**: password123

### Sincronizar Datos (si necesario)
```bash
# Actualizar staging con datos frescos de producción
./scripts/sync_prod_to_staging.sh
```

**El script hace:**
1. Backup de staging actual
2. Extrae datos de producción
3. Limpia staging
4. Importa datos frescos
5. Recrea usuario admin

## 📊 Casos de Uso por Ambiente

### Cuándo usar Desarrollo Local
- ✅ Cambios de UI/UX
- ✅ Nuevos componentes visuales
- ✅ Refactoring de código
- ✅ Pruebas unitarias

### Cuándo usar Staging
- ✅ Probar con datos reales
- ✅ Validar integraciones
- ✅ Pruebas de rendimiento
- ✅ Demo para clientes
- ✅ Pruebas antes de producción

### Cuándo usar Producción
- ⚠️ SOLO para verificar bugs reportados
- ⚠️ NUNCA para desarrollo
- ⚠️ NUNCA para pruebas

## 🔄 Flujo de Trabajo Típico

### 1. Nueva Funcionalidad
```bash
# 1. Crear branch
git checkout -b feature/nueva-funcionalidad

# 2. Desarrollar y probar localmente
flutter run -d chrome

# 3. Cuando esté listo, probar en staging
flutter run -d chrome --dart-define=ENVIRONMENT=staging

# 4. Si necesitas datos actualizados
./scripts/sync_prod_to_staging.sh

# 5. Hacer commit
git add .
git commit -m "feat: descripción de la funcionalidad"
git push origin feature/nueva-funcionalidad

# 6. Crear Pull Request
# 7. Después del merge, desplegar a producción
```

### 2. Corrección de Bug
```bash
# 1. Reproducir en staging
flutter run -d chrome --dart-define=ENVIRONMENT=staging

# 2. Crear branch
git checkout -b fix/descripcion-del-bug

# 3. Corregir y probar
flutter run -d chrome --dart-define=ENVIRONMENT=staging

# 4. Commit y PR
git add .
git commit -m "fix: descripción de la corrección"
git push origin fix/descripcion-del-bug
```

### 3. Hotfix Urgente
```bash
# 1. Branch desde main
git checkout -b hotfix/problema-critico main

# 2. Probar directamente en staging
flutter run -d chrome --dart-define=ENVIRONMENT=staging

# 3. Fix rápido, commit y deploy
git add .
git commit -m "hotfix: corrección crítica"
git push origin hotfix/problema-critico

# 4. Merge directo a main (con aprobación)
```

## 🛠️ Comandos Útiles

### Desarrollo
```bash
# Desarrollo local
flutter run -d chrome

# Con hot reload
flutter run -d chrome --hot

# Staging
flutter run -d chrome --dart-define=ENVIRONMENT=staging

# Build para producción
flutter build web --release
```

### Base de Datos
```bash
# Sincronizar staging con producción
./scripts/sync_prod_to_staging.sh

# Conectar a staging DB
psql "postgresql://postgres.wrgkiastpqituocblopg:fZGE3YShagCIeTON@aws-0-us-east-2.pooler.supabase.com:6543/postgres"

# Ver datos en staging
psql $STAGING_DB -c "SELECT COUNT(*) FROM itineraries;"
```

### Git Workflow
```bash
# Feature branch
git checkout -b feature/nombre-descriptivo

# Bugfix branch
git checkout -b fix/descripcion-del-bug

# Hotfix branch
git checkout -b hotfix/problema-critico main

# Push y crear PR
git push -u origin nombre-de-la-branch
```

## 📱 Indicadores Visuales

La app muestra un banner en desarrollo y staging:
- 🟡 **STAGING** - Banner amarillo
- 🔴 **DEVELOPMENT** - Banner rojo
- Sin banner = Producción

## ✅ Mejores Prácticas

### DO's ✅
1. **Siempre probar en staging** antes de producción
2. **Sincronizar staging semanalmente** (mínimo)
3. **Usar branches descriptivos**
4. **Hacer commits pequeños y frecuentes**
5. **Escribir mensajes de commit claros**

### DON'Ts ❌
1. **NO desarrollar directamente en main**
2. **NO probar en producción**
3. **NO hacer cambios directos en la BD**
4. **NO commitear credenciales**
5. **NO saltarse el proceso de PR**

## 🚨 Solución de Problemas

### "Invalid credentials" en Staging
```bash
# Recrear usuario admin
psql "postgresql://postgres.wrgkiastpqituocblopg:fZGE3YShagCIeTON@aws-0-us-east-2.pooler.supabase.com:6543/postgres" -f scripts/create_complete_user_staging.sql
```

### Datos desactualizados en Staging
```bash
# Sincronizar con producción
./scripts/sync_prod_to_staging.sh
```

### Error de conexión a Staging
```bash
# Verificar conexión
psql "postgresql://postgres.wrgkiastpqituocblopg:fZGE3YShagCIeTON@aws-0-us-east-2.pooler.supabase.com:6543/postgres" -c "SELECT 1;"

# Verificar configuración
cat lib/config/app_config.dart | grep staging -A 5
```

## 📊 Monitoreo

### Logs en Browser
```javascript
// Abrir consola (F12) y filtrar por:
console.log
network
errors
```

### Dashboard de Supabase
- **Staging**: https://supabase.com/dashboard/project/wrgkiastpqituocblopg
- **Producción**: https://supabase.com/dashboard/project/wzlxbpicdcdvxvdcvgas

### Verificar Datos
```sql
-- En staging
SELECT 
    'itineraries' as tabla, COUNT(*) as total 
FROM itineraries
UNION ALL
SELECT 'activities', COUNT(*) FROM activities
UNION ALL
SELECT 'hotels', COUNT(*) FROM hotels;
```

## 🎯 Resumen del Flujo

1. **Desarrolla** localmente (rápido, sin datos)
2. **Prueba** en staging (con datos reales)
3. **Valida** que todo funcione
4. **Crea PR** para revisión
5. **Despliega** a producción
6. **Sincroniza** staging regularmente

```
📝 Develop → 🧪 Test (Staging) → ✅ Review → 🚀 Deploy
                    ↑
                Sync Data
```

## 🔐 Recordatorios de Seguridad

1. **Cambiar contraseña de producción** (fue expuesta)
2. **No commitear `.env.staging`**
3. **Rotar credenciales regularmente**
4. **Usar variables de entorno para secrets**

---

**¿Preguntas?** Ver `STAGING_MIGRATION_GUIDE.md` para detalles técnicos.