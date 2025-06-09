# Guía de Contribución - Proyecto Bukeer

## 🚀 Bienvenido al equipo de desarrollo de Bukeer

Esta guía te ayudará a mantener la calidad del código y seguir las mejores prácticas establecidas para el proyecto.

## 📋 Tabla de Contenidos

1. [Estructura del Proyecto](#estructura-del-proyecto)
2. [Convenciones de Código](#convenciones-de-código)
3. [Flujo de Trabajo](#flujo-de-trabajo)
4. [Creación de Componentes](#creación-de-componentes)
5. [Gestión de Estado](#gestión-de-estado)
6. [Testing](#testing)
7. [Commits y Pull Requests](#commits-y-pull-requests)

## 🏗️ Estructura del Proyecto

### Organización de Carpetas

```
lib/
├── bukeer/
│   ├── core/               # Componentes compartidos
│   │   └── widgets/
│   │       ├── navigation/ # Componentes de navegación
│   │       ├── forms/      # Componentes de formulario
│   │       ├── buttons/    # Botones reutilizables
│   │       └── index.dart  # Exports centralizados
│   │
│   ├── [feature]/          # Módulos de negocio
│   │   ├── pages/          # Páginas principales (main_*)
│   │   ├── widgets/        # Widgets específicos del módulo
│   │   ├── modals/         # Componentes modales
│   │   └── sections/       # Secciones complejas
│   │
│   └── examples/           # Demos y ejemplos
│
├── services/               # Servicios de la aplicación
├── navigation/             # Configuración de rutas
└── design_system/          # Sistema de diseño
```

### ¿Dónde colocar nuevos componentes?

1. **Componentes compartidos** → `/core/widgets/[tipo]/`
   - Usados en múltiples módulos
   - Sin lógica de negocio específica
   - Ejemplo: botones, inputs, navegación

2. **Componentes específicos** → `/[módulo]/widgets/`
   - Usados solo en un módulo
   - Con lógica de negocio específica
   - Ejemplo: `activities_container` en productos

3. **Páginas principales** → `/[módulo]/pages/`
   - Pantallas completas
   - Prefijo `main_`
   - Ejemplo: `main_products`, `main_contacts`

## 📝 Convenciones de Código

### Nomenclatura

#### Archivos y Carpetas
- **snake_case** para todos los archivos y carpetas
- Sufijos estándar:
  - `_widget.dart` - Componente UI
  - `_model.dart` - Lógica y estado
  - `_test.dart` - Pruebas

#### Clases y Variables
```dart
// Clases - PascalCase
class ActivitiesContainerWidget extends StatefulWidget {}

// Variables - camelCase
final String userName;
bool isLoading = false;

// Constantes - camelCase con prefijo k
const double kDefaultPadding = 16.0;
const String kApiBaseUrl = 'https://api.bukeer.com';
```

### Estructura de un Componente

Cada componente debe tener su propia carpeta con dos archivos:

```
mi_componente/
├── mi_componente_widget.dart  # UI
└── mi_componente_model.dart   # Lógica
```

#### Ejemplo: Widget
```dart
import 'package:flutter/material.dart';
import 'mi_componente_model.dart';
export 'mi_componente_model.dart';

class MiComponenteWidget extends StatefulWidget {
  const MiComponenteWidget({
    super.key,
    required this.titulo,
    this.onTap,
  });

  final String titulo;
  final VoidCallback? onTap;

  @override
  State<MiComponenteWidget> createState() => _MiComponenteWidgetState();
}

class _MiComponenteWidgetState extends State<MiComponenteWidget> {
  late MiComponenteModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MiComponenteModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Tu UI aquí
    );
  }
}
```

#### Ejemplo: Model
```dart
import '/flutter_flow/flutter_flow_model.dart';
import 'mi_componente_widget.dart' show MiComponenteWidget;

class MiComponenteModel extends FlutterFlowModel<MiComponenteWidget> {
  // Estado del componente
  String? selectedValue;
  bool isLoading = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
```

## 🔄 Flujo de Trabajo

### 1. Antes de empezar
```bash
# Actualizar rama principal
git checkout main
git pull origin main

# Crear nueva rama
git checkout -b feature/nombre-descriptivo
```

### 2. Durante el desarrollo
- Ejecuta `flutter analyze` regularmente
- Mantén los imports organizados
- Usa el sistema de exports cuando sea posible

### 3. Antes de hacer commit
```bash
# Verificar análisis
flutter analyze

# Verificar formato
dart format lib/

# Ejecutar tests
flutter test
```

## 🎨 Creación de Componentes

### Componente Compartido (Core)

1. **Crear la estructura**:
```bash
mkdir -p lib/bukeer/core/widgets/[tipo]/mi_componente
```

2. **Crear los archivos**:
- `mi_componente_widget.dart`
- `mi_componente_model.dart`

3. **Actualizar exports**:
```dart
// En lib/bukeer/core/widgets/index.dart
export '[tipo]/mi_componente/mi_componente_widget.dart';
```

### Componente de Módulo

1. **Crear en el módulo correspondiente**:
```bash
mkdir -p lib/bukeer/[modulo]/widgets/mi_componente
```

2. **Seguir la misma estructura de archivos**

## 🏪 Gestión de Estado

### Servicios Globales

Usa los servicios centralizados en lugar de FFAppState:

```dart
import '/services/app_services.dart';

// ✅ Correcto
final userName = appServices.user.getAgentInfo(r'$[:].name');
appServices.ui.searchQuery = 'hotel';

// ❌ Evitar (obsoleto)
FFAppState().searchStringState = 'hotel';
```

### Estado Local

Para estado específico del componente, usa el Model:

```dart
class MiComponenteModel extends FlutterFlowModel<MiComponenteWidget> {
  // Estado local
  String? selectedOption;
  List<String> items = [];
  
  void updateSelection(String value) {
    selectedOption = value;
    // Notificar cambios si es necesario
  }
}
```

## 🧪 Testing

### Estructura de Tests

```
test/
├── widgets/           # Tests de widgets
├── services/          # Tests de servicios
├── integration/       # Tests de integración
└── mocks/            # Mocks compartidos
```

### Ejemplo de Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bukeer/bukeer/core/widgets/buttons/boton_back/boton_back_widget.dart';

void main() {
  group('BotonBackWidget', () {
    testWidgets('muestra ícono de retroceso', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BotonBackWidget(),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
```

## 📤 Commits y Pull Requests

### Formato de Commits

```
tipo(alcance): descripción breve

Descripción detallada (opcional)

Fixes #123
```

**Tipos**:
- `feat`: Nueva funcionalidad
- `fix`: Corrección de bugs
- `refactor`: Refactorización
- `docs`: Documentación
- `test`: Tests
- `style`: Formato de código
- `chore`: Tareas de mantenimiento

**Ejemplos**:
```bash
feat(productos): agregar filtro por categoría
fix(contactos): corregir validación de email
refactor(core): migrar botones a nueva estructura
```

### Pull Request

1. **Título claro y descriptivo**
2. **Descripción que incluya**:
   - Qué cambios se hicieron
   - Por qué se hicieron
   - Cómo probar los cambios
3. **Screenshots** si hay cambios visuales
4. **Referencias** a issues relacionados

## 🚨 Reglas Importantes

1. **NO** modificar archivos en `/flutter_flow/` directamente
2. **NO** hacer commits directos a `main`
3. **NO** incluir archivos `.bak` o temporales
4. **SIEMPRE** usar los servicios centralizados
5. **SIEMPRE** mantener la estructura de carpetas
6. **SIEMPRE** documentar componentes complejos

## 💡 Tips y Mejores Prácticas

1. **Reutilización**: Antes de crear un nuevo componente, verifica si existe uno similar en `/core/widgets/`

2. **Performance**: Usa `const` constructors cuando sea posible

3. **Accesibilidad**: Incluye `Semantics` widgets para mejorar la accesibilidad

4. **Responsive**: Usa `ResponsiveVisibility` para adaptar la UI a diferentes tamaños

5. **Imports**: Prefiere imports relativos dentro del mismo módulo y absolutos para referencias externas

## 🤝 ¿Necesitas Ayuda?

- Revisa la documentación en `ARCHITECTURE.md`
- Consulta ejemplos en `/bukeer/examples/`
- Pregunta al equipo en el canal de desarrollo

---

¡Gracias por contribuir a Bukeer! 🚀