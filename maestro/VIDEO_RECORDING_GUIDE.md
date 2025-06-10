# 🎥 Guía de Grabación de Videos con Maestro

## 📋 Descripción

Maestro puede grabar videos de la ejecución de tests, lo cual es extremadamente útil para:
- Debugging de tests que fallan
- Documentación visual de flujos
- Revisión de código en PRs
- Reportes de QA

## 🛠️ Configuración

### 1. Configuración Global (`maestro.yaml`)

```yaml
video:
  enabled: true
  quality: "high"        # low, medium, high
  format: "mp4"
  saveOnSuccess: false   # No guardar videos de tests exitosos
  saveOnFailure: true    # Guardar videos cuando fallan
```

### 2. Variables de Entorno (`.env.maestro`)

```bash
ENABLE_VIDEO_RECORDING=true
VIDEO_QUALITY=high
VIDEO_SAVE_ON_SUCCESS=false
VIDEO_SAVE_ON_FAILURE=true
```

## 🎬 Comandos para Grabar Videos

### Grabar Todos los Tests
```bash
# Con configuración por defecto
npm run maestro:test:video

# Alta calidad para todos los tests
npm run maestro:test:video:all
```

### Grabar Test Específico
```bash
# Un solo test
cd maestro && maestro test --video flows/auth/01_login_success.yaml

# Con calidad específica
cd maestro && maestro test --video --video-quality=high flows/e2e/01_complete_itinerary_flow.yaml
```

### Grabar por Categoría
```bash
# Solo tests smoke con video
cd maestro && maestro test --video --tags=smoke flows/

# Tests de un módulo específico
cd maestro && maestro test --video flows/products/
```

## 📁 Ubicación de Videos

Los videos se guardan en:
```
maestro/
├── .maestro/
│   └── tests/
│       └── [timestamp]/
│           ├── video.mp4
│           └── logs/
└── recordings/     # Si se configura output personalizado
```

## ⚙️ Opciones de Grabación

### Calidad de Video
- `low` - Baja calidad, archivos pequeños (~5MB/min)
- `medium` - Calidad media, balance (~15MB/min)
- `high` - Alta calidad, archivos grandes (~30MB/min)

### Configuración por Test
Puedes sobrescribir la configuración en tests individuales:

```yaml
# En cualquier test .yaml
appId: com.bukeer.app
name: "Test con Video HD"
video:
  enabled: true
  quality: high
---
# Resto del test...
```

## 🚀 Casos de Uso

### 1. Debugging de Fallos
```bash
# Ejecutar test problemático con video
cd maestro && maestro test --video --debug flows/payments/03_payment_calculations.yaml
```

### 2. Documentación de Features
```bash
# Grabar demo de nueva funcionalidad
cd maestro && maestro test --video --video-quality=high flows/e2e/01_complete_itinerary_flow.yaml
```

### 3. CI/CD Pipeline
En GitHub Actions ya está configurado para grabar videos cuando fallan:

```yaml
- name: Run Maestro tests
  run: |
    cd maestro
    maestro test --video flows/
  env:
    MAESTRO_VIDEO_ON_FAILURE: true
```

## 📊 Gestión de Espacio

### Limpiar Videos Antiguos
```bash
# Limpiar todos los resultados (incluye videos)
npm run maestro:clean

# Solo videos antiguos (más de 7 días)
find maestro/.maestro/tests -name "*.mp4" -mtime +7 -delete
```

### Comprimir Videos
```bash
# Comprimir videos existentes con ffmpeg
find maestro/.maestro -name "*.mp4" -exec ffmpeg -i {} -vcodec h264 -acodec aac {}.compressed.mp4 \;
```

## 🔍 Visualización de Videos

### En Local
- Los videos son archivos MP4 estándar
- Puedes abrirlos con cualquier reproductor
- En macOS: `open maestro/.maestro/tests/*/video.mp4`

### En CI/CD
- Los videos se suben como artifacts
- Descargables desde la página de Actions
- Se eliminan automáticamente después de 90 días

## 💡 Tips y Mejores Prácticas

1. **Usa video solo cuando sea necesario** - Los videos consumen espacio y tiempo
2. **Configura `saveOnSuccess: false`** - No necesitas videos de tests exitosos
3. **Alta calidad para demos** - Usa `high` quality para documentación
4. **Baja calidad para CI** - Usa `low` quality en pipelines para ahorrar espacio
5. **Revisa videos de fallos** - Siempre revisa el video cuando un test falla

## 🐛 Troubleshooting

### Video no se genera
```bash
# Verificar que Maestro tenga permisos
maestro studio  # Debe poder acceder a la pantalla

# Forzar grabación
cd maestro && maestro test --video --force-video flows/auth/01_login_success.yaml
```

### Videos muy grandes
```bash
# Usar menor calidad
cd maestro && maestro test --video --video-quality=low flows/

# Comprimir después
ffmpeg -i video.mp4 -vcodec h264 -crf 28 video_compressed.mp4
```

### No se ven en CI
- Verificar que los artifacts se suban correctamente
- Revisar los logs de GitHub Actions
- Asegurar que `upload-artifact` incluya la ruta de videos

## 📚 Referencias

- [Documentación oficial de Maestro Video](https://maestro.mobile.dev/cli/test-suites-and-reports#recording-flow-videos)
- [FFmpeg para post-procesamiento](https://ffmpeg.org/documentation.html)