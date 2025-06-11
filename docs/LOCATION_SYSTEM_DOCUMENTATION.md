# Sistema de Ubicaciones Mejorado - Documentación Completa

## 📋 Resumen Ejecutivo

El sistema de ubicaciones de Bukeer ha sido optimizado para proporcionar búsqueda avanzada, filtrado jerárquico y mejor performance sin afectar la funcionalidad existente.

## 🏗️ Arquitectura del Sistema

### Base de Datos

#### Tabla `locations` (mejorada)
```sql
locations:
├── id (UUID) - identificador único
├── name (TEXT) - nombre de la ubicación
├── city (TEXT) - ciudad
├── country (TEXT) - país
├── country_code (CHAR(2)) - código ISO del país [NUEVO]
├── latitude (DECIMAL) - coordenadas [NUEVO]
├── longitude (DECIMAL) - coordenadas [NUEVO]
├── type (VARCHAR) - tipo: city, resort, airport [NUEVO]
├── aliases (JSONB) - nombres alternativos [NUEVO]
├── metadata (JSONB) - datos adicionales [NUEVO]
└── search_vector (TSVECTOR) - búsqueda full-text [NUEVO]
```

#### Relaciones con Productos
```sql
hotels.location (UUID) → locations.id
activities.location (UUID) → locations.id
transfers.location (UUID) → locations.id
```

### Funciones RPC

#### 1. `function_search_locations_improved`
Búsqueda avanzada de ubicaciones con ranking de relevancia.

```sql
-- Parámetros
p_search_term TEXT - término de búsqueda
p_product_type TEXT - tipo de producto (hotels, activities, transfers)
p_country_code CHAR(2) - filtro por país
p_limit INTEGER - límite de resultados

-- Retorna
id, name, city, country, country_code, location_type, 
full_name, product_count, relevance
```

#### 2. `function_get_cities_by_country`
Obtiene ciudades disponibles por país con conteo de productos.

```sql
-- Parámetros
p_country_code CHAR(2) - código del país
p_product_type TEXT - tipo de producto

-- Retorna
city, country, country_code, location_count, product_count
```

## 🔧 API Calls (Frontend)

### SearchLocationsImprovedCall
```dart
final response = await SearchLocationsImprovedCall.call(
  searchTerm: 'cusco',
  productType: 'hotels',
  countryCode: 'PE',
  limit: 20,
  authToken: currentJwtToken,
);

// Acceder a datos
final locations = SearchLocationsImprovedCall.locations(response.jsonBody);
final names = SearchLocationsImprovedCall.names(response.jsonBody);
final productCounts = SearchLocationsImprovedCall.productCounts(response.jsonBody);
```

### GetCitiesByCountryCall
```dart
final response = await GetCitiesByCountryCall.call(
  countryCode: 'PE',
  productType: 'hotels',
  authToken: currentJwtToken,
);

// Acceder a datos
final cities = GetCitiesByCountryCall.cities(response.jsonBody);
final cityNames = GetCitiesByCountryCall.cityNames(response.jsonBody);
```

## 🎨 Widgets Disponibles

### ImprovedLocationSearchWidget
Widget completo con filtros jerárquicos.

```dart
ImprovedLocationSearchWidget(
  productType: 'hotels',
  showCountryFilter: true,
  showCityFilter: true,
  initialCountryCode: 'PE',
  placeholder: 'Buscar destino...',
  onLocationSelected: (location) {
    print('ID: ${location['id']}');
    print('Nombre: ${location['full_name']}');
    print('Productos: ${location['product_count']}');
  },
)
```

### SimpleLocationSearchWidget
Versión simplificada sin filtros.

```dart
SimpleLocationSearchWidget(
  productType: 'activities',
  onLocationSelected: (location) {
    // Usar ubicación seleccionada
  },
)
```

## 📊 Características del Sistema

### ✅ Búsqueda Inteligente
- Full-text search en español
- Búsqueda por nombre, ciudad o país
- Ranking por relevancia
- Soporte para aliases

