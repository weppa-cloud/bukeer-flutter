# Flujo de Desarrollo con Supabase (Local → Staging → Production)

## 🔄 Flujo General

```mermaid
graph LR
    A[Desarrollo Local] --> B[Pull Request]
    B --> C[Review & Tests]
    C --> D[Merge a Staging]
    D --> E[QA en Staging]
    E --> F[Aprobación]
    F --> G[Deploy a Production]
```

## 👨‍💻 1. Desarrollo Local (Día a día del desarrollador)

### Inicio del día
```bash
# 1. Actualizar código
git checkout develop
git pull origin develop

# 2. Levantar Supabase local
supabase start

# 3. Verificar que todo esté sincronizado
supabase db reset  # Aplica migraciones y seed data

# 4. Iniciar desarrollo
flutter run --dart-define=ENVIRONMENT=local
```

### Durante el desarrollo

#### A. Cambio en la Base de Datos
```bash
# Ejemplo: Agregar campo 'priority' a itinerarios

# 1. Crear migración
supabase migration new add_priority_to_itineraries

# 2. Editar el archivo creado
cat > supabase/migrations/[timestamp]_add_priority_to_itineraries.sql << EOF
-- Add priority field to itineraries
ALTER TABLE itineraries 
ADD COLUMN priority TEXT DEFAULT 'normal' 
CHECK (priority IN ('low', 'normal', 'high', 'urgent'));

-- Add index for performance
CREATE INDEX idx_itineraries_priority ON itineraries(priority);
EOF

# 3. Aplicar localmente
supabase db reset

# 4. Probar en la app
flutter run --dart-define=ENVIRONMENT=local
```

#### B. Nueva Edge Function
```bash
# 1. Crear función
supabase functions new calculate-itinerary-stats

# 2. Desarrollar la función
code supabase/functions/calculate-itinerary-stats/index.ts

# 3. Probar localmente
supabase functions serve calculate-itinerary-stats

# 4. En otra terminal, hacer requests de prueba
curl -i --location --request POST \
  'http://localhost:54321/functions/v1/calculate-itinerary-stats' \
  --header 'Authorization: Bearer eyJhbG...' \
  --header 'Content-Type: application/json' \
  --data '{"itinerary_id":"123"}'
```

#### C. Cambios en Flutter
```dart
// 1. Usar el servicio apropiado
class ItineraryStatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // El código funciona igual en todos los entornos
    // AppConfig se encarga de las URLs
    return FutureBuilder(
      future: CalculateStatsCall.call(
        authToken: currentJwtToken,
        itineraryId: widget.itineraryId,
      ),
      builder: (context, snapshot) {
        // UI code...
      },
    );
  }
}
```

### Final del día
```bash
# 1. Verificar cambios
git status

# 2. Commit con mensaje descriptivo
git add .
git commit -m "feat: add priority field to itineraries with stats calculation"

# 3. Push a tu branch
git push origin feature/itinerary-priority
```

## 🔀 2. Pull Request y Review

### Crear PR
```bash
# En GitHub/GitLab
# Title: "Add priority field to itineraries"
# Description:
## Cambios
- ✅ Agregado campo priority a itinerarios
- ✅ Nueva Edge Function para calcular estadísticas
- ✅ UI actualizada para mostrar prioridad

## Migraciones
- `add_priority_to_itineraries.sql`

## Testing
- [ ] Probado localmente
- [ ] Tests unitarios pasan
- [ ] Migración reversible

## Screenshots
[Agregar capturas de la UI]
```

### Review Process
El reviewer debe:
1. Revisar código
2. Probar localmente:
```bash
git checkout feature/itinerary-priority
supabase db reset
flutter run --dart-define=ENVIRONMENT=local
```
3. Verificar migraciones
4. Aprobar o solicitar cambios

## 🚀 3. Deploy a Staging

