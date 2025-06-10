# Edge Functions de Supabase - Bukeer

## Edge Functions Desplegadas (Confirmadas)

Según el dashboard de Supabase, tienes las siguientes Edge Functions activas:

### 1. **process-flight-extraction**
- **URL**: `https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/process-flight-extraction`
- **Última actualización**: 24 días
- **Deployments**: 52
- **Uso en código**: Sí (ProcessFlightExtraction en api_calls.dart)
- **Propósito**: Extrae información de vuelos desde texto

### 2. **create-hotel-pdf**
- **URL**: `https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/create-hotel-pdf`
- **Última actualización**: 24 días
- **Deployments**: 194
- **Propósito**: Genera PDFs de información de hoteles

### 3. **generate-itinerary-pdf**
- **URL**: `https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/generate-itinerary-pdf`
- **Última actualización**: 1 mes
- **Deployments**: 68
- **Propósito**: Genera PDFs de itinerarios completos

### 4. **create-hotel-social-image**
- **URL**: `https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/create-hotel-social-image`
- **Última actualización**: 1 mes
- **Deployments**: 47
- **Propósito**: Crea imágenes para compartir en redes sociales de hoteles

### 5. **create-activity-social-image**
- **URL**: `https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/create-activity-social-image`
- **Última actualización**: 1 mes
- **Deployments**: 66
- **Propósito**: Crea imágenes para compartir en redes sociales de actividades

### 6. **hotel-description-generator**
- **URL**: `https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/hotel-description-generator`
- **Última actualización**: 1 mes
- **Deployments**: 9
- **Propósito**: Genera descripciones de hoteles usando IA

### 7. **activity-description-generator**
- **URL**: `https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/activity-description-generator`
- **Última actualización**: 1 mes
- **Deployments**: 12
- **Propósito**: Genera descripciones de actividades usando IA

### 8. **generate-activity-social-image-gotenberg**
- **URL**: `https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/generate-activity-social-image-gotenberg`
- **Última actualización**: 1 mes
- **Deployments**: 11
- **Propósito**: Genera imágenes sociales usando Gotenberg

### 9. **generate-hotel-social-image-gotenberg**
- **URL**: `https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/generate-hotel-social-image-gotenberg`
- **Última actualización**: 1 mes
- **Deployments**: 4
- **Propósito**: Genera imágenes sociales de hoteles usando Gotenberg

### 10. **create-hotel-pdf-image**
- **URL**: `https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/create-hotel-pdf-image`
- **Última actualización**: 12 días
- **Deployments**: 46
- **Propósito**: Crea imágenes PDF de hoteles

### 11. **generate_activity_embeddings**
- **URL**: `https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/generate_activity_embeddings`
- **Última actualización**: 20 días
- **Deployments**: 6
- **Propósito**: Genera embeddings para búsqueda semántica de actividades

## Edge Functions en el Código

### Confirmadas en uso:

1. **ProcessFlightExtraction** (api_calls.dart:3813)
   ```dart
   apiUrl: 'https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/process-flight-extraction'
   ```

2. **ItineraryProposalPdf** (api_calls.dart:3922)
   ```dart
   apiUrl: 'https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/create-itinerary-proposal-pdf'
   ```

## Nota sobre Nombres

Hay una discrepancia entre algunos nombres:
- En el dashboard: `generate-itinerary-pdf`
- En el código: `create-itinerary-proposal-pdf`

Esto sugiere que puede haber diferentes versiones o que el código necesita actualización.

## Implicaciones para Testing

1. Las Edge Functions están activas y en producción
2. Requieren autenticación con Bearer token
3. Necesitan el API key de Supabase
4. Son funciones serverless que procesan datos complejos (PDFs, imágenes, IA)
5. Para tests, se necesitarían mocks que simulen estas respuestas