### ✅ Filtrado Jerárquico
- País → Ciudad → Ubicación específica
- Conteo de productos en tiempo real
- Filtros combinables

### ✅ Performance
- Índices optimizados (GIN para búsqueda)
- Cache en frontend
- Queries optimizadas

### ✅ Compatibilidad
- APIs antiguas siguen funcionando
- Migración gradual posible
- Sin breaking changes

## 🚀 Casos de Uso

### 1. Búsqueda Simple
```dart
// Buscar "lima" en todos los productos
SearchLocationsImprovedCall.call(
  searchTerm: 'lima',
  authToken: currentJwtToken,
);
```

### 2. Filtro por País
```dart
// Solo ubicaciones de Perú
SearchLocationsImprovedCall.call(
  productType: 'hotels',
  countryCode: 'PE',
  authToken: currentJwtToken,
);
```

### 3. Búsqueda en Ciudad Específica
```dart
// Primero obtener ciudades
final cities = await GetCitiesByCountryCall.call(
  countryCode: 'PE',
  productType: 'hotels',
);

// Luego buscar en ciudad específica
final results = await SearchLocationsImprovedCall.call(
  searchTerm: 'resort',
  countryCode: 'PE',
  authToken: currentJwtToken,
);
```

## 🔍 Ejemplos de Búsqueda

### Búsqueda Inteligente
- "cusco" → encuentra Cusco ciudad + Machu Picchu
- "lima" → encuentra Lima + aeropuerto Lima
- "resort" → encuentra todos los resorts

### Filtrado Combinado
- País: Perú + Tipo: hotels → todos los hoteles en Perú
- Ciudad: Cusco + Búsqueda: "machu" → Machu Picchu

## 📈 Monitoreo y Métricas

### Queries de Verificación
```sql
-- Estadísticas generales
SELECT 
    COUNT(*) as total,
    COUNT(country_code) as con_pais,
    COUNT(search_vector) as con_busqueda
FROM locations;

-- Performance de búsqueda
EXPLAIN ANALYZE 
SELECT * FROM function_search_locations_improved('cusco', 'hotels', 'PE', 10);
```

## 🛠️ Mantenimiento

### Actualizar search_vector
```sql
UPDATE locations SET 
    search_vector = to_tsvector('spanish', 
        name || ' ' || COALESCE(city, '') || ' ' || COALESCE(country, '')
    )
WHERE search_vector IS NULL;
```

### Limpiar duplicados
```sql
-- Detectar duplicados
SELECT name, city, country, COUNT(*) 
FROM locations 
GROUP BY name, city, country 
HAVING COUNT(*) > 1;
```

## 🔄 Migración de Widgets Existentes

### Antes (Widget Antiguo)
```dart
DropdownProductsWidget(
  productType: 'hotels',
  listHotel: hotelsList,
)
```

### Después (Widget Nuevo)
```dart
ImprovedLocationSearchWidget(
  productType: 'hotels',
  onLocationSelected: (location) {
    // Usar location['id'] en lugar de hotel ID directo
  },
)
```

## 📝 Notas Importantes

1. **Backward Compatible**: Las APIs antiguas siguen funcionando
2. **Datos Normalizados**: Los country_code deben poblarse gradualmente
3. **Performance**: Los índices se crean con CONCURRENTLY para no bloquear
4. **Seguridad**: Las funciones validan parámetros y previenen SQL injection

---

# 🎯 TODO: Implementar en Itinerary Details

## Objetivo
Implementar el sistema de filtrado mejorado en la pantalla de detalles de itinerario para permitir filtrar servicios por ubicación.

## Archivos a Modificar

### 1. `itinerary_details_widget.dart`
Ubicación: `/lib/bukeer/itineraries/itinerary_details/itinerary_details_widget.dart`

