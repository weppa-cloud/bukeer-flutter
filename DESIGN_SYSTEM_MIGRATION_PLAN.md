# 🎨 Plan de Migración del Sistema de Diseño Bukeer

## 📊 Estado Actual (Enero 2025)

### ✅ Completado
- **Design System Base**: Estructura de tokens implementada (colores, espaciado, tipografía, elevación)
- **Componentes Básicos**: BukeerButton, BukeerFAB, BukeerTextField, BukeerModal
- **Layout System**: ResponsiveLayout con breakpoints definidos
- **Herramienta de Migración**: Script automático listo para ejecutar

### 🔄 En Progreso
- **91% de archivos** parcialmente migrados (70/77 archivos usan algunos tokens)
- **74 archivos** aún usan `EdgeInsetsDirectional.fromSTEB` (patrón legacy)
- **40 archivos** aún usan `FFButtonWidget`
- **47 archivos** aún usan TextField/TextFormField sin wrapper

### ❌ Pendiente
- Componentes críticos por crear (BukeerIconButton, BukeerDropdown, etc.)
- Migración completa de componentes FlutterFlow
- Documentación y galería de componentes

## 🎯 Plan de Migración por Fases

### 📅 Fase 1: Migración Automática (1-2 días)
**Objetivo**: Completar la migración de tokens básicos en todos los archivos

#### Paso 1: Ejecutar la herramienta de migración
```bash
# Primero hacer un dry-run para ver los cambios
dart execute_design_system_migration.dart --dry-run

# Si todo se ve bien, ejecutar la migración
dart execute_design_system_migration.dart

# Verificar los cambios
git diff --stat
```

#### Paso 2: Revisar y ajustar archivos críticos
Archivos con más issues que requieren revisión manual:
1. `main_profile_account_widget.dart` (81 issues)
2. `modal_details_contact_widget.dart` (42 issues)
3. `itinerary_payments_section.dart` (44 issues)
4. `modal_details_product_widget.dart` (36 issues)
5. `modal_add_product_widget.dart` (33 issues)

#### Paso 3: Testing post-migración
```bash
# Ejecutar tests existentes
flutter test

# Ejecutar la app y hacer smoke testing visual
flutter run -d chrome
```

### 📅 Fase 2: Componentes Críticos (3-5 días)
**Objetivo**: Crear componentes que reemplacen los más usados de FlutterFlow

#### 🔴 Alta Prioridad

##### 1. BukeerIconButton (30 archivos afectados)
```dart
// lib/design_system/components/buttons/bukeer_icon_button.dart
class BukeerIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Color? color;
  final double? size;
  final String? tooltip;
  // ... implementación con tokens
}
```

##### 2. BukeerDropdown (10 archivos afectados)
```dart
// lib/design_system/components/forms/bukeer_dropdown.dart
class BukeerDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String hint;
  // ... implementación con tokens
}
```

##### 3. BukeerCard (uso generalizado)
```dart
// lib/design_system/components/surfaces/bukeer_card.dart
class BukeerCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  // ... implementación con elevación y espaciado
}
```

#### 🟡 Media Prioridad

##### 4. BukeerChip (status, tags)
```dart
// lib/design_system/components/data_display/bukeer_chip.dart
class BukeerChip extends StatelessWidget {
  final String label;
  final ChipType type; // info, success, warning, error
  final VoidCallback? onDelete;
  // ... implementación con colores semánticos
}
```

##### 5. BukeerTabBar (navegación por tabs)
```dart
// lib/design_system/components/navigation/bukeer_tab_bar.dart
class BukeerTabBar extends StatelessWidget {
  final List<Tab> tabs;
  final TabController controller;
  // ... implementación consistente
}
```

### 📅 Fase 3: Migración de Componentes (5-7 días)
**Objetivo**: Reemplazar componentes FlutterFlow en toda la aplicación

#### Estrategia de Migración por Componente

##### 1. FFButtonWidget → BukeerButton
```bash
# Buscar todos los usos
grep -r "FFButtonWidget" lib/ --include="*.dart" | wc -l
# 40 archivos

# Priorizar por módulo:
# - Itinerarios (15 archivos)
# - Productos (10 archivos)
# - Contactos (8 archivos)
# - Dashboard (7 archivos)
```

