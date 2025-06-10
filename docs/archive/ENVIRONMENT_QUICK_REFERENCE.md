# 🚀 Referencia Rápida de Entornos - Bukeer

## Comandos Esenciales

### 🏃‍♂️ Ejecutar la App
```bash
# Desarrollo (staging como backend)
flutter run -d chrome

# Staging
./run_staging.sh

# Producción (solo verificar)
flutter run -d chrome --dart-define=ENVIRONMENT=production
```

### 🔧 Operaciones Comunes
```bash
# Backup de producción
./scripts/backup_production.sh

# Migrar estructura a staging
./scripts/migrate_to_staging.sh

# Ver logs
flutter logs
```

## 📊 Dashboard Links

| Entorno | Dashboard | Project ID |
|---------|-----------|------------|
| **Producción** | [Abrir Dashboard](https://supabase.com/dashboard/project/wzlxbpicdcdvxvdcvgas) | wzlxbpicdcdvxvdcvgas |
| **Staging** | [Abrir Dashboard](https://supabase.com/dashboard/project/wrgkiastpqituocblopg) | wrgkiastpqituocblopg |

## 🌐 URLs de API

| Entorno | URL Base |
|---------|----------|
| **Producción** | https://wzlxbpicdcdvxvdcvgas.supabase.co |
| **Staging** | https://wrgkiastpqituocblopg.supabase.co |
| **Local** | http://localhost:5000 |

## ⚡ Tips Rápidos

1. **¿En qué entorno estoy?**
   - Mira la URL en el navegador
   - O revisa la consola: busca "Environment:" en los logs

2. **¿Cómo cambio de entorno?**
   - Detén la app (Ctrl+C)
   - Ejecuta el comando del entorno deseado

3. **¿Dónde están las credenciales completas?**
   - `ENVIRONMENT_CREDENTIALS.md` (no subir a Git)

4. **¿Cómo verifico la conexión?**
   - La app muestra el entorno al iniciar
   - Revisa Network tab en Chrome DevTools

## 🚦 Reglas de Oro

- ✅ **Desarrolla** en Local/Staging
- ⚠️ **Prueba** en Staging
- 🚫 **NO cambies** directamente en Producción
- 💾 **Backup** antes de cambios importantes

## 🆘 Ayuda Rápida

```bash
# Ver este archivo
cat ENVIRONMENT_QUICK_REFERENCE.md

# Ver credenciales completas
cat ENVIRONMENT_CREDENTIALS.md

# Ver documentación de staging
cat STAGING_SETUP_GUIDE.md
```