### 2. Componentes de Servicios
- `/lib/bukeer/itineraries/servicios/add_hotel/add_hotel_widget.dart`
- `/lib/bukeer/itineraries/servicios/add_activities/add_activities_widget.dart`
- `/lib/bukeer/itineraries/servicios/add_transfer/add_transfer_widget.dart`

## Plan de Implementación

### Paso 1: Agregar Filtro de Ubicación en Itinerary Details
```dart
// En itinerary_details_widget.dart
class _ItineraryDetailsWidgetState extends State<ItineraryDetailsWidget> {
  String? _selectedLocationId;
  String? _selectedCity;
  
  // Agregar widget de filtro
  Widget _buildLocationFilter() {
    return ImprovedLocationSearchWidget(
      productType: 'all', // todos los tipos
      showCityFilter: true,
      onLocationSelected: (location) {
        setState(() {
          _selectedLocationId = location['id'];
          _selectedCity = location['city'];
          // Refrescar lista de servicios
          _filterServices();
        });
      },
    );
  }
  
  // Filtrar servicios por ubicación
  void _filterServices() {
    // Filtrar items del itinerario por location
    final filteredItems = _itineraryItems.where((item) {
      if (_selectedLocationId == null) return true;
      return item.location == _selectedLocationId;
    }).toList();
  }
}
```

### Paso 2: Actualizar Modales de Agregar Servicios
```dart
// En add_hotel_widget.dart
// Reemplazar búsqueda actual con:
ImprovedLocationSearchWidget(
  productType: 'hotels',
  initialCountryCode: 'PE', // o dinámico según itinerario
  onLocationSelected: (location) {
    // Cargar hoteles de esa ubicación
    _loadHotelsByLocation(location['id']);
  },
)
```

### Paso 3: Agregar Filtro Rápido por Ciudad
```dart
// Dropdown de ciudades del itinerario
FutureBuilder(
  future: _getItineraryCities(),
  builder: (context, snapshot) {
    return DropdownButton<String>(
      hint: Text('Filtrar por ciudad'),
      value: _selectedCity,
      items: snapshot.data?.map((city) => 
        DropdownMenuItem(
          value: city,
          child: Text(city),
        )
      ).toList(),
      onChanged: (city) => _filterByCity(city),
    );
  },
)
```

### Paso 4: Sincronizar con el Estado del Itinerario
```dart
// Actualizar cuando se agregan servicios
void _onServiceAdded(Map<String, dynamic> service) {
  // Si el servicio tiene una ubicación nueva
  if (!_availableLocations.contains(service['location_id'])) {
    _loadAvailableLocations();
  }
}
```

## Beneficios de la Implementación

✅ **Mejor UX**: Usuarios pueden filtrar servicios por destino  
✅ **Organización**: Ver servicios agrupados por ubicación  
✅ **Performance**: Carga solo servicios relevantes  
✅ **Consistencia**: Mismo sistema de búsqueda en toda la app  

## Testing

```dart
// Test de filtrado
testWidgets('Filtrar servicios por ubicación', (tester) async {
  await tester.pumpWidget(ItineraryDetailsWidget(itineraryId: 'test-id'));
  
  // Seleccionar Cusco
  await tester.tap(find.text('Filtrar por ubicación'));
  await tester.enterText(find.byType(TextField), 'cusco');
  await tester.tap(find.text('Cusco, Cusco, Perú'));
  
  // Verificar que solo se muestran servicios de Cusco
  expect(find.text('Hotel en Lima'), findsNothing);
  expect(find.text('Hotel en Cusco'), findsOneWidget);
});
```

## Cronograma Sugerido

1. **Semana 1**: Implementar filtro básico en itinerary details
2. **Semana 2**: Actualizar modales de agregar servicios
3. **Semana 3**: Testing y ajustes de UX
4. **Semana 4**: Rollout a producción

---

**RECORDATORIO**: Este sistema ya está implementado y probado. Solo falta integrarlo en la pantalla de itinerary details para mejorar la experiencia de filtrado de servicios.