### Automático (CI/CD recomendado)
```yaml
# .github/workflows/staging-deploy.yml
name: Deploy to Staging
on:
  push:
    branches: [develop]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Supabase CLI
        uses: supabase/setup-cli@v1
        
      - name: Deploy to Staging
        env:
          SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}
        run: |
          # Conectar a staging
          supabase link --project-ref ${{ secrets.STAGING_PROJECT_ID }}
          
          # Aplicar migraciones
          supabase db push
          
          # Deploy Edge Functions
          supabase functions deploy
          
      - name: Run Tests
        run: |
          flutter test
          flutter test integration_test --dart-define=ENVIRONMENT=staging
```

### Manual (si no hay CI/CD)
```bash
# 1. Cambiar a rama develop
git checkout develop
git pull

# 2. Conectar a staging
supabase link --project-ref [STAGING_PROJECT_ID]

# 3. Ver qué se va a aplicar
supabase db diff

# 4. Aplicar cambios
supabase db push
supabase functions deploy

# 5. Verificar
open https://[STAGING_PROJECT].supabase.co
```

## 🧪 4. Testing en Staging

### QA Team
1. **Test funcionales**
   - Probar nueva funcionalidad
   - Verificar que no se rompió nada existente
   
2. **Test de integración**
   ```bash
   flutter drive \
     --driver=test_driver/integration_test.dart \
     --target=integration_test/app_test.dart \
     --dart-define=ENVIRONMENT=staging
   ```

3. **Test de performance**
   - Verificar tiempos de respuesta
   - Monitorear queries lentas en Supabase Dashboard

### Feedback Loop
Si se encuentran bugs:
1. Crear issue
2. Fix en nueva branch
3. PR → Develop → Staging
4. Re-test

## ✅ 5. Deploy a Production

### Pre-deploy Checklist
- [ ] QA aprobó en staging
- [ ] No hay errores en logs de staging
- [ ] Backup de producción realizado
- [ ] Ventana de mantenimiento comunicada (si aplica)

### Deploy Process

#### Opción A: Blue-Green Deployment (Recomendado)
```bash
# 1. Crear snapshot de producción
supabase db dump -f backup_$(date +%Y%m%d_%H%M%S).sql

# 2. Deploy con zero-downtime
supabase link --project-ref [PROD_PROJECT_ID]
supabase db push --no-confirm
supabase functions deploy

# 3. Verificación rápida
curl https://wzlxbpicdcdvxvdcvgas.supabase.co/rest/v1/health
```

#### Opción B: Mantenimiento programado
```bash
# 1. Activar modo mantenimiento en la app
flutter build web --dart-define=MAINTENANCE_MODE=true
firebase deploy --only hosting

# 2. Realizar cambios
supabase link --project-ref [PROD_PROJECT_ID]
supabase db push
supabase functions deploy

# 3. Desactivar modo mantenimiento
flutter build web --dart-define=ENVIRONMENT=production
firebase deploy --only hosting
```

## 📋 Escenarios Comunes

### 1. Hotfix de Emergencia
```bash
# Desde main/master
git checkout -b hotfix/critical-bug main
# Fix the bug
git commit -m "hotfix: critical bug in payment calculation"

# Deploy directo a staging para test rápido
supabase link --project-ref [STAGING_PROJECT_ID]
supabase db push

# Test rápido
# Si OK, merge a main y deploy a prod
git checkout main
git merge hotfix/critical-bug
git push

# Deploy a producción
supabase link --project-ref [PROD_PROJECT_ID]
supabase db push
```

### 2. Rollback de Migración
```bash
# Si algo salió mal en producción

# 1. Identificar la migración problemática
supabase db migrations list

# 2. Crear migración de reversión
supabase migration new revert_problematic_change

# 3. Escribir SQL para revertir
cat > supabase/migrations/[timestamp]_revert_problematic_change.sql << EOF
-- Revert changes from problematic migration
ALTER TABLE itineraries DROP COLUMN IF EXISTS priority;
DROP INDEX IF EXISTS idx_itineraries_priority;
EOF

# 4. Aplicar
supabase db push
```

