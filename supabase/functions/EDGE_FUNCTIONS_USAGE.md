# Uso de Edge Functions en Bukeer

## Functions confirmadas en el código

### 1. process-flight-extraction
**Ubicación**: `lib/backend/api_requests/api_calls.dart:3813`

```dart
class ProcessFlightExtractionCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? itineraryId = '',
    String? accountId = '',
    String? textToAnalyze = '',
  }) async {
    final ffApiRequestBody = '''
{
  "itinerary_id": "${escapeStringForJson(itineraryId)}",
  "account_id": "${escapeStringForJson(accountId)}",
  "text_to_analyze": "${escapeStringForJson(textToAnalyze)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ProcessFlightExtraction',
      apiUrl: 'https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/process-flight-extraction',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authToken}',
        'apikey': AppConfig.supabaseAnonKey,
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? itemsAdded(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.items_added''',
      ));
}
```

**Uso**: Se usa en `add_a_i_flights_widget.dart` para extraer información de vuelos desde texto.

### 2. create-itinerary-proposal-pdf (ItineraryProposalPdf)
**Ubicación**: `lib/backend/api_requests/api_calls.dart:3922`

```dart
class ItineraryProposalPdfCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? itineraryId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "itineraryId": "${escapeStringForJson(itineraryId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'itineraryProposalPdf',
      apiUrl: 'https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/create-itinerary-proposal-pdf',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authToken}',
        'apikey': AppConfig.supabaseAnonKey,
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? urlPDF(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.publicUrl''',
      ));
}
```

**Uso**: Se usa en `itinerary_details_widget.dart` para generar PDFs de propuestas de itinerario.

## Edge Functions sin uso confirmado en el código Flutter

Las siguientes funciones están desplegadas pero no se encontraron referencias directas en el código Flutter:

1. **create-hotel-pdf** - Genera PDFs de hoteles
2. **generate-itinerary-pdf** - Genera PDFs de itinerarios (diferente a proposal)
3. **create-hotel-social-image** - Crea imágenes sociales de hoteles
4. **create-activity-social-image** - Crea imágenes sociales de actividades
5. **hotel-description-generator** - Genera descripciones de hoteles con IA
6. **activity-description-generator** - Genera descripciones de actividades con IA
7. **generate-activity-social-image-gotenberg** - Genera imágenes usando Gotenberg
8. **generate-hotel-social-image-gotenberg** - Genera imágenes usando Gotenberg
9. **create-hotel-pdf-image** - Crea imágenes PDF de hoteles
10. **generate_activity_embeddings** - Genera embeddings para búsqueda semántica

## Patrones comunes

Todas las Edge Functions siguen estos patrones:

1. **Autenticación**: Requieren Bearer token y API key
2. **Content-Type**: application/json
3. **Método**: POST
4. **Respuesta**: JSON con campos específicos según la función

## Integración con el código

Las Edge Functions se integran a través de:
1. **API Calls**: Definidas en `lib/backend/api_requests/api_calls.dart`
2. **Models**: Los modelos de las páginas llaman a estas funciones
3. **Widgets**: Los widgets manejan las respuestas y actualizan la UI

## Testing

Para hacer mocks de estas funciones en tests:

```dart
// Mock de ProcessFlightExtraction
when(mockApiManager.makeApiCall(
  callName: 'ProcessFlightExtraction',
  // ... otros parámetros
)).thenAnswer((_) async => ApiCallResponse(
  {'items_added': 3},
  {},
  200,
));

// Mock de ItineraryProposalPdf
when(mockApiManager.makeApiCall(
  callName: 'itineraryProposalPdf',
  // ... otros parámetros
)).thenAnswer((_) async => ApiCallResponse(
  {'publicUrl': 'https://example.com/pdf'},
  {},
  200,
));
```