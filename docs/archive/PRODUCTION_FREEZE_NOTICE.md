# 🚨 AVISO IMPORTANTE: Congelamiento de Cambios en Producción

**Fecha efectiva**: 2025-01-06  
**Estado**: ACTIVO

## ⛔ CAMBIOS DIRECTOS EN PRODUCCIÓN ESTÁN PROHIBIDOS

A partir de hoy, **NO se permiten cambios directos** en el ambiente de producción de Bukeer.

### ¿Por qué?
1. **Seguridad**: Evitar pérdida de datos o errores críticos
2. **Estabilidad**: Mantener el servicio funcionando para nuestros clientes
3. **Trazabilidad**: Poder rastrear todos los cambios realizados
4. **Calidad**: Probar todo antes de afectar a usuarios reales

### ✅ Nuevo Proceso (Efectivo Inmediatamente)

1. **Desarrollo Local**
   - Hacer todos los cambios en tu ambiente local
   - Probar exhaustivamente

2. **Code Review**
   - Crear Pull Request en GitHub
   - Obtener aprobación de al menos 1 reviewer

3. **Testing**
   - Ejecutar tests automatizados
   - Probar manualmente las funcionalidades afectadas

4. **Deployment**
   - Solo después de aprobación
   - Seguir proceso documentado
   - Monitorear después del deploy

### 🚫 Esto incluye:

- ❌ Cambios directos en Supabase Dashboard
- ❌ Modificaciones de tablas en producción
- ❌ Crear/modificar funciones RPC sin PR
- ❌ Cambiar Edge Functions directamente
- ❌ Modificar Row Level Security sin review
- ❌ Cualquier "arreglo rápido" en producción

### ⚡ ¿Emergencia en Producción?

Si hay una emergencia crítica:

1. **Notificar inmediatamente** al equipo en Slack/Discord
2. **Documentar** el problema y la solución propuesta
3. **Obtener aprobación** de al menos 2 personas del equipo
4. **Aplicar el fix** con extremo cuidado
5. **Crear PR retroactivo** documentando el cambio
6. **Post-mortem** obligatorio dentro de 24 horas

### 📋 Checklist antes de cualquier cambio:

- [ ] ¿Tienes backup reciente? (usar `scripts/backup_production.sh`)
- [ ] ¿El cambio fue probado localmente?
- [ ] ¿Hay PR aprobado?
- [ ] ¿Los tests pasan?
- [ ] ¿Documentaste el cambio?
- [ ] ¿Notificaste al equipo?

### 🎯 Próximos Pasos

1. **Esta semana**: Crear ambiente de staging
2. **Próxima semana**: Implementar CI/CD automático
3. **Este mes**: Pipeline completo dev → staging → prod

### 📞 Contactos

**Responsable del proceso**: [COMPLETAR]  
**Aprobadores autorizados**: [COMPLETAR]  
**Canal de emergencias**: [COMPLETAR]

---

**Este documento es efectivo inmediatamente.**  
Por favor confirma que lo has leído respondiendo en el canal del equipo.

Si tienes dudas sobre el proceso, pregunta ANTES de hacer cambios.