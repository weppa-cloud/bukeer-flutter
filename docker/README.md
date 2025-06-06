# Docker Configuration - Bukeer

Esta carpeta contiene todos los archivos relacionados con Docker y deployment.

## Archivos

### Dockerfiles
- **`Dockerfile.caprover`** - Dockerfile principal para CapRover production deployment ✅
- **`Dockerfile`** - Dockerfile básico/general
- **`Dockerfile.simple`** - Dockerfile simplificado para testing

### Configuración
- **`.dockerignore`** - Archivos excluidos del contexto Docker

## Uso

### Deployment con CapRover
El deployment principal usa `Dockerfile.caprover` automáticamente via:
- `captain-definition` (en root) → apunta a `./docker/Dockerfile.caprover`
- Push a rama `main` → trigger automático de CapRover

### Build Local
```bash
# Build para CapRover (recomendado)
docker build -f docker/Dockerfile.caprover -t bukeer:caprover .

# Build básico
docker build -f docker/Dockerfile -t bukeer:basic .

# Build simple
docker build -f docker/Dockerfile.simple -t bukeer:simple .

# Ejecutar localmente
docker run -p 8080:80 bukeer:caprover
```

### Variables de Entorno (CapRover)
```bash
supabaseUrl=https://wzlxbpicdcdvxvdcvgas.supabase.co
supabaseAnonKey=eyJhbGciOiJIUzI1NiIs...
apiBaseUrl=https://wzlxbpicdcdvxvdcvgas.supabase.co/rest/v1
googleMapsApiKey=AIzaSyDEUekXeyIKJUreRydJyv05gCexdSjUdBc
environment=production
```

## Notas
- **CapRover**: Sistema de deployment principal
- **Flutter 3.32**: Versión usada en builds de producción
- **Nginx**: Servidor web para servir archivos estáticos
- **Multi-stage**: Optimización de tamaño de imagen final