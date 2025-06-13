# 👨‍💻 Junior Developer Onboarding - Bukeer

## 🎯 Objetivo
Ponerte productivo en **3 días** usando el flujo automatizado con `flow.sh`.

## 📋 Día 1: Setup y Exploración

### Mañana (2-3 horas)
1. **Leer documentación esencial:**
   - [Quick Start Guide](../01-getting-started/quick-start.md) - 15 min
   - [Development Workflow](../02-development/workflow.md) - 30 min
   - Este documento completo - 15 min

2. **Setup inicial:**
   ```bash
   # Clonar y configurar
   git clone https://github.com/weppa-cloud/bukeer-flutter.git
   cd bukeer-flutter
   chmod +x flow.sh
   flutter pub get
   
   # Verificar que funciona
   ./flow.sh run
   ```

3. **Explorar la aplicación:**
   - Login con: `admin@staging.com` / `password123`
   - Navegar por todos los módulos
   - Identificar: Dashboard, Itinerarios, Productos, Contactos

### Tarde (2-3 horas)
4. **Primer ejercicio guiado:**
   ```bash
   # Crear tu primera rama
   ./flow.sh dev mi-primer-cambio
   
   # Hacer un cambio simple (ej: corregir un typo)
   # En cualquier archivo .dart, busca un texto y cámbialo
   
   # Guardar y crear PR
   ./flow.sh save "fix: corregir typo en dashboard"
   ./flow.sh test
   ./flow.sh pr
   ```

## 📋 Día 2: Sistema de Diseño

### Mañana
1. **Estudiar el sistema de diseño:**
   - Leer [DESIGN_SYSTEM_MIGRATION.md](../../DESIGN_SYSTEM_MIGRATION.md)
   - Abrir `/lib/design_system/` y explorar tokens

2. **Ejercicio práctico:**
   ```bash
   ./flow.sh dev migrar-componente-colores
   ```
   
   Buscar un archivo que use `FlutterFlowTheme` y migrarlo:
   ```dart
   // ❌ Cambiar esto:
   color: FlutterFlowTheme.of(context).primary
   
   // ✅ Por esto:
   color: BukeerColors.primary
   ```

### Tarde
3. **Crear un componente nuevo:**
   ```bash
   ./flow.sh dev crear-boton-personalizado
   ```
   - Crear en `/lib/bukeer/core/widgets/buttons/`
   - Usar SOLO tokens del design system
   - Incluir dark mode support

## 📋 Día 3: Feature Completa

### Todo el día
1. **Implementar una feature pequeña:**
   ```bash
   ./flow.sh dev agregar-contador-items
   ```
   
   Ejemplo: Agregar un contador de items en alguna lista
   - Identificar dónde agregarlo
   - Usar AppServices para el estado
   - Aplicar diseño consistente
   - Probar en dark/light mode

## 🛡️ Reglas de Seguridad CRÍTICAS

### ❌ NUNCA hacer:
```dart
// PROHIBIDO - API Keys
const apiKey = "sk-real-api-key-here";

// PROHIBIDO - URLs hardcodeadas  
const prodUrl = "https://api.produccion.com";

// PROHIBIDO - Credenciales
const password = "admin123";

// PROHIBIDO - Sistema viejo
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
```

### ✅ SIEMPRE hacer:
```dart
// Configuración externa
final config = window.BukeerConfig;

// Sistema de diseño nuevo
import 'package:bukeer/design_system/index.dart';

// Servicios centralizados
final user = appServices.user.currentUser;
```

## 🚨 Cuándo Pedir Ayuda INMEDIATAMENTE

1. **Si ves o necesitas agregar:**
   - Cualquier API key o token
   - URLs de producción
   - Información sensible

2. **Si necesitas modificar:**
   - Archivos en `/backend/`
   - `pubspec.yaml`
   - Configuraciones de Firebase/Supabase

3. **Si encuentras:**
   - Errores que no entiendes
   - Código que parece manejar pagos/seguridad
   - Archivos que dicen "NO MODIFICAR"

## 📝 Checklist Diario

### Inicio del día:
- [ ] `./flow.sh sync` - Actualizar código
- [ ] `./flow.sh status` - Ver estado
- [ ] Revisar tareas asignadas en el board

### Durante desarrollo:
- [ ] `./flow.sh save` cada hora
- [ ] NO usar FlutterFlowTheme
- [ ] Usar BukeerColors, BukeerTypography, etc.
- [ ] Probar en Chrome

### Antes de terminar:
- [ ] `./flow.sh test` pasa sin errores
- [ ] `./flow.sh pr` creado
- [ ] Notificar al Tech Lead

## 🎯 Métricas de Éxito (Primera Semana)

- [ ] 3+ PRs creados
- [ ] 0 uso de FlutterFlowTheme en código nuevo
- [ ] 0 información sensible commiteada
- [ ] 1+ componente migrado al design system
- [ ] Todo desarrollo usando flow.sh

## 🔧 Comandos Rápidos de Referencia

```bash
# Desarrollo diario
./flow.sh dev nombre-feature  # Nueva rama
./flow.sh run                # Ejecutar app
./flow.sh save              # Guardar cambios
./flow.sh test              # Validar
./flow.sh pr                # Pull Request

# Utilidades
./flow.sh sync              # Actualizar desde main
./flow.sh status            # Ver estado actual
./flow.sh help              # Ver ayuda
```

## 📚 Recursos Adicionales

1. **Documentación técnica:**
   - [Arquitectura](../../ARCHITECTURE.md)
   - [Testing Guide](../../TESTING_GUIDE.md)
   - [Performance Guide](../../PERFORMANCE_GUIDE.md)

2. **Cuando domines lo básico:**
   - Explorar `/lib/services/` para entender AppServices
   - Leer sobre el sistema de navegación GoRouter
   - Aprender sobre Supabase y las APIs

## 💬 Comunicación

- **Dudas técnicas**: Mensaje directo al Tech Lead
- **Bloqueos**: Pedir videollamada de 15 min
- **Code review**: Comentarios en el PR
- **Daily standup**: Compartir qué hiciste/harás/bloqueos

---

**Recuerda**: Es mejor preguntar 10 veces que romper 1 cosa. ¡Bienvenido al equipo! 🚀