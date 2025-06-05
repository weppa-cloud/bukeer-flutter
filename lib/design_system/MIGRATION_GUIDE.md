# 🎨 Bukeer Design System - Guía de Migración

## 📋 Resumen

Esta guía te ayudará a migrar componentes existentes del proyecto Bukeer para usar el nuevo sistema de diseño estandarizado. El objetivo es reemplazar código inconsistente generado por FlutterFlow con componentes unificados y mantenibles.

## 🔄 Antes vs Después

### ❌ Problemas del código actual:
- 188+ archivos con valores hardcodeados (`EdgeInsetsDirectional.fromSTEB`)
- Múltiples implementaciones de botones inconsistentes
- Navegación web/mobile con diferentes fuentes de datos
- Modales con tamaños y estilos variables
- Campos de formulario sin estandarización
- Sin sistema responsive coherente

### ✅ Beneficios del nuevo sistema:
- Componentes estandarizados y reutilizables
- Tokens de diseño para consistencia visual
- Sistema responsive integrado
- Mantenimiento centralizado
- Mejor accesibilidad y UX

---

## 🎯 Plan de Migración por Prioridad

### 🔥 Alta Prioridad
1. **Design Tokens** - Reemplazar valores hardcodeados
2. **Navegación** - Unificar web_nav y mobile_nav
3. **Botones** - Estandarizar todos los botones
4. **Modales** - Unificar sistema de modales

### 🟡 Media Prioridad
5. **Formularios** - Estandarizar campos de entrada
6. **Layouts** - Implementar contenedores responsivos
7. **Cards** - Estandarizar componentes de tarjetas

### 🟢 Baja Prioridad
8. **Animaciones** - Optimizar y estandarizar
9. **Iconografía** - Unificar sistema de iconos
10. **Temas** - Integrar con FlutterFlow theme

---

## 🔧 Migración Paso a Paso

### 1. Import del Sistema de Diseño

```dart
// Agregar al inicio de cada archivo
import 'package:bukeer/design_system/index.dart';
```

### 2. Reemplazar Design Tokens

#### Colores
```dart
// ❌ Antes (hardcodeado)
Color(0xFF4B39EF)
Color(0x33000000)
FlutterFlowTheme.of(context).primaryColor

// ✅ Después (design tokens)
BukeerColors.primary
BukeerColors.shadow33
BukeerColors.primary
```

#### Espaciado
```dart
// ❌ Antes (valores hardcodeados)
EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16)
EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0)
EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0)

// ✅ Después (tokens estandarizados)
BukeerSpacing.all16
BukeerSpacing.horizontal24
BukeerSpacing.topOnly16
```

#### Tipografía
```dart
// ❌ Antes (inconsistente)
GoogleFonts.getFont('Outfit', fontSize: 24.0, fontWeight: FontWeight.w600)
FlutterFlowTheme.of(context).headlineMedium

// ✅ Después (sistema unificado)
BukeerTypography.headlineMedium
BukeerTypography.titleLarge
```

#### Border Radius
```dart
// ❌ Antes (valores aleatorios)
BorderRadius.circular(8.0)
BorderRadius.circular(12.0)
BorderRadius.circular(10.0)

// ✅ Después (sistema consistente)
BukeerBorderRadius.mediumRadius  // 8.0
BukeerBorderRadius.largeRadius   // 12.0
BukeerBorderRadius.mediumRadius  // Usar consistentemente
```

### 3. Migrar Componentes de Botones

#### Botones Básicos
```dart
// ❌ Antes (FFButtonWidget)
FFButtonWidget(
  onPressed: () {},
  text: 'Guardar',
  options: FFButtonOptions(
    width: 120.0,
    height: 40.0,
    padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
    color: FlutterFlowTheme.of(context).primary,
    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
      fontFamily: 'Readex Pro',
      color: Colors.white,
    ),
    elevation: 3.0,
    borderSide: BorderSide(color: Colors.transparent, width: 1.0),
    borderRadius: BorderRadius.circular(8.0),
  ),
)

// ✅ Después (BukeerButton)
BukeerButton.primary(
  text: 'Guardar',
  onPressed: () {},
)
```

