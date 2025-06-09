# Dropdown Components

Los dropdown components son widgets especializados para la selección de entidades específicas del negocio con funcionalidades avanzadas como búsqueda, paginación y creación inline.

## 🏗️ Arquitectura

### Ubicación
```
lib/bukeer/core/widgets/forms/dropdowns/
├── accounts/           # Selector de cuentas/organizaciones
├── airports/           # Selector de aeropuertos
├── contacts/          # Selector de contactos con creación inline
├── products/          # Selector de productos (hoteles, actividades, etc)
├── travel_planner/    # Selector de agentes de viaje
└── index.dart         # Exports centralizados
```

## 📋 Dropdowns Disponibles

### 1. **DropdownAccountsWidget**
- **Propósito**: Cambiar entre diferentes cuentas u organizaciones
- **Características**:
  - Búsqueda con autocompletado
  - Integración con servicios de usuario
  - Actualización del contexto global
- **Uso típico**: Navegación principal, cambio de contexto

### 2. **DropdownAirportsWidget**
- **Propósito**: Buscar y seleccionar aeropuertos
- **Props**:
  ```dart
  DropdownAirportsWidget(
    type: 'departure', // o 'arrival'
    onAirportSelected: (airport) => {},
  )
  ```
- **Características**:
  - Búsqueda por código IATA/nombre
  - Paginación de resultados
  - Información completa del aeropuerto

### 3. **DropdownContactosWidget**
- **Propósito**: Buscar, seleccionar o crear contactos
- **Características**:
  - Búsqueda avanzada
  - Creación inline de contactos
  - Validación de datos
  - Integración con PlacePicker
- **Uso típico**: Formularios de itinerario, asignación de clientes

### 4. **DropdownProductsWidget**
- **Propósito**: Selector universal de productos turísticos
- **Props**:
  ```dart
  DropdownProductsWidget(
    productType: 'hotels', // 'activities', 'transfers', 'flights'
    location: selectedLocation,
    onProductSelected: (product) => {},
  )
  ```
- **Características**:
  - Filtro por tipo de producto
  - Filtro por ubicación
  - Vista diferente según el tipo
  - Integración con containers específicos

### 5. **DropdownTravelPlannerWidget**
- **Propósito**: Seleccionar agentes o planificadores de viaje
- **Características**:
  - Muestra foto de perfil
  - Información del agente
  - Búsqueda por nombre
- **Uso típico**: Asignación de responsables en itinerarios

## 🎯 Patrones de Uso

### Import Básico
```dart
import 'package:bukeer/bukeer/core/widgets/forms/dropdowns/index.dart';

// O importar específicamente
import 'package:bukeer/bukeer/core/widgets/forms/dropdowns/contacts/dropdown_contactos_widget.dart';
```

### Ejemplo de Implementación
```dart
class MyForm extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Selector de contacto
        DropdownContactosWidget(
          onContactSelected: (contact) {
            setState(() {
              _selectedContact = contact;
            });
          },
        ),
        
        // Selector de productos
        DropdownProductsWidget(
          productType: 'hotels',
          location: _currentLocation,
          onProductSelected: (product) {
            // Lógica de selección
          },
        ),
      ],
    );
  }
}
```

## 🔄 Integración con Servicios

### Patrón con UiStateService
```dart
// Los dropdowns actualizan automáticamente el estado global
DropdownAccountsWidget(
  // Internamente actualiza:
  // appServices.ui.selectedAccountId
  // appServices.user.currentAccount
)
```

### Búsqueda con Debounce
Todos los dropdowns implementan debounce de 2000ms para optimizar las búsquedas:
```dart
_debouncer.run(() {
  // Ejecutar búsqueda API
  _searchProducts(query);
});
```

## 🎨 Personalización y Estilos

### Modal Bottom Sheet
Los dropdowns se presentan como modal bottom sheet:
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => DropdownContent(),
)
```

### Responsive Design
- **Mobile**: Full screen modal
- **Tablet/Desktop**: Modal con ancho máximo
- Altura adaptativa según contenido

## ⚡ Performance

### Optimizaciones Incluidas
1. **Lazy Loading**: Carga bajo demanda con paginación
2. **Debounce**: Búsqueda optimizada (2000ms)
3. **Cache**: Resultados frecuentes en memoria
4. **Stream-based**: Actualizaciones reactivas

### Paginación
```dart
// Implementación típica
int _currentPage = 1;
bool _hasMore = true;
List<Product> _products = [];

void _loadMore() {
  if (!_hasMore || _isLoading) return;
  _fetchProducts(page: ++_currentPage);
}
```

## 🧪 Testing

### Consideraciones para Tests
1. **Mock de API calls**: Usar mockito/mocktail
2. **Test de debounce**: Verificar delays
3. **Test de paginación**: Simular scroll
4. **Test de creación inline**: Para contacts dropdown

## 🔮 Mejoras Futuras

### 1. Componente Base Genérico
Crear `BaseSearchableDropdown<T>` para reducir duplicación:
```dart
abstract class BaseSearchableDropdown<T> extends StatefulWidget {
  final Function(T?) onSelected;
  final String searchHint;
  final Future<List<T>> Function(String query, int page) searchFunction;
  // ... props comunes
}
```

### 2. Offline Support
- Cache persistente con Hive/SharedPreferences
- Sincronización cuando vuelva la conexión

### 3. Multi-select
- Permitir selección múltiple donde aplique
- Chips para mostrar selecciones

### 4. Filtros Avanzados
- Más opciones de filtrado
- Guardar filtros favoritos

## 📝 Notas de Migración

### Antes (Rutas dispersas)
```dart
import '../../itinerarios/dropdown_accounts/dropdown_accounts_widget.dart';
import '../../itinerarios/servicios/dropdown_airports/dropdown_airports_widget.dart';
```

### Ahora (Centralizado)
```dart
import 'package:bukeer/bukeer/core/widgets/forms/dropdowns/index.dart';
// Todos los dropdowns disponibles
```

---

**Última actualización**: Enero 2024  
**Componentes migrados**: 5/5 ✅  
**Tests pendientes**: 🟡