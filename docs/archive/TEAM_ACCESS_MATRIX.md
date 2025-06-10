# Matriz de Accesos del Equipo - Bukeer

> **DOCUMENTO CONFIDENCIAL** - No compartir fuera del equipo
> Última actualización: 2025-01-06

## 🔐 Accesos Críticos

### Supabase (Producción)
| Recurso | URL | Quién tiene acceso | Nivel | Notas |
|---------|-----|-------------------|-------|-------|
| Dashboard | https://supabase.com/dashboard/project/wzlxbpicdcdvxvdcvgas | [COMPLETAR] | Admin | |
| API Keys | Settings > API | [COMPLETAR] | Admin | Anon Key en código |
| Database | Settings > Database | [COMPLETAR] | Admin | Connection string sensible |
| Edge Functions | Functions | [COMPLETAR] | Developer | |
| Storage | Storage | [COMPLETAR] | Developer | |

### GitHub
| Repositorio | URL | Quién tiene acceso | Nivel | Notas |
|------------|-----|-------------------|-------|-------|
| bukeer-flutter | [COMPLETAR] | [COMPLETAR] | | |

### Hosting / Deployment
| Servicio | URL | Quién tiene acceso | Nivel | Notas |
|----------|-----|-------------------|-------|-------|
| [COMPLETAR] | | | | |

### Dominios
| Dominio | Registrador | Quién tiene acceso | Notas |
|---------|-------------|-------------------|-------|
| [COMPLETAR] | | | |

### Servicios Externos
| Servicio | Uso | Quién tiene acceso | API Key Location |
|----------|-----|-------------------|------------------|
| Google Maps | Mapas | [COMPLETAR] | AppConfig |
| OpenAI | IA para textos | [COMPLETAR] | Edge Functions |
| Duffel | Datos de vuelos | [COMPLETAR] | [COMPLETAR] |
| Serper | Búsquedas web | [COMPLETAR] | Edge Functions |

### Monitoreo y Analytics
| Servicio | URL | Quién tiene acceso | Estado |
|----------|-----|-------------------|--------|
| [COMPLETAR] | | | |

## 👥 Roles y Responsabilidades

### Administradores
- **[NOMBRE]**: Acceso completo a todos los servicios
- **[NOMBRE]**: [DESCRIBIR ACCESOS]

### Desarrolladores
- **[NOMBRE]**: [DESCRIBIR ACCESOS]
- **[NOMBRE]**: [DESCRIBIR ACCESOS]

### QA/Testing
- **[NOMBRE]**: [DESCRIBIR ACCESOS]

### Soporte
- **[NOMBRE]**: [DESCRIBIR ACCESOS]

## 🚨 Procedimientos de Emergencia

### Si alguien deja el equipo:
1. [ ] Revocar acceso a Supabase
2. [ ] Cambiar API keys si tenía acceso
3. [ ] Remover de GitHub
4. [ ] Actualizar este documento

### Si se compromete una credencial:
1. [ ] Rotar inmediatamente en Supabase
2. [ ] Actualizar en el código
3. [ ] Desplegar cambios
4. [ ] Notificar al equipo

### Recuperación de acceso:
- Contacto principal: [NOMBRE] - [EMAIL/TELÉFONO]
- Contacto secundario: [NOMBRE] - [EMAIL/TELÉFONO]

## 📋 Checklist de Seguridad

### Mensual
- [ ] Revisar esta lista de accesos
- [ ] Verificar que no hay accesos no autorizados
- [ ] Rotar credenciales si es necesario

### Cuando alguien se une al equipo
- [ ] Agregar a esta matriz
- [ ] Dar solo los accesos mínimos necesarios
- [ ] Documentar fecha de acceso

## 🔑 Ubicación de Credenciales

> **NUNCA** guardar credenciales en:
> - Código fuente
> - Documentos públicos
> - Chats o emails

### Credenciales de Producción
- **¿Dónde están?**: [COMPLETAR - ej: 1Password, LastPass, etc.]
- **Quién las administra**: [COMPLETAR]

### Credenciales de Desarrollo/Staging
- **¿Dónde están?**: [COMPLETAR]
- **Quién las administra**: [COMPLETAR]

## ⚠️ Notas Importantes

1. **NUNCA** compartir credenciales por canales no seguros
2. **SIEMPRE** usar 2FA donde sea posible
3. **REVISAR** este documento mensualmente
4. **ACTUALIZAR** inmediatamente cuando hay cambios

---

**Para completar este documento:**
1. Reemplaza todos los [COMPLETAR] con la información real
2. Guarda en un lugar seguro (NO en el repo público)
3. Comparte solo con personas autorizadas
4. Mantén actualizado