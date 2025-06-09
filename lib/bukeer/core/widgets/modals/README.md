# Modal Components

Los modal components son widgets reutilizables para crear, editar y visualizar entidades del negocio en ventanas modales.

## 🏗️ Arquitectura

### Ubicación
```
lib/bukeer/core/widgets/modals/
├── contact/          # Modales de contactos
│   ├── add_edit/    # Crear/editar contacto
│   └── details/     # Ver detalles de contacto
├── itinerary/       # Modales de itinerarios
│   └── add_edit/    # Crear/editar itinerario
├── passenger/       # Modales de pasajeros
│   └── add/         # Agregar pasajero
├── product/         # Modales de productos
│   ├── add/         # Crear producto
│   └── details/     # Ver detalles de producto
├── user/            # Modales de usuarios
│   └── add/         # Agregar usuario
└── index.dart       # Exports centralizados
```

## 📋 Modales Disponibles

### 1. **Contact Modals**

#### ModalAddEditContactWidget
- **Propósito**: Crear o editar contactos
- **Características**:
  - Formulario completo con validación
  - Integración con Google Places para ubicación
  - Selector de fecha de nacimiento
  - Gestión de roles (cliente/proveedor)
- **Props**:
  ```dart
  ModalAddEditContactWidget(
    contact: existingContact, // null para crear nuevo
    onSave: (contact) => {},
  )
  ```

#### ModalDetailsContactWidget
- **Propósito**: Ver información detallada del contacto
- **Características**:
  - Vista readonly con toda la información
  - Acciones rápidas (editar, eliminar)
  - Historial de transacciones
  - Lista de itinerarios asociados

### 2. **Itinerary Modals**

#### ModalAddEditItineraryWidget
- **Propósito**: Crear o editar itinerarios completos
- **Características**:
  - Wizard multi-paso
  - Selector de cliente (con creación inline)
  - Configuración de fechas y destino
  - Asignación de travel planner
- **Tamaño**: Modal grande (80% pantalla)

### 3. **Passenger Modals**

#### ModalAddPassengerWidget
- **Propósito**: Agregar pasajeros a un itinerario
- **Características**:
  - Búsqueda en contactos existentes
  - Creación de nuevo contacto como pasajero
  - Validación de datos de pasajero
  - Gestión de documentos (pasaporte, etc)

### 4. **Product Modals**

#### ModalAddProductWidget
- **Propósito**: Crear nuevos productos turísticos
- **Características**:
  - Soporte para múltiples tipos (hotel, actividad, etc)
  - Upload de imágenes
  - Configuración de tarifas
  - Horarios y disponibilidad

#### ModalDetailsProductWidget
- **Propósito**: Ver y editar detalles de producto
- **Características**:
  - Galería de imágenes
  - Gestión de tarifas por temporada
  - Configuración de horarios (para actividades)
  - Inclusiones y exclusiones

### 5. **User Modals**

#### ModalAddUserWidget
- **Propósito**: Crear nuevos usuarios del sistema
- **Características**:
  - Formulario de registro
  - Asignación de roles
  - Configuración de permisos
  - Envío de invitación por email

## 🎯 Patrones de Uso

### Abrir Modal Básico
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => ModalAddEditContactWidget(
    contact: null, // Nuevo contacto
    onSave: (contact) {
      // Lógica después de guardar
      Navigator.pop(context);
    },
  ),
);
```

### Modal con Datos Existentes
```dart
// Editar contacto existente
showModalBottomSheet(
  context: context,
  builder: (context) => ModalAddEditContactWidget(
    contact: existingContact,
    onSave: (updatedContact) async {
      await _updateContact(updatedContact);
      Navigator.pop(context);
    },
  ),
);
```

### Modal de Solo Lectura
```dart
// Ver detalles sin editar
showModalBottomSheet(
  context: context,
  builder: (context) => ModalDetailsContactWidget(
    contactId: contact.id,
    onEdit: () {
      // Abrir modal de edición
    },
    onDelete: () async {
      // Confirmar y eliminar
    },
  ),
);
```

## 🎨 Estilos y Configuración

### Tamaños Estándar
```dart
// Modal pequeño (40% altura)
height: MediaQuery.of(context).size.height * 0.4

// Modal mediano (60% altura)
height: MediaQuery.of(context).size.height * 0.6

// Modal grande (80% altura)
height: MediaQuery.of(context).size.height * 0.8

// Modal full screen
isScrollControlled: true
```

### Configuración Visual
```dart
showModalBottomSheet(
  backgroundColor: Colors.transparent,
  barrierColor: Colors.black54,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(25.0),
    ),
  ),
  // ...
);
```

## 🔄 Integración con Servicios

### Patrón Recomendado
```dart
class ModalAddEditContactWidget extends StatefulWidget {
  @override
  _ModalAddEditContactWidgetState createState() => 
      _ModalAddEditContactWidgetState();
}

class _ModalAddEditContactWidgetState 
    extends State<ModalAddEditContactWidget> {
  
  final _formKey = GlobalKey<FormState>();
  
  Future<void> _saveContact() async {
    if (_formKey.currentState!.validate()) {
      // Usar servicios
      final success = await appServices.contact.createContact(
        name: _nameController.text,
        email: _emailController.text,
        // ...
      );
      
      if (success) {
        widget.onSave?.call(newContact);
        Navigator.pop(context);
      }
    }
  }
}
```

## ⚡ Performance

### Lazy Loading
Los modales cargan datos solo cuando se abren:
```dart
@override
void initState() {
  super.initState();
  if (widget.contactId != null) {
    _loadContactDetails();
  }
}
```

### Dispose Correcto
```dart
@override
void dispose() {
  _nameController.dispose();
  _emailController.dispose();
  // Limpiar todos los controllers
  super.dispose();
}
```

## 🧪 Testing

### Consideraciones para Tests
1. **Mock de showModalBottomSheet**
2. **Test de validación de formularios**
3. **Test de callbacks (onSave, onCancel)**
4. **Test de estados (loading, error, success)**

### Ejemplo de Test
```dart
testWidgets('Modal saves contact correctly', (tester) async {
  Contact? savedContact;
  
  await tester.pumpWidget(
    MaterialApp(
      home: ModalAddEditContactWidget(
        onSave: (contact) {
          savedContact = contact;
        },
      ),
    ),
  );
  
  // Llenar formulario
  await tester.enterText(find.byKey(Key('name_field')), 'John Doe');
  await tester.enterText(find.byKey(Key('email_field')), 'john@example.com');
  
  // Guardar
  await tester.tap(find.text('Guardar'));
  await tester.pumpAndSettle();
  
  // Verificar
  expect(savedContact?.name, equals('John Doe'));
  expect(savedContact?.email, equals('john@example.com'));
});
```

## 🔮 Mejoras Futuras

### 1. Modal Base Genérico
```dart
abstract class BaseModal<T> extends StatefulWidget {
  final T? entity;
  final Function(T) onSave;
  final VoidCallback? onCancel;
  
  // Template method pattern
  Widget buildForm();
  Future<T?> save();
  bool validate();
}
```

### 2. Animaciones Mejoradas
- Transiciones suaves entre pasos
- Efectos de entrada/salida
- Feedback visual en acciones

### 3. Modo Offline
- Guardar borrador localmente
- Sincronizar cuando vuelva conexión
- Indicador de estado offline

### 4. Validación en Tiempo Real
- Validación mientras escribe
- Sugerencias automáticas
- Detección de duplicados

---

**Última actualización**: Enero 2024  
**Componentes migrados**: 7/7 ✅  
**Tests pendientes**: 🟡