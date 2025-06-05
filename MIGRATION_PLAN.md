# Plan de Migración de FFAppState

## Resumen
Migración gradual del FFAppState sobrecargado a una arquitectura más limpia con separación de responsabilidades.

## Estado Actual vs Nuevo

### FFAppState Original (40+ variables)
- ❌ Estado temporal de UI mezclado con estado global
- ❌ Variables de búsqueda globales
- ❌ Estado de formularios persistido
- ❌ Objetos masivos de datos
- ❌ Sin separación de responsabilidades

### Nueva Arquitectura
- ✅ FFAppState limpio (solo estado esencial global)
- ✅ UiStateService para estado temporal
- ✅ Servicios especializados por dominio
- ✅ Separación clara de responsabilidades

## Variables Movidas del FFAppState Original

### A UiStateService (Estado Temporal)
```dart
// Búsqueda y filtros
String searchStringState → UiStateService.searchQuery
int nextPage → UiStateService.currentPage

// Selección de productos
String idProductSelected → UiStateService.selectedProductId
String typeProduct → UiStateService.selectedProductType
bool selectRates → UiStateService.isSelectingRates

// Estado de formularios
String imageMain → UiStateService.selectedImageUrl
bool isCreatedinItinerary → UiStateService.isCreatingItinerary

// Location picker
String latlngLocation → UiStateService.selectedLocationLatLng
String nameLocation → UiStateService.selectedLocationName
// ... otros campos de ubicación

// Cálculos de tarifas hoteleras
String profitHotelRates → UiStateService.profitHotelRates
String rateUnitCostHotelRates → UiStateService.rateUnitCostHotelRates
String unitCostHotelRates → UiStateService.unitCostHotelRates
```

### A Servicios Especializados (Estado de Dominio)
```dart
// A ItineraryService
dynamic allDataItinerary
List<ItemsStruct> itemsItineraryPDF
ItineraryPDFStruct itineraryPDF

// A ProductService
dynamic allDataHotel
dynamic allDataActivity
dynamic allDataTransfer
dynamic allDataFlight
dynamic itemsProducts

// A ContactService
dynamic allDataContact
dynamic itemsContact

// A UserService (ya existe)
dynamic allDataUser
```

## Plan de Migración por Fases

### Fase 1: ✅ Completada
- [x] Crear AppConfig para API keys
- [x] Crear FFAppState limpio
- [x] Crear UiStateService
- [x] Crear AppProviders

### Fase 2: En Progreso
- [ ] Migrar componentes críticos a nueva estructura
- [ ] Reemplazar FFAppState en main.dart
- [ ] Migrar SearchBox component
- [ ] Migrar Product selection components

### Fase 3: Próximo
- [ ] Migrar formularios de itinerarios
- [ ] Migrar componentes de ubicación
- [ ] Migrar cálculos de tarifas

### Fase 4: Final
- [ ] Eliminar FFAppState original
- [ ] Actualizar documentación
- [ ] Tests de regresión

## Cómo Migrar un Componente

### Antes (FFAppState)
```dart
class MyWidget extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FFAppState>(
      builder: (context, appState, _) {
        return TextField(
          onChanged: (value) {
            appState.searchStringState = value;
          },
          controller: TextEditingController(
            text: appState.searchStringState,
          ),
        );
      },
    );
  }
}
```

### Después (Nueva Arquitectura)
```dart
class MyWidget extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UiStateService>(
      builder: (context, uiState, _) {
        return TextField(
          onChanged: (value) {
            uiState.searchQuery = value;
          },
          controller: TextEditingController(
            text: uiState.searchQuery,
          ),
        );
      },
    );
  }
}

// O usando el extension helper
class MyWidget extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    final uiState = context.watchUiState;
    
    return TextField(
      onChanged: (value) {
        context.uiState.searchQuery = value;
      },
      controller: TextEditingController(
        text: uiState.searchQuery,
      ),
    );
  }
}
```

## Beneficios de la Migración

### Performance
- 🚀 Menos rebuilds innecesarios
- 🚀 Estado local no persiste cuando no es necesario
- 🚀 Mejor gestión de memoria

### Mantenibilidad
- 🧹 Código más limpio y organizado
- 🧹 Separación clara de responsabilidades
- 🧹 Fácil testing de componentes individuales

### Escalabilidad
- 📈 Fácil agregar nuevo estado temporal
- 📈 Servicios especializados por dominio
- 📈 Menos acoplamiento entre componentes

## Orden de Migración Recomendado

1. **SearchBox** (más usado, mayor impacto)
2. **Product selection dropdowns**
3. **Location picker components**
4. **Form components en modales**
5. **Rate calculation components**
6. **PDF generation components**

## Testing Strategy

Para cada componente migrado:
1. Verificar que el estado se mantiene correctamente
2. Verificar que no hay rebuilds innecesarios
3. Verificar que la funcionalidad no se rompió
4. Verificar que no hay memory leaks

## Rollback Plan

Si algo falla:
1. Mantener FFAppState original como backup
2. Cambiar imports para volver al original
3. Revertir cambios en main.dart
4. Usar git para revertir cambios específicos