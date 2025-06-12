# Configuración del API Key de Duffel

## Descripción
Este documento explica cómo configurar el API key de Duffel para que el sistema pueda realizar llamadas a su API de forma segura.

## Configuración

### 1. Obtener el API Key
- Accede a tu cuenta de Duffel en https://app.duffel.com
- Ve a Settings > API keys
- Copia tu API key de producción (comienza con `duffel_live_`)

### 2. Configurar en Variables de Entorno

#### Para desarrollo local:
1. Copia el archivo `supabase/.env.example` a `supabase/.env`
2. Agrega tu API key:
   ```
   DUFFEL_API_KEY=duffel_live_tu_api_key_aqui
   ```

#### Para producción (Supabase):
1. En el dashboard de Supabase, ve a Settings > Edge Functions
2. Agrega la variable de entorno:
   - Name: `DUFFEL_API_KEY`
   - Value: Tu API key de Duffel

### 3. Uso en la Base de Datos
El schema de la base de datos ahora utiliza la configuración dinámica:
```sql
('Authorization', 'Bearer ' || COALESCE(current_setting('app.duffel_api_key', true), 'DUFFEL_API_KEY_NOT_SET'))
```

### 4. Configurar la variable en PostgreSQL
Para que la función pueda acceder al API key, necesitas configurar la variable en tu sesión de PostgreSQL:
```sql
SET app.duffel_api_key = 'duffel_live_tu_api_key_aqui';
```

O de forma permanente en tu configuración de PostgreSQL.

## Seguridad
- **NUNCA** commits el API key directamente en el código
- Siempre usa variables de entorno
- Asegúrate de que el archivo `.env` esté en `.gitignore`
- Rota los API keys regularmente

## Troubleshooting
Si ves el error `DUFFEL_API_KEY_NOT_SET` en los logs, significa que:
1. La variable de entorno no está configurada
2. O la configuración de PostgreSQL no tiene acceso a la variable

Verifica que hayas seguido todos los pasos de configuración correctamente.