### 3. Sincronizar Staging con Production
```bash
# Después de un deploy a producción
# Actualizar staging con datos frescos (sin datos sensibles)

# 1. Dump estructura de producción
supabase db dump --schema-only -f prod_schema.sql

# 2. Aplicar en staging
supabase link --project-ref [STAGING_PROJECT_ID]
psql $STAGING_DATABASE_URL < prod_schema.sql

# 3. Insertar datos de prueba
psql $STAGING_DATABASE_URL < supabase/seed/test_data.sql
```

## 🛡️ Mejores Prácticas

### 1. Migraciones
```sql
-- ✅ BUENO: Migraciones reversibles
ALTER TABLE itineraries ADD COLUMN IF NOT EXISTS priority TEXT;

-- ❌ MALO: Migraciones destructivas sin backup
DROP TABLE itineraries;
```

### 2. Edge Functions
```typescript
// ✅ BUENO: Manejo de errores
export async function handler(req: Request) {
  try {
    // Validar entrada
    const { itinerary_id } = await req.json();
    if (!itinerary_id) {
      return new Response(
        JSON.stringify({ error: 'itinerary_id required' }),
        { status: 400 }
      );
    }
    // Lógica...
  } catch (error) {
    console.error('Error:', error);
    return new Response(
      JSON.stringify({ error: 'Internal server error' }),
      { status: 500 }
    );
  }
}

// ❌ MALO: Sin validación ni manejo de errores
export async function handler(req: Request) {
  const { itinerary_id } = await req.json();
  // Crash si no hay itinerary_id
}
```

### 3. Testing
```dart
// ✅ BUENO: Tests que funcionan en cualquier entorno
testWidgets('should create itinerary', (tester) async {
  // Usar mocks o test data
  when(mockItineraryService.create(any))
    .thenAnswer((_) async => testItinerary);
    
  await tester.pumpWidget(MyApp());
  // ...
});

// ❌ MALO: Tests que dependen de datos de producción
testWidgets('should load specific itinerary', (tester) async {
  // Esto fallará en otros entornos
  final itinerary = await supabase
    .from('itineraries')
    .select()
    .eq('id', 'prod-specific-id-12345');
});
```

## 📊 Monitoreo

### Dashboards por Entorno
1. **Local**: Logs en consola
2. **Staging**: 
   - Supabase Dashboard (logs, queries)
   - Sentry (staging project)
3. **Production**:
   - Supabase Dashboard con alertas
   - Sentry (production project)
   - Uptime monitoring
   - Analytics

### Métricas Clave
- Response time de APIs
- Error rate
- Database connections
- Edge Function invocations
- Storage usage

## 🚨 Troubleshooting

### Problema: "Migration already exists"
```bash
# Solución: Sincronizar migraciones
supabase db migrations list
supabase db push --ignore-duplicates
```

### Problema: "Function deployment failed"
```bash
# Verificar logs
supabase functions logs [function-name]

# Re-deploy individual
supabase functions deploy [function-name]
```

### Problema: "Type mismatch after migration"
```bash
# Regenerar tipos TypeScript
supabase gen types typescript --project-id [PROJECT_ID] > lib/types/supabase.ts
```

## 🎯 Resumen del Flujo

1. **Desarrollador**: Trabaja en local con datos de prueba
2. **Pull Request**: Código revisado antes de merge
3. **Staging**: Pruebas completas en entorno similar a producción
4. **QA**: Valida funcionalidad y performance
5. **Production**: Deploy controlado con rollback plan
6. **Monitoreo**: Verificar que todo funcione correctamente

Este flujo garantiza:
- ✅ Código de calidad
- ✅ Sin sorpresas en producción
- ✅ Rollback fácil si hay problemas
- ✅ Trazabilidad completa