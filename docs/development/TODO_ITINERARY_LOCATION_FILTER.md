# 🎯 TODO: Implementar Filtro de Ubicaciones en Itinerary Details

## Contexto
El sistema de ubicaciones mejorado ya está implementado y funcionando. Ahora necesitamos integrarlo en la pantalla de detalles de itinerario para mejorar la experiencia de usuario al filtrar servicios por destino.

## Archivos Clave

### Sistema de Ubicaciones (YA IMPLEMENTADO ✅)
- `/lib/backend/api_requests/api_calls.dart` - SearchLocationsImprovedCall
- `/lib/bukeer/core/widgets/forms/location_search/improved_location_search_widget.dart`
- Base de datos con funciones RPC funcionando

### A MODIFICAR 🔧
- `/lib/bukeer/itineraries/itinerary_details/itinerary_details_widget.dart`
- `/lib/bukeer/itineraries/servicios/add_hotel/add_hotel_widget.dart`
- `/lib/bukeer/itineraries/servicios/add_activities/add_activities_widget.dart`
- `/lib/bukeer/itineraries/servicios/add_transfer/add_transfer_widget.dart`

## Implementación Propuesta

### 1. En Itinerary Details - Agregar Filtro Principal

```dart
// itinerary_details_widget.dart

// Agregar al estado
String? _selectedLocationId;
String? _selectedLocationName;
List<dynamic> _filteredServices = [];

// En el build, agregar sección de filtro
Container(
  padding: EdgeInsets.all(16),
  child: Row(
    children: [
      Expanded(
        child: ImprovedLocationSearchWidget(
          productType: '', // todos los tipos
          placeholder: 'Filtrar servicios por destino...',
          onLocationSelected: (location) {
            setState(() {
              _selectedLocationId = location['id'];
              _selectedLocationName = location['full_name'];
              _applyLocationFilter();
            });
          },
        ),
      ),
      if (_selectedLocationId != null)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _selectedLocationId = null;
              _selectedLocationName = null;
              _applyLocationFilter();
            });
          },
        ),
    ],
  ),
),

// Método para filtrar servicios
void _applyLocationFilter() {
  if (_selectedLocationId == null) {
    _filteredServices = _allServices;
  } else {
    _filteredServices = _allServices.where((service) {
      // Obtener location del servicio según su tipo
      final serviceLocation = _getServiceLocation(service);
      return serviceLocation == _selectedLocationId;
    }).toList();
  }
}
```

### 2. En Add Hotel - Reemplazar Búsqueda Actual

```dart
// add_hotel_widget.dart

// ANTES (actual)
TextFormField(
  controller: _searchController,
  decoration: InputDecoration(
    labelText: 'Buscar hotel',
    prefixIcon: Icon(Icons.search),
  ),
  onChanged: (value) => _filterHotels(value),
)

// DESPUÉS (mejorado)
ImprovedLocationSearchWidget(
  productType: 'hotels',
  showCityFilter: true,
  placeholder: 'Buscar destino para hoteles...',
  onLocationSelected: (location) {
    // Cargar solo hoteles de esa ubicación
    _loadHotelsByLocation(location['id']);
  },
)

// Nuevo método para cargar hoteles filtrados
Future<void> _loadHotelsByLocation(String locationId) async {
  final hotels = await SupaFlow.client
      .from('hotels')
      .select('*, contacts!hotels_id_contact_fkey(id, name)')
      .eq('location', locationId)
      .order('name');
  
  setState(() {
    _hotels = hotels;
    _filteredHotels = hotels;
  });
}
```

### 3. Vista de Servicios Agrupados por Destino

```dart
// itinerary_services_section.dart

// Agrupar servicios por ubicación
Map<String, List<dynamic>> _groupServicesByLocation(List<dynamic> services) {
  final grouped = <String, List<dynamic>>{};
  
  for (final service in services) {
    final locationName = service['destination'] ?? 'Sin ubicación';
    grouped.putIfAbsent(locationName, () => []).add(service);
  }
  
  return grouped;
}

// Widget para mostrar servicios agrupados
Widget _buildGroupedServices() {
  final grouped = _groupServicesByLocation(_filteredServices);
  
  return Column(
    children: grouped.entries.map((entry) {
      return ExpansionTile(
        title: Text(
          entry.key,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${entry.value.length} servicios'),
        children: entry.value.map((service) {
          return _buildServiceCard(service);
        }).toList(),
      );
    }).toList(),
  );
}
```

