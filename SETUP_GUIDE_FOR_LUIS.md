# 🚀 Guía de Setup para Luis - Proyecto Bukeer

## 1. Clonar el Repositorio

```bash
# Clonar el proyecto
git clone https://github.com/weppa-cloud/bukeer-flutter.git
cd bukeer-flutter
```

## 2. Prerequisitos

Asegúrate de tener instalado:
- **Flutter 3.32.0** o superior
- **Dart 3.4.0** o superior  
- **Git**
- **VS Code** o Android Studio
- **Chrome** (para desarrollo web)

```bash
# Verificar instalación
flutter --version
dart --version
```

## 3. Configurar Variables de Entorno

```bash
# Copiar el archivo de ejemplo
cp .env.example .env

# Pedir a Yeison las credenciales reales para:
# - SUPABASE_URL
# - SUPABASE_ANON_KEY
# - GOOGLE_MAPS_API_KEY
```

## 4. Instalar Dependencias

```bash
# Instalar paquetes de Flutter
flutter pub get

# Instalar dependencias de Node (para tests)
npm install
```

## 5. Configurar Git

```bash
# Configurar tu información
git config user.name "Tu Nombre"
git config user.email "tu-email@ejemplo.com"

# Configurar hooks de git
./scripts/setup_git_hooks.sh
```

## 6. Ejecutar el Proyecto

### Desarrollo Local (sin base de datos)
```bash
flutter run -d chrome
```

### Desarrollo con Staging (datos reales)
```bash
flutter run -d chrome --dart-define=ENVIRONMENT=staging

# Credenciales de staging:
# Email: admin@staging.com
# Password: password123
```

## 7. Flujo de Trabajo

### Crear una nueva feature
```bash
# Actualizar main
git checkout main
git pull origin main

# Crear branch
git checkout -b feature/nombre-descriptivo

# Desarrollar...

# Commit
git add .
git commit -m "feat: descripción de lo que hiciste"

# Push
git push -u origin feature/nombre-descriptivo

# Crear Pull Request en GitHub
```

## 8. Estructura del Proyecto

```
lib/
├── bukeer/          # Módulos principales
│   ├── itinerarios/ # Gestión de itinerarios
│   ├── productos/   # Productos turísticos
│   ├── contactos/   # Clientes y cuentas
│   └── dashboard/   # Reportes
├── services/        # Servicios centralizados
├── design_system/   # Sistema de diseño
└── navigation/      # Rutas y navegación
```

## 9. Documentación Importante

Lee estos archivos para entender mejor el proyecto:
- `/README.md` - Información general
- `/docs/ARCHITECTURE.md` - Arquitectura completa
- `/docs/CONTRIBUTING.md` - Guía de contribución
- `/docs/CLAUDE.md` - Resumen técnico del proyecto

## 10. Comandos Útiles

```bash
# Análisis de código
flutter analyze

# Ejecutar tests
flutter test

# Formatear código
dart format lib/

# Build para web
flutter build web
```

## 11. Servicios Principales

```dart
// Acceder a servicios globales
import '/services/app_services.dart';

final appServices = AppServices();

// Servicios disponibles:
appServices.ui        // Estado de UI
appServices.user      // Datos de usuario
appServices.product   // Productos
appServices.itinerary // Itinerarios
```

## 12. Tips para Empezar

1. **Explora el código**: Empieza por `/lib/bukeer/` para ver los módulos
2. **Lee la documentación**: Especialmente ARCHITECTURE.md
3. **Usa el sistema de diseño**: Importa desde `/design_system/`
4. **Sigue las convenciones**: snake_case para archivos, PascalCase para clases
5. **Pregunta cuando tengas dudas**: Es mejor preguntar que romper algo

## 13. Contacto

Si tienes dudas:
- Pregúntale a Yeison directamente
- Revisa la documentación en `/docs/`
- Mira ejemplos en el código existente

## ⚠️ Importante

- **NO** commitees directamente a `main`
- **NO** subas archivos `.env` con credenciales
- **NO** modifiques archivos en `/flutter_flow/` (legacy)
- **SIEMPRE** crea un branch para tus cambios
- **SIEMPRE** haz pull request para revisión

¡Bienvenido al equipo! 🎉