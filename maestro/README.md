# 🎭 Maestro E2E Tests para Bukeer

## 📋 Descripción
Tests E2E automatizados usando Maestro para la aplicación Bukeer. Estos tests verifican flujos completos de usuario sin necesidad de modificar el código de la aplicación.

## 🚀 Instalación

### 1. Instalar Maestro
```bash
# En macOS/Linux
curl -Ls "https://get.maestro.mobile.dev" | bash

# Verificar instalación
maestro --version
```

### 2. Configurar el Proyecto
```bash
# Navegar al directorio del proyecto
cd bukeer-flutter

# Probar que Maestro funciona
maestro studio
```

## 📁 Estructura
```
maestro/
├── flows/
│   ├── auth/           # Tests de autenticación
│   ├── navigation/     # Tests de navegación
│   └── itineraries/    # Tests de itinerarios
├── config/            # Configuraciones
└── utils/             # Utilidades compartidas
```

## 🏃 Ejecutar Tests

### Test Individual
```bash
maestro test maestro/flows/auth/01_login_success.yaml
```

### Todos los Tests de un Flujo
```bash
maestro test maestro/flows/auth/
```

### Todos los Tests
```bash
maestro test maestro/flows/
```

### Modo Debug (Studio)
```bash
maestro studio
```

## 📊 Tests Disponibles

### ✅ Auth (Autenticación)
- `01_login_success.yaml` - Login exitoso con credenciales válidas
- `02_login_failure.yaml` - Manejo de errores de login

### ✅ Navigation (Navegación)
- `01_main_navigation.yaml` - Navegación por secciones principales

### ✅ Itineraries (Itinerarios)
- `01_create_basic_itinerary.yaml` - Crear itinerario básico

## 🔧 Configuración

### Variables de Entorno
Crear archivo `.env.maestro` (no commitear):
```bash
TEST_EMAIL=test@bukeer.com
TEST_PASSWORD=Test123!
BASE_URL=http://localhost:3000
```

### Ejecución con Variables
```bash
maestro test --env .env.maestro maestro/flows/
```

## 🐛 Troubleshooting

### El test no encuentra un elemento
1. Verificar que el texto sea exacto
2. Usar `maestro studio` para inspeccionar
3. Agregar `waitForAnimationToEnd` si hay animaciones

### Tests muy lentos
1. Reducir `timeout` en asserts
2. Usar `waitUntilVisible` en lugar de delays fijos
3. Ejecutar en modo release del app

### Error de conexión
1. Verificar que la app esté corriendo
2. Para web: `flutter run -d chrome --web-port 3000`
3. Para móvil: verificar adb/simulador

## 📚 Recursos
- [Documentación Oficial](https://maestro.mobile.dev/docs)
- [Ejemplos](https://github.com/mobile-dev-inc/maestro/tree/main/examples)
- [Discord Community](https://discord.gg/aaa)