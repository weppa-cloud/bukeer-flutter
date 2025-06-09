# 🚀 Getting Started con Maestro Tests

## 📋 Pre-requisitos

1. **Flutter corriendo en Chrome** (para empezar):
   ```bash
   flutter run -d chrome --web-port 3000
   ```

2. **Instalar Maestro** (si no lo has hecho):
   ```bash
   curl -Ls "https://get.maestro.mobile.dev" | bash
   ```

## 🏃 Ejecutar los Tests

### 1️⃣ Test de Login
```bash
# Desde la raíz del proyecto
maestro test maestro/flows/auth/01_login_success.yaml
```

**Qué esperar:**
- La app se abrirá
- Ingresará credenciales automáticamente
- Navegará al dashboard
- Tomará screenshots

**Tiempo:** ~15 segundos

### 2️⃣ Test de Navegación
```bash
maestro test maestro/flows/navigation/01_main_navigation.yaml
```

**Qué esperar:**
- Navegará por todas las secciones principales
- Verificará que cada sección carga
- Tomará screenshots de cada sección

**Tiempo:** ~45 segundos

### 3️⃣ Test de Crear Itinerario
```bash
maestro test maestro/flows/itineraries/01_create_basic_itinerary.yaml
```

**Qué esperar:**
- Navegará a itinerarios
- Creará un nuevo itinerario
- Llenará el formulario
- Verificará la creación

**Tiempo:** ~60 segundos

## 🔍 Modo Debug (Recomendado para empezar)

```bash
# Abre Maestro Studio - interfaz visual
maestro studio

# Luego puedes:
# 1. Arrastrar un archivo .yaml a la ventana
# 2. Ver la ejecución paso a paso
# 3. Pausar y debuggear
```

## ⚙️ Configuración de Variables

### Opción 1: Variables de entorno
```bash
export TEST_EMAIL="tu-email@bukeer.com"
export TEST_PASSWORD="tu-password"
maestro test maestro/flows/auth/01_login_success.yaml
```

### Opción 2: Archivo .env (recomendado)
```bash
# Crear archivo maestro/.env.maestro
echo "TEST_EMAIL=admin@bukeer.com" > maestro/.env.maestro
echo "TEST_PASSWORD=Test123!" >> maestro/.env.maestro

# Ejecutar con el archivo
maestro test --env maestro/.env.maestro maestro/flows/auth/01_login_success.yaml
```

## 🐛 Solución de Problemas Comunes

### "Element not found"
1. Verifica que el texto sea exacto (case sensitive)
2. La app puede estar cargando - aumenta el `timeout`
3. Usa `maestro studio` para inspeccionar elementos

### "Cannot connect to app"
1. Asegúrate que Flutter esté corriendo
2. Para web: `http://localhost:3000`
3. Para móvil: verifica `adb devices`

### Tests muy lentos
1. Usa `--no-ansi` para menos output
2. Ejecuta en modo release: `flutter run -d chrome --release`

## 📸 Screenshots

Los screenshots se guardan en:
```
maestro/screenshots/
├── 01_login_screen.png
├── 02_login_success_dashboard.png
├── nav_01_itinerarios.png
├── nav_02_productos.png
└── ...
```

## 🎯 Próximos Pasos

1. **Personalizar tests** con tus credenciales
2. **Agregar más validaciones** específicas de tu app
3. **Crear tests para tus flujos críticos**
4. **Integrar con CI/CD** (GitHub Actions)

## 💡 Tips

- Empieza con `maestro studio` para entender cómo funciona
- Los tests son archivos YAML - puedes editarlos fácilmente
- Usa `takeScreenshot` liberalmente para documentación
- Los `anyOf` hacen los tests más robustos
- `waitForAnimationToEnd` es tu amigo

¿Problemas? Revisa:
- Los logs en la terminal
- Los screenshots generados
- La documentación: https://maestro.mobile.dev