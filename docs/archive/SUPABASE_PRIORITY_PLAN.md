# Plan de Prioridades para Supabase - Bukeer

## 🎯 Análisis de Situación Actual

### Riesgos Críticos Identificados
1. **🔴 Sin ambiente de desarrollo/staging** - Todo se hace en producción
2. **🔴 Sin backups documentados** - Solo confiamos en Supabase automático
3. **🟡 Funciones RPC faltantes** - Código busca funciones que no existen
4. **🟡 Sin índices de performance** - Queries lentas con 7,813+ registros
5. **🟡 Sin monitoreo de errores** - No sabemos qué falla en producción

## 📋 Plan de Acción por Fases

### 🚨 FASE 0: Proteger Producción (1-2 días)
**Objetivo**: Asegurar que no perdamos datos mientras hacemos cambios

#### Tareas:
1. **Backup completo manual**
   ```bash
   # Crear backup completo AHORA
   supabase db dump --db-url "postgresql://..." -f backup_prod_$(date +%Y%m%d).sql
   ```

2. **Documentar accesos actuales**
   - ¿Quién tiene acceso al dashboard?
   - ¿Quién puede hacer cambios en BD?
   - ¿Dónde están las credenciales?

3. **Congelar cambios directos**
   - Comunicar al equipo: "NO más cambios directos en producción"
   - Todos los cambios pasan por PR

**Entregables**:
- [ ] backup_prod_20250609.sql
- [ ] TEAM_ACCESS_MATRIX.md
- [ ] Comunicación enviada al equipo

---

### 🏗️ FASE 1: Crear Ambiente Seguro (3-5 días)
**Objetivo**: Tener donde desarrollar sin riesgo

#### Tareas:
1. **Crear proyecto Staging en Supabase**
   - Mismo plan que producción
   - Misma región
   - Configuración idéntica

2. **Migrar esquema a staging**
   ```bash
   # Aplicar estructura
   supabase db push --db-url "staging_url"
   
   # Cargar datos sintéticos
   psql staging_url -f synthetic_data.sql
   ```

3. **Configurar multi-ambiente en Flutter**
   - Implementar environment_config.dart
   - Agregar scripts de cambio de ambiente
   - Probar que funcione

**Entregables**:
- [ ] Staging funcionando
- [ ] Flutter con selector de ambiente
- [ ] Documentación para desarrolladores

---

### ⚡ FASE 2: Quick Wins de Performance (1 semana)
**Objetivo**: Mejorar performance sin riesgo

#### Tareas:
1. **Crear índices críticos**
   ```sql
   -- En staging primero, luego producción
   CREATE INDEX CONCURRENTLY idx_itineraries_account_id ON itineraries(account_id);
   CREATE INDEX CONCURRENTLY idx_itinerary_items_itinerary_id ON itinerary_items(itinerary_id);
   CREATE INDEX CONCURRENTLY idx_contacts_account_id ON contacts(account_id);
   ```

2. **Optimizar queries lentas**
   - Identificar top 10 queries lentas
   - Crear vistas materializadas para dashboards
   - Implementar paginación donde falte

3. **Limpiar datos obsoletos**
   - Archivar itinerarios antiguos
   - Comprimir logs
   - Vacum de tablas

**Entregables**:
- [ ] 50% mejora en queries principales
- [ ] Dashboard más rápido
- [ ] Reducción de tamaño de BD

---

### 🔧 FASE 3: Arreglar Funcionalidad Rota (2 semanas)
**Objetivo**: Que todo funcione como se espera

#### Tareas:
1. **Mapear funciones faltantes**
   - Lista de funciones que el código busca
   - Crear o renombrar para que coincidan
   - Probar en staging

2. **Estandarizar tipos de datos**
   - Migrar todos los IDs a UUID
   - Validar JSONs con constraints
   - Normalizar datos donde sea necesario

3. **Implementar funciones críticas**
   ```sql
   -- Ejemplo: función que falta
   CREATE OR REPLACE FUNCTION function_get_contacts_search(...)
   ```