##### 2. FlutterFlowIconButton → BukeerIconButton
```bash
# Similar proceso, 30 archivos afectados
# Muchos en componentes de navegación y acciones
```

##### 3. TextField/TextFormField → BukeerTextField
```bash
# 47 archivos - ya existe el componente
# Solo necesita adopción masiva
```

### 📅 Fase 4: Componentes Avanzados (3-4 días)
**Objetivo**: Crear componentes especializados para funcionalidades específicas

#### 🟢 Baja Prioridad (pero útiles)

##### 1. BukeerDatePicker
- Reemplazar `ComponentDateWidget`
- Integrar con formato de fechas consistente

##### 2. BukeerPlacePicker
- Reemplazar `FlutterFlowPlacePicker`
- Mantener integración con Google Places

##### 3. BukeerCountController
- Reemplazar `FlutterFlowCountController`
- Para cantidades y números

##### 4. BukeerAutocomplete
- Para búsquedas con sugerencias
- Útil en dropdowns de contactos/productos

### 📅 Fase 5: Documentación y Tooling (2-3 días)
**Objetivo**: Facilitar la adopción del sistema de diseño

#### 1. Documentación de Componentes
```markdown
# Para cada componente crear:
- Descripción y uso
- Props disponibles
- Ejemplos de código
- Screenshots
- Do's and Don'ts
```

#### 2. Galería de Componentes
```dart
// lib/design_system/gallery/gallery_app.dart
// App standalone para ver todos los componentes
// Con ejemplos interactivos y código
```

#### 3. Snippets para VSCode
```json
// .vscode/bukeer-snippets.json
{
  "Bukeer Button": {
    "prefix": "bkbutton",
    "body": [
      "BukeerButton(",
      "  text: '$1',",
      "  onPressed: () {",
      "    $2",
      "  },",
      ")"
    ]
  }
}
```

## 📈 Métricas de Éxito

### KPIs de la Migración
1. **Cobertura**: 100% de archivos usando design tokens
2. **Adopción**: 0 usos de componentes FlutterFlow legacy
3. **Consistencia**: 100% de spacing usando BukeerSpacing
4. **Performance**: Sin regresiones en tiempo de build/runtime
5. **DX**: Reducción del 50% en tiempo de desarrollo de UI

### Checklist Final
- [ ] Todos los archivos migrados a design tokens
- [ ] Todos los componentes FlutterFlow reemplazados
- [ ] Documentación completa de componentes
- [ ] Galería de componentes funcional
- [ ] Tests de regresión visual
- [ ] Guía de migración para el equipo
- [ ] Snippets y tooling configurado

## 🚀 Quick Start para Comenzar

```bash
# 1. Crear branch de migración
git checkout -b feat/design-system-migration

# 2. Ejecutar migración automática
dart execute_design_system_migration.dart

# 3. Verificar y commitear
flutter test
git add .
git commit -m "feat: complete design tokens migration"

# 4. Comenzar con primer componente
# Crear BukeerIconButton siguiendo el patrón de BukeerButton
```

## 📚 Recursos

- **Design System Docs**: `/lib/design_system/README.md`
- **Migration Helper**: `/lib/design_system/tools/migration_helper.dart`
- **Tokens Reference**: `/lib/design_system/tokens/`
- **Component Examples**: `/lib/design_system/components/`

## ⚠️ Consideraciones Importantes

1. **Backward Compatibility**: Mantener componentes FlutterFlow mientras se migra
2. **Testing**: Cada fase debe incluir testing exhaustivo
3. **Performance**: Monitorear que no haya regresiones
4. **Team Training**: Capacitar al equipo en el nuevo sistema
5. **Gradual Rollout**: Migrar por módulos, no todo de golpe

---

**Tiempo Total Estimado**: 15-20 días de desarrollo
**Impacto**: Alto - mejora significativa en consistencia y mantenibilidad
**Riesgo**: Medio - mitigado por migración gradual y testing