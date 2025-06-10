# Cómo descargar las Edge Functions de Supabase

## Prerrequisitos

1. **Instalar Supabase CLI**:
```bash
brew install supabase/tap/supabase
```

## Pasos para descargar

### 1. Hacer login en Supabase
```bash
supabase login
```
Esto abrirá tu navegador para autenticarte.

### 2. Conectar al proyecto
```bash
cd /Users/yeisongomez/Documents/Proyectos/Bukeer/bukeer-flutter
supabase link --project-ref wzlxbpicdcdvxvdcvgas
```

### 3. Descargar las funciones
```bash
# Descargar todas las funciones de una vez
supabase functions download process-flight-extraction
supabase functions download create-hotel-pdf
supabase functions download generate-itinerary-pdf
supabase functions download create-hotel-social-image
supabase functions download create-activity-social-image
supabase functions download hotel-description-generator
supabase functions download activity-description-generator
supabase functions download generate-activity-social-image-gotenberg
supabase functions download generate-hotel-social-image-gotenberg
supabase functions download create-hotel-pdf-image
supabase functions download generate_activity_embeddings
```

### 4. Script automatizado (después de login)
Una vez que hayas hecho login, puedes usar este script:

```bash
#!/bin/bash
FUNCTIONS=(
  "process-flight-extraction"
  "create-hotel-pdf"
  "generate-itinerary-pdf"
  "create-hotel-social-image"
  "create-activity-social-image"
  "hotel-description-generator"
  "activity-description-generator"
  "generate-activity-social-image-gotenberg"
  "generate-hotel-social-image-gotenberg"
  "create-hotel-pdf-image"
  "generate_activity_embeddings"
)

for func in "${FUNCTIONS[@]}"; do
  echo "Descargando $func..."
  supabase functions download $func
done
```

## Alternativa: Desde el Dashboard

1. Ve a: https://supabase.com/dashboard/project/wzlxbpicdcdvxvdcvgas/functions
2. Click en cada función
3. Ve a la pestaña "Code"
4. Copia el código

## Estructura esperada

Cada Edge Function típicamente tiene:
```
functions/
├── function-name/
│   ├── index.ts       # Código principal
│   ├── deno.json      # Configuración de Deno
│   └── README.md      # Documentación
```

## Información de las funciones conocidas

### process-flight-extraction
- **Propósito**: Extrae información de vuelos desde texto usando IA
- **Input**: `{ itinerary_id, account_id, text_to_analyze }`
- **Output**: `{ items_added: number }`

### create-hotel-pdf / generate-itinerary-pdf
- **Propósito**: Genera PDFs para hoteles/itinerarios
- **Input**: `{ itineraryId: string }`
- **Output**: `{ publicUrl: string }`

### *-description-generator
- **Propósito**: Genera descripciones usando IA (probablemente OpenAI)
- **Input**: Información del producto (hotel/actividad)
- **Output**: Descripción generada

### *-social-image
- **Propósito**: Genera imágenes para redes sociales
- **Input**: Datos del producto
- **Output**: URL de la imagen generada