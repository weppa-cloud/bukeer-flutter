# Sistema de Configuración Runtime - Bukeer

## Descripción

Este sistema permite manejar la configuración de la aplicación Bukeer de manera segura y flexible, sin necesidad de reconstruir la aplicación cuando cambian las variables de entorno. Es especialmente útil para despliegues en producción donde las API keys y configuraciones pueden variar.

## Características

✅ **Configuración Runtime**: Carga configuración desde JavaScript sin reconstruir  
✅ **Seguridad**: API keys no se incluyen en el código fuente  
✅ **Fallbacks**: Configuración por defecto si falla la carga  
✅ **Validación**: Verificación automática de campos requeridos  
✅ **Feature Flags**: Control de funcionalidades sin cambios de código  
✅ **Multi-entorno**: Soporte para development, staging y production  
✅ **Debug Friendly**: Logs detallados en modo desarrollo  

## Estructura de Archivos

```
web/
├── config.js              # Configuración actual (NO se versiona)
├── config.example.js       # Plantilla de configuración
└── index.html             # Carga config.js automáticamente

lib/config/
└── app_config.dart        # Clase que lee la configuración
```

## Configuración

### 1. Crear archivo de configuración

```bash
# Copiar plantilla
cp web/config.example.js web/config.js

# Editar con valores reales
nano web/config.js
```

### 2. Estructura del config.js

```javascript
window.BukeerConfig = {
  // Configuración requerida
  supabaseUrl: 'https://your-project.supabase.co',
  supabaseAnonKey: 'your-supabase-anon-key',
  apiBaseUrl: 'https://your-api.example.com/api',
  googleMapsApiKey: 'your-google-maps-api-key',
  
  // Entorno
  environment: 'production', // 'development' | 'staging' | 'production'
  
  // Feature Flags (opcional)
  features: {
    enableAnalytics: true,
    enableDebugLogs: false,
    enableOfflineMode: false
  },
  
  // Configuraciones adicionales (opcional)
  settings: {
    sessionTimeout: 3600000,  // 1 hora
    maxRetries: 3,
    requestTimeout: 30000     // 30 segundos
  }
};
```

## Uso en Código Dart

### Inicialización (automática en main.dart)

```dart
import 'package:bukeer/config/app_config.dart';

void main() async {
  // Se inicializa automáticamente al arrancar la app
  AppConfig.initialize();
  
  // El resto de la inicialización...
}
```

### Acceder a configuración

```dart
// Configuración básica
final supabaseUrl = AppConfig.supabaseUrl;
final apiKey = AppConfig.supabaseAnonKey;
final apiBaseUrl = AppConfig.apiBaseUrl;
final mapsKey = AppConfig.googleMapsApiKey;

// Entorno
if (AppConfig.isProduction) {
  // Lógica de producción
} else if (AppConfig.isDevelopment) {
  // Lógica de desarrollo
}

// Feature flags
if (AppConfig.enableAnalytics) {
  // Inicializar analytics
}

if (AppConfig.enableDebugLogs) {
  print('Debug mode enabled');
}

// Settings
final timeout = AppConfig.requestTimeout;
final retries = AppConfig.maxRetries;
```

### Validación

```dart
// Verificar que la configuración es válida
if (!AppConfig.isConfigValid) {
  throw Exception('Configuración inválida');
}

// Log de configuración (solo en debug)
AppConfig.logConfig();
```

## Despliegue

### Desarrollo Local

1. Copiar `config.example.js` a `config.js`
2. Configurar con valores de desarrollo
3. Ejecutar `flutter run -d chrome`

### Staging

1. En el servidor de staging, crear `web/config.js` con valores de staging
2. Configurar `environment: 'staging'`
3. Desplegar archivos web

### Producción

1. En el servidor de producción, crear `web/config.js` con valores reales
2. Configurar `environment: 'production'`
3. Asegurar que las API keys sean correctas
4. Desplegar

### CI/CD Pipeline

```yaml
# Ejemplo para GitHub Actions
- name: Create production config
  run: |
    cat > web/config.js << EOF
    window.BukeerConfig = {
      supabaseUrl: '${{ secrets.SUPABASE_URL }}',
      supabaseAnonKey: '${{ secrets.SUPABASE_ANON_KEY }}',
      apiBaseUrl: '${{ secrets.API_BASE_URL }}',
      googleMapsApiKey: '${{ secrets.GOOGLE_MAPS_API_KEY }}',
      environment: 'production',
      features: {
        enableAnalytics: true,
        enableDebugLogs: false,
        enableOfflineMode: false
      }
    };
    EOF

- name: Build Flutter Web
  run: flutter build web
```

## Ventajas del Sistema

### ✅ Seguridad
- API keys no están en el código fuente
- No se versionan en Git
- Diferentes valores por entorno

### ✅ Flexibilidad
- Cambiar configuración sin reconstruir
- Feature flags dinámicos
- Configuración específica por servidor

### ✅ Mantenibilidad
- Configuración centralizada
- Validación automática
- Logs de debug informativos

### ✅ Escalabilidad
- Soporte multi-entorno
- Fácil integración con CI/CD
- Configuración de fallback

## Troubleshooting

### Error: "BukeerConfig not found"

```
Warning: BukeerConfig not found in JavaScript. Using fallback configuration.
```

**Solución**: Verificar que `web/config.js` existe y es válido.

### Error: "Invalid configuration"

```
Exception: Invalid configuration: Missing required fields
```

**Solución**: Verificar que todos los campos requeridos están en `config.js`:
- `supabaseUrl`
- `supabaseAnonKey` 
- `apiBaseUrl`
- `googleMapsApiKey`

### Google Maps no carga

**Solución**: Verificar que el Google Maps API key en `config.js` es válido y tiene los permisos correctos.

### Configuración no se actualiza

1. Limpiar caché del navegador
2. Verificar que `config.js` se está cargando (Network tab en DevTools)
3. Ejecutar `AppConfig.reset()` y `AppConfig.initialize()` si es necesario

## Testing

```bash
# Ejecutar test de configuración
dart test_runtime_config.dart

# Verificar que la configuración es válida
flutter run lib/main.dart
```

## Migración desde Variables de Entorno

Si tu aplicación usa variables de entorno (--dart-define), puedes migrar así:

1. Crear `web/config.js` con los valores actuales
2. Verificar que `AppConfig.initialize()` se llama en `main.dart`
3. Probar que la aplicación funciona correctamente
4. Remover las variables de entorno del proceso de build

## Archivos Importantes

- `web/config.js` - Configuración actual (NO versionar)
- `web/config.example.js` - Plantilla y documentación
- `lib/config/app_config.dart` - Clase de configuración
- `web/index.html` - Carga automática de config.js
- `.gitignore` - Excluye config.js del control de versiones

## Soporte

Para problemas o preguntas sobre el sistema de configuración:

1. Verificar que `config.js` existe y es válido
2. Revisar logs de debug en la consola
3. Ejecutar el script de test: `dart test_runtime_config.dart`
4. Verificar la documentación en `config.example.js`