**Entregables**:
- [ ] Todas las funciones RPC funcionando
- [ ] Sin errores 404 en la app
- [ ] Tests de integración pasando

---

### 📊 FASE 4: Monitoreo y Observabilidad (1 semana)
**Objetivo**: Saber qué pasa en producción

#### Tareas:
1. **Implementar Sentry**
   - Proyecto para staging
   - Proyecto para producción
   - Alertas configuradas

2. **Logging estructurado**
   - Logs en Edge Functions
   - Tracking de errores
   - Métricas de performance

3. **Dashboard de salud**
   - Uptime monitoring
   - Alertas de espacio en disco
   - Queries lentas

**Entregables**:
- [ ] Sentry capturando errores
- [ ] Dashboard de métricas
- [ ] Alertas configuradas

---

### 🚀 FASE 5: CI/CD y Automatización (2 semanas)
**Objetivo**: Deployments seguros y automáticos

#### Tareas:
1. **Pipeline de CI/CD**
   - Tests automáticos
   - Deploy a staging automático
   - Deploy a producción con aprobación

2. **Migraciones automatizadas**
   - Versionado de esquema
   - Rollback automático
   - Tests de migración

3. **Documentación automática**
   - Generar docs de API
   - Documentar cambios
   - Changelog automático

**Entregables**:
- [ ] GitHub Actions configurado
- [ ] Deployments sin downtime
- [ ] Documentación al día

---

## 📅 Timeline Propuesto

```
Semana 1: Fase 0 + Inicio Fase 1
Semana 2: Completar Fase 1 + Inicio Fase 2
Semana 3: Fase 2 + Inicio Fase 3
Semana 4-5: Fase 3
Semana 6: Fase 4
Semana 7-8: Fase 5
```

## 💰 Costos Estimados

| Item | Costo Mensual | Notas |
|------|---------------|-------|
| Staging Supabase | $25 | Plan Pro mínimo |
| Sentry | $26 | Plan Team |
| Monitoring | $0-50 | Depende de herramienta |
| **Total** | **$51-101** | Por mes |

## 🎯 Métricas de Éxito

### Fase 0-1
- ✅ Cero cambios directos en producción
- ✅ Staging funcionando

### Fase 2
- ✅ Queries 50% más rápidas
- ✅ Cero timeouts en dashboard

### Fase 3
- ✅ Cero errores 404 de funciones
- ✅ 100% tests pasando

### Fase 4
- ✅ < 1% error rate
- ✅ < 500ms response time P95

### Fase 5
- ✅ Deployments en < 10 minutos
- ✅ Rollback en < 2 minutos

## ⚠️ Riesgos y Mitigaciones

| Riesgo | Impacto | Mitigación |
|--------|---------|------------|
| Romper producción | Alto | Backups + staging |
| Resistencia del equipo | Medio | Capacitación + quick wins |
| Costos adicionales | Bajo | ROI en estabilidad |
| Tiempo de desarrollo | Medio | Fases incrementales |

## 🤝 Requerimientos del Equipo

### Necesitamos:
1. **1 DevOps** (part-time) - Para CI/CD
2. **1 DBA** (consultant) - Para optimizaciones
3. **Desarrolladores** - Adoptar nuevo flujo

### Compromiso de:
- **CTO/Lead**: Aprobar plan y recursos
- **Equipo**: No más cambios en producción
- **QA**: Probar en staging

## 📝 Próximos Pasos Inmediatos

1. **HOY**: 
   - [ ] Hacer backup manual
   - [ ] Compartir este plan con el equipo

2. **MAÑANA**:
   - [ ] Crear proyecto staging en Supabase
   - [ ] Comenzar documentación de accesos

3. **ESTA SEMANA**:
   - [ ] Tener staging funcionando
   - [ ] Primer PR usando nuevo flujo

---

**¿Aprobamos este plan?** 

Si hay ajustes o prioridades diferentes, podemos modificarlo antes de comenzar.