### 4. Filtro Rápido por Ciudades del Itinerario

```dart
// Obtener ciudades únicas del itinerario
Future<List<String>> _getItineraryCities() async {
  final cities = <String>{};
  
  for (final item in _itineraryItems) {
    if (item.destination != null && item.destination!.isNotEmpty) {
      cities.add(item.destination!);
    }
  }
  
  return cities.toList()..sort();
}

// Dropdown de filtro rápido
FutureBuilder<List<String>>(
  future: _getItineraryCities(),
  builder: (context, snapshot) {
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return SizedBox.shrink();
    }
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Filtrar por ciudad',
          border: OutlineInputBorder(),
        ),
        value: _selectedCity,
        items: [
          DropdownMenuItem(
            value: null,
            child: Text('Todas las ciudades'),
          ),
          ...snapshot.data!.map((city) => 
            DropdownMenuItem(
              value: city,
              child: Text(city),
            )
          ),
        ],
        onChanged: (city) {
          setState(() {
            _selectedCity = city;
            _applyFilters();
          });
        },
      ),
    );
  },
)
```

## Beneficios Esperados

### Para el Usuario
✅ Encontrar servicios por destino rápidamente  
✅ Ver servicios agrupados por ubicación  
✅ Filtros inteligentes que entienden variaciones (Cusco/Cuzco)  
✅ Menos scroll para encontrar lo que busca  

### Para el Negocio
✅ Mejor organización de itinerarios  
✅ Menos errores al agregar servicios  
✅ Datos más limpios y normalizados  
✅ Base para analytics por destino  

## Plan de Testing

1. **Unit Tests**
```dart
test('Filtrar servicios por ubicación', () {
  final services = [
    {'id': '1', 'location': 'uuid-lima', 'name': 'Hotel Lima'},
    {'id': '2', 'location': 'uuid-cusco', 'name': 'Hotel Cusco'},
  ];
  
  final filtered = filterByLocation(services, 'uuid-cusco');
  expect(filtered.length, 1);
  expect(filtered.first['name'], 'Hotel Cusco');
});
```

2. **Widget Tests**
```dart
testWidgets('Location filter updates service list', (tester) async {
  await tester.pumpWidget(ItineraryDetailsWidget(itineraryId: 'test'));
  
  // Buscar Cusco
  await tester.enterText(find.byType(ImprovedLocationSearchWidget), 'cusco');
  await tester.pump(Duration(milliseconds: 500)); // debounce
  
  // Seleccionar Cusco
  await tester.tap(find.text('Cusco, Cusco, Perú'));
  await tester.pumpAndSettle();
  
  // Verificar filtrado
  expect(find.text('Servicios en Cusco'), findsOneWidget);
});
```

## Cronograma de Implementación

### Semana 1 (Actual)
- [x] Sistema de ubicaciones implementado
- [ ] Análisis de itinerary details actual
- [ ] Diseño de UI para filtros

### Semana 2
- [ ] Implementar filtro principal en itinerary details
- [ ] Actualizar modal de add hotel
- [ ] Testing básico

### Semana 3
- [ ] Actualizar modales de activities y transfers
- [ ] Implementar agrupación por destino
- [ ] Testing completo

### Semana 4
- [ ] Ajustes de UX basados en feedback
- [ ] Documentación actualizada
- [ ] Deploy a producción

## Notas Técnicas

1. **Cache**: El widget `ImprovedLocationSearchWidget` ya incluye debounce y cache
2. **Performance**: Las funciones RPC ya están optimizadas con índices
3. **Compatibilidad**: Mantener funcionalidad actual como fallback
4. **Migración**: No requiere cambios en base de datos

---

**RECORDATORIO IMPORTANTE**: 
- El sistema base ya está implementado y probado ✅
- Solo falta la integración en itinerary details 🔧
- Prioridad: ALTA - Mejora significativa de UX 🎯