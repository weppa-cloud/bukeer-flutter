# Configuración de Supabase para Bukeer

## Opción 1: Exportar esquema desde Supabase existente (Recomendado)

### 1. Instalar Supabase CLI
```bash
# macOS
brew install supabase/tap/supabase

# O con npm
npm install -g supabase
```

### 2. Login en Supabase
```bash
supabase login
```

### 3. Conectar al proyecto
```bash
# Reemplaza con tu project ID
supabase link --project-ref tu_project_id
```

### 4. Exportar esquema completo
```bash
# Exportar esquema de base de datos
supabase db dump --file supabase/schema/complete_schema.sql

# Exportar solo estructura (sin datos)
supabase db dump --schema-only --file supabase/schema/structure.sql

# Exportar funciones RPC
supabase db dump --file supabase/functions/rpc_functions.sql --data-only --table pg_proc
```

### 5. Exportar Edge Functions (si las tienes)
```bash
supabase functions download nombre_funcion
```

## Opción 2: Usar SQL Editor en Dashboard

1. Ve a tu proyecto en [app.supabase.com](https://app.supabase.com)
2. SQL Editor > New Query
3. Ejecuta estas queries:

### Obtener todas las tablas
```sql
SELECT table_name, table_type 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
```

### Obtener estructura de una tabla
```sql
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'itineraries'
ORDER BY ordinal_position;
```

### Obtener todas las funciones RPC
```sql
SELECT 
    proname as function_name,
    pg_get_functiondef(oid) as function_definition
FROM pg_proc
WHERE pronamespace = 'public'::regnamespace
  AND prokind = 'f'
ORDER BY proname;
```

## Opción 3: Conectar directamente desde el código

Crea un archivo `.env` basado en `.env.example` con tus credenciales y ejecuta:

```bash
# Instalar dependencias
npm install @supabase/supabase-js dotenv

# Crear script de exportación
node scripts/export_supabase_schema.js
```

## Información necesaria

Para que pueda ayudarte mejor con los tests, necesito:

1. **Esquema de base de datos**: Tipos de datos exactos, constraints, relaciones
2. **Funciones RPC**: La lógica de las funciones como `function_get_contacts_search`, etc.
3. **Edge Functions**: Si usas funciones serverless
4. **Políticas RLS**: Row Level Security policies si las tienes activas

## ¿Qué prefieres hacer?

1. **Exportar con CLI** (más completo)
2. **Copiar desde Dashboard** (más rápido)
3. **Compartir credenciales de desarrollo** (para que extraiga yo la info)