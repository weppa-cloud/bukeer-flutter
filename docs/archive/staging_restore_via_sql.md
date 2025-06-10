# 📋 Restauración Manual vía SQL Editor

Como hay problemas de conexión directa, hagamos la restauración vía el SQL Editor de Supabase.

## Opción 1: Subir el archivo SQL

1. **Ve al SQL Editor**: https://supabase.com/dashboard/project/wrgkiastpqituocblopg/sql/new

2. **Busca el botón "Upload SQL"** (generalmente arriba a la derecha)

3. **Selecciona el archivo**: 
   - `backups/20250609_172947/bukeer_prod_20250609_172947.sql`
   - Es un archivo de 20MB

4. **Ejecuta** (puede tomar varios minutos)

## Opción 2: Por partes

Si el archivo es muy grande, podemos dividirlo:

### Paso 1: Solo estructura y productos
```bash
# Extraer solo hoteles, actividades y tarifas
grep -E "(CREATE TABLE|INSERT INTO (hotels|activities|hotel_rates|activities_rates|transfers|transfer_rates|accounts|locations|regions|airlines|airports)|CREATE FUNCTION|CREATE INDEX)" ./backups/20250609_172947/bukeer_prod_20250609_172947.sql > staging_products_only.sql
```

### Paso 2: Ejecutar en SQL Editor
- Copia el contenido de `staging_products_only.sql`
- Pega en SQL Editor
- Ejecuta

## Opción 3: Usar Supabase CLI

```bash
# Instalar Supabase CLI si no lo tienes
brew install supabase/tap/supabase

# Conectar al proyecto
supabase link --project-ref wrgkiastpqituocblopg

# Ejecutar migración
supabase db push ./backups/20250609_172947/bukeer_prod_20250609_172947.sql
```

## ¿Cuál prefieres intentar?