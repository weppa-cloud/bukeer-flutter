# Supabase Migrations

## Función RPC: get_complete_itinerary_details

### Descripción
Esta función RPC optimiza la carga de datos del itinerario devolviendo toda la información necesaria en una sola llamada a la base de datos.

### Cómo ejecutar la migración

1. **Opción 1: Usando Supabase CLI**
```bash
supabase db push
```

2. **Opción 2: Ejecutar manualmente en el SQL Editor de Supabase**
   - Ve a tu proyecto en Supabase Dashboard
   - Navega a SQL Editor
   - Copia y pega el contenido de `01_get_complete_itinerary_details.sql`
   - Ejecuta el script

### Estructura de respuesta

La función devuelve un JSON con la siguiente estructura:

```json
{
  "itinerary": {
    // Datos básicos del itinerario + contacto
  },
  "items_grouped": {
    "all_items": [...],
    "flights": [...],
    "hotels": [...],
    "activities": [...],
    "transfers": [...]
  },
  "totals": {
    "flights": 0.0,
    "hotels": 0.0,
    "activities": 0.0,
    "transfers": 0.0,
    "total": 0.0,
    "total_cost": 0.0,
    "total_profit": 0.0
  },
  "passengers": [...],
  "transactions": [...],
  "payment_summary": {
    "total_paid": 0.0,
    "total_paid_to_providers": 0.0,
    "balance": 0.0
  },
  "summary": {
    "has_flights": true/false,
    "has_hotels": true/false,
    "has_activities": true/false,
    "has_transfers": true/false,
    "total_items": 0,
    "total_passengers": 0,
    "total_transactions": 0
  }
}
```

### Uso en Flutter

```dart
// Llamar a la función RPC
final response = await SupaFlow.client
    .rpc('get_complete_itinerary_details', params: {
      'p_itinerary_id': itineraryId,
    });

// Los datos vienen organizados y listos para usar
final flights = response['items_grouped']['flights'];
final totalHotels = response['totals']['hotels'];
final hasActivities = response['summary']['has_activities'];
```

### Ventajas

1. **Una sola llamada** - Reduce la latencia significativamente
2. **Datos pre-procesados** - Items agrupados por tipo, totales calculados
3. **Menor uso de ancho de banda** - Solo se transfiere la información necesaria
4. **Mejor rendimiento** - Las agregaciones se hacen en la base de datos
5. **Código más limpio** - No hay necesidad de múltiples queries y mapeos en el cliente