# Container Components

Los container components son widgets reutilizables que manejan la presentación de listas y grids de elementos específicos del negocio.

## 🏗️ Arquitectura

### Ubicación
```
lib/bukeer/core/widgets/containers/
├── accounts/           # Container para cuentas
├── activities/         # Container para actividades
├── contacts/          # Container para contactos
├── flights/           # Container para vuelos
├── hotels/            # Container para hoteles
├── itineraries/       # Container para itinerarios
├── transfers/         # Container para traslados
└── index.dart         # Exports centralizados
```

### Estructura de cada Container
```
container_name/
├── name_container_widget.dart  # Implementación del widget
├── name_container_model.dart   # Lógica y estado del container
└── README.md                   # Documentación específica
```

## 📋 Containers Disponibles

### 1. **AccountsContainerWidget**
- **Propósito**: Lista de cuentas de clientes/proveedores
- **Uso**: Módulos de contactos y facturación
- **Características**: Búsqueda, filtros, paginación

### 2. **ActivitiesContainerWidget**
- **Propósito**: Grid/lista de actividades turísticas
- **Uso**: Módulo de productos y servicios
- **Características**: Vista grid/lista, filtros por tipo

### 3. **ContactsContainerWidget**
- **Propósito**: Lista de contactos con información básica
- **Uso**: Módulo de contactos
- **Características**: Búsqueda avanzada, categorización

### 4. **FlightsContainerWidget**
- **Propósito**: Lista de vuelos disponibles
- **Uso**: Módulo de productos (vuelos)
- **Características**: Filtros por aerolínea, fecha, precio

### 5. **HotelsContainerWidget**
- **Propósito**: Grid de hoteles con información básica
- **Uso**: Módulo de productos (hoteles)
- **Características**: Vista grid, filtros por ubicación y rating

### 6. **ItinerariesContainerWidget**
- **Propósito**: Lista de itinerarios de viaje
- **Uso**: Módulo principal de itinerarios
- **Características**: Vista timeline, filtros por estado

### 7. **TransfersContainerWidget**
- **Propósito**: Lista de servicios de traslado
- **Uso**: Módulo de productos (traslados)
- **Características**: Filtros por tipo de vehículo y ubicación

## 🎯 Patrones de Uso

### Import Básico
```dart
import 'package:bukeer/bukeer/core/widgets/containers/index.dart';

// Uso en widget
ContactsContainerWidget(
  onContactTap: (contact) => navigateToDetails(contact),
  searchQuery: searchController.text,
)
```

### Props Comunes
Todos los containers comparten estas props base:
```dart
abstract class BaseContainerWidget {
  final String? searchQuery;           // Término de búsqueda
  final bool isLoading;               // Estado de carga
  final VoidCallback? onRefresh;      // Callback para refresh
  final Widget? emptyWidget;          // Widget cuando no hay datos
  final EdgeInsets? padding;          // Padding del container
}
```

### Estados Típicos
```dart
// Estado de carga
if (isLoading) CircularProgressIndicator()

// Estado vacío
if (items.isEmpty && !isLoading) EmptyStateWidget()

// Estado con datos
ListView.builder(...)
```

## 🔄 Integración con Servicios

### Patrón Recomendado
```dart
class ExamplePage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Contact>>(
      stream: appServices.contact.getContactsStream(),
      builder: (context, snapshot) {
        return ContactsContainerWidget(
          contacts: snapshot.data ?? [],
          isLoading: !snapshot.hasData,
          onContactTap: (contact) {
            // Navegación a detalles
          },
        );
      },
    );
  }
}
```

### Gestión de Estado
```dart
// ✅ Usar servicios para datos
final contacts = appServices.contact.getAllContacts();

// ✅ Usar UiStateService para estado temporal
appServices.ui.searchQuery = 'hotel';

// ❌ Evitar estado local para datos de negocio
// setState(() => _localContacts = newContacts);
```

## 🎨 Personalización

### Temas y Estilos
```dart
// Los containers respetan el tema global
ContactsContainerWidget(
  theme: BukeerTheme.of(context),
  colors: BukeerColors.of(context),
)
```

### Layout Responsive
```dart
// Automáticamente se adaptan al tamaño de pantalla
if (MediaQuery.of(context).size.width > 768) {
  // Vista desktop: Grid de 3 columnas
} else {
  // Vista móvil: Lista vertical
}
```

## 🚀 Migración desde Locations Antiguas

### Antes (Disperso)
```dart
// ❌ Importes dispersos
import '../../contactos/component_container_contacts/contacts_container_widget.dart';
import '../../productos/component_container_hotels/hotels_container_widget.dart';
```

### Después (Centralizado)
```dart
// ✅ Import centralizado
import 'package:bukeer/bukeer/core/widgets/containers/index.dart';

// Uso directo
ContactsContainerWidget()
HotelsContainerWidget()
```

## 📈 Performance

### Optimizaciones Incluidas
- **Lazy Loading**: Carga elementos bajo demanda
- **Caching**: Cache automático de datos frecuentes
- **Debounce**: Búsqueda optimizada con debounce
- **Pagination**: Paginación automática para listas grandes

### Métricas Objetivo
- **Tiempo de carga inicial**: < 300ms
- **Scroll performance**: 60 FPS constante
- **Memoria**: < 50MB por container con 1000 elementos

## 🧪 Testing

### Tests Incluidos
```bash
flutter test test/widgets/core/containers/
```

### Coverage Objetivo
- **Unit tests**: 90%+ de coverage
- **Widget tests**: Renderizado y interacciones
- **Integration tests**: Flujos completos con servicios

## 🔮 Futuras Mejoras

1. **Virtualization**: Lista virtualizada para +10k elementos
2. **Offline Support**: Cache persistente para modo offline
3. **Real-time Updates**: WebSocket para actualizaciones en vivo
4. **Advanced Filters**: Sistema de filtros más sofisticado
5. **Bulk Actions**: Acciones en lote (selección múltiple)

---

**Última actualización**: Enero 2024  
**Componentes migrados**: 7/7 ✅  
**Tests implementados**: Pendiente 🟡