#### Botones con Iconos
```dart
// ❌ Antes (múltiples implementaciones)
ElevatedButton.icon(
  onPressed: () {},
  icon: Icon(Icons.add),
  label: Text('Agregar'),
  style: ElevatedButton.styleFrom(/* múltiples líneas de estilo */),
)

// ✅ Después (sistema unificado)
BukeerButton.primary(
  text: 'Agregar',
  icon: Icons.add,
  onPressed: () {},
)
```

#### FAB
```dart
// ❌ Antes (FloatingActionButton)
FloatingActionButton(
  onPressed: () {},
  backgroundColor: FlutterFlowTheme.of(context).primary,
  elevation: 8.0,
  child: Icon(Icons.add, color: Colors.white, size: 24.0),
)

// ✅ Después (BukeerFAB)
BukeerFAB.standard(
  icon: Icons.add,
  onPressed: () {},
)
```

### 4. Migrar Sistema de Navegación

#### Navegación Web/Mobile Unificada
```dart
// ❌ Antes (dos implementaciones separadas)
// web_nav_widget.dart - 300+ líneas
// mobile_nav_widget.dart - 150+ líneas

// ✅ Después (componente unificado)
BukeerNavigation(
  currentRoute: '/dashboard',
  userInfo: userInfo,
  navigationItems: BukeerNavigationItems.getDefaultItems(),
  onNavigate: (route) => context.go(route),
  onLogout: () => _handleLogout(),
)
```

#### Layout Responsivo
```dart
// ❌ Antes (layout fijo)
Scaffold(
  drawer: Drawer(/* implementación custom */),
  body: Container(
    width: double.infinity,
    child: Row(
      children: [
        if (MediaQuery.of(context).size.width > 991)
          Container(width: 270.0, /* sidebar manual */),
        Expanded(child: content),
      ],
    ),
  ),
)

// ✅ Después (layout automático)
ResponsiveLayout(
  title: 'Dashboard',
  currentRoute: '/dashboard',
  navigationItems: navigationItems,
  child: content,
)
```

### 5. Migrar Sistema de Modales

#### Modales Estándar
```dart
// ❌ Antes (implementación inconsistente)
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Confirmar'),
    content: Text('¿Estás seguro?'),
    actions: [
      TextButton(/* estilo manual */),
      ElevatedButton(/* estilo manual */),
    ],
  ),
)

// ✅ Después (sistema estandarizado)
BukeerModal.show(
  context: context,
  modal: BukeerModal(
    title: 'Confirmar',
    body: Text('¿Estás seguro?'),
    primaryAction: BukeerModalAction.primary(
      text: 'Confirmar',
      onPressed: () => Navigator.pop(context, true),
    ),
    secondaryAction: BukeerModalAction.secondary(
      text: 'Cancelar',
      onPressed: () => Navigator.pop(context, false),
    ),
  ),
)
```

#### Modales Responsivos
```dart
// ❌ Antes (solo dialog)
showDialog(context: context, builder: (context) => modal)

// ✅ Después (automáticamente responsive)
BukeerModal.showResponsive(
  context: context,
  modal: modal, // Dialog en desktop, BottomSheet en móvil
)
```

### 6. Migrar Campos de Formulario

#### Text Fields
```dart
// ❌ Antes (TextFormField manual)
TextFormField(
  decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'ejemplo@correo.com',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
    ),
    prefixIcon: Icon(Icons.email),
    // múltiples líneas de configuración...
  ),
  keyboardType: TextInputType.emailAddress,
  validator: (value) => /* validación manual */,
)

// ✅ Después (campo estandarizado)
BukeerTextField.email(
  label: 'Email',
  hintText: 'ejemplo@correo.com',
  controller: emailController,
  validator: (value) => /* validación */,
)
```

### 7. Migrar Layouts Responsivos

#### Contenedores
```dart
// ❌ Antes (padding hardcodeado)
Container(
  padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 24.0),
  child: content,
)

// ✅ Después (responsive automático)
ResponsiveContainer(
  child: content, // Padding automático según screen size
)
```

#### Grids
```dart
// ❌ Antes (grid fijo)
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // Fijo para todas las pantallas
    crossAxisSpacing: 16.0,
    mainAxisSpacing: 16.0,
  ),
  itemBuilder: (context, index) => items[index],
)

// ✅ Después (grid responsive)
ResponsiveGrid(
  children: items,
  config: ResponsiveLayoutConfig(
    mobileColumns: 1,
    tabletColumns: 2,
    desktopColumns: 3,
  ),
)
```

---

## 🧪 Ejemplo Completo: Migrar Modal Add/Edit Contact

### ❌ Antes (modal_add_edit_contact_widget.dart)

```dart
// Código original - 800+ líneas con:
- Container con width/height hardcodeados
- Decoración manual con BoxDecoration
- EdgeInsetsDirectional.fromSTEB por todas partes
- FFButtonWidget con configuración extensa
- TextFormField con styling repetitivo
```

### ✅ Después (usando Design System)

```dart
import 'package:bukeer/design_system/index.dart';

class AddEditContactModal extends StatelessWidget {
  final Map<String, dynamic>? contactToEdit;
  final Function(Map<String, dynamic>) onSave;

  const AddEditContactModal({
    Key? key,
    this.contactToEdit,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BukeerModal(
      title: contactToEdit == null ? 'Agregar Contacto' : 'Editar Contacto',
      size: BukeerModalSize.medium,
      body: _buildForm(),
      primaryAction: BukeerModalAction.primary(
        text: 'Guardar',
        onPressed: _handleSave,
      ),
      secondaryAction: BukeerModalAction.secondary(
        text: 'Cancelar',
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildForm() {
    return ResponsiveColumn(
      children: [
        BukeerTextField(
          label: 'Nombre',
          required: true,
          controller: _nameController,
          validator: (value) => value?.isEmpty == true ? 'Campo requerido' : null,
        ),
        BukeerTextField.email(
          controller: _emailController,
        ),
        BukeerTextField.phone(
          controller: _phoneController,
        ),
      ],
    );
  }

  void _handleSave() {
    // Lógica de guardado...
    Navigator.pop(context);
  }
}

// Uso
void _showAddContactModal() {
  BukeerModal.showResponsive(
    context: context,
    modal: AddEditContactModal(onSave: _handleContactSaved),
  );
}
```

**Resultados:**
- 📉 **De 800+ líneas a ~80 líneas** (90% reducción)
- 🎨 **Styling consistente** automáticamente
- 📱 **Responsivo** (dialog en desktop, bottom sheet en móvil)
- 🔧 **Mantenible** y reutilizable
- ♿ **Accesible** por defecto

---

## ✅ Checklist de Migración

### Por Archivo:
- [ ] Import del design system agregado
- [ ] Colores hardcodeados reemplazados con tokens
- [ ] EdgeInsetsDirectional reemplazado con BukeerSpacing
- [ ] Tipografía migrada a BukeerTypography
- [ ] Botones migrados a BukeerButton
- [ ] Modales migrados a BukeerModal
- [ ] Campos de formulario migrados a BukeerTextField
- [ ] Layouts migrados a componentes responsivos

### Por Componente:
- [ ] Funcionalidad mantenida
- [ ] Responsive en mobile/tablet/desktop
- [ ] Estados de loading implementados
- [ ] Validación funcionando
- [ ] Accesibilidad mejorada
- [ ] Código reducido y limpio

---

## 🚀 Comandos Útiles

```bash
# Buscar todos los EdgeInsetsDirectional para reemplazar
grep -r "EdgeInsetsDirectional.fromSTEB" lib/

# Buscar colores hardcodeados
grep -r "Color(0x" lib/

# Buscar FFButtonWidget para migrar
grep -r "FFButtonWidget" lib/

# Buscar modales para migrar
grep -r "showDialog" lib/
```

---

## 🎯 Próximos Pasos

1. **Migrar componentes críticos** (navegación, botones principales)
2. **Actualizar páginas principales** (dashboard, itinerarios, contactos)
3. **Migrar modales y formularios** progresivamente
4. **Limpiar código legacy** una vez migrado
5. **Documentar patrones específicos** del proyecto

---

**🤖 Generado por Claude Code - Sistema Bukeer Smart Save**