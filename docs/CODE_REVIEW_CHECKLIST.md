# ✅ Code Review Checklist - Bukeer

## 🔒 Seguridad (CRÍTICO)

### Información Sensible
- [ ] NO hay API keys hardcodeadas
- [ ] NO hay passwords o tokens en el código
- [ ] NO hay URLs de producción hardcodeadas
- [ ] NO hay información personal (emails reales, teléfonos)
- [ ] NO hay archivos `.env` o `secrets.dart` en el commit

### Validación de Datos
- [ ] Inputs de usuario están validados
- [ ] No hay inyección SQL posible
- [ ] URLs externas usan HTTPS
- [ ] Permisos están correctamente implementados

## 🎨 Sistema de Diseño

### Migración Completa
- [ ] NO usa `FlutterFlowTheme`
- [ ] USA `BukeerColors`, `BukeerTypography`, `BukeerSpacing`
- [ ] Todos los colores vienen del design system
- [ ] Espaciados usan tokens (no valores hardcodeados)

### Componentes
- [ ] Usa componentes de `/design_system/components/` cuando existen
- [ ] Nuevos componentes siguen la estructura estándar
- [ ] Componentes son responsive (mobile, tablet, desktop)

## 🏗️ Arquitectura

### Servicios y Estado
- [ ] USA `AppServices` en lugar de `FFAppState`
- [ ] NO modifica estado global innecesariamente
- [ ] Servicios se usan correctamente (user, ui, product, etc.)

### Estructura de Archivos
- [ ] Archivos en la carpeta correcta según CONTRIBUTING.md
- [ ] Nomenclatura sigue convenciones (snake_case, sufijos)
- [ ] Exports actualizados si es componente compartido

## 📊 Calidad de Código

### Análisis Estático
- [ ] `flutter analyze` pasa sin warnings
- [ ] `dart format` aplicado
- [ ] No hay código comentado sin razón
- [ ] No hay `print()` statements (usar `debugPrint`)

### Mejores Prácticas
- [ ] Funciones < 50 líneas
- [ ] Clases < 200 líneas
- [ ] No hay código duplicado
- [ ] Nombres de variables son descriptivos

## 🧪 Testing

### Cobertura
- [ ] Tests nuevos para funcionalidad nueva
- [ ] Tests existentes siguen pasando
- [ ] Tests usan helpers actualizados (no FFAppState)

### Validación Manual
- [ ] Probado en Chrome/Web
- [ ] Probado en diferentes tamaños de pantalla
- [ ] No rompe funcionalidad existente
- [ ] Dark mode funciona correctamente

## 📝 Documentación

### Código
- [ ] Funciones complejas tienen comentarios
- [ ] TODOs incluyen contexto y autor
- [ ] Cambios breaking están documentados

### PR
- [ ] Descripción clara del cambio
- [ ] Screenshots si hay cambios visuales
- [ ] Instrucciones de testing
- [ ] Referencias a issues

## ⚡ Performance

### Optimización
- [ ] No hay rebuilds innecesarios
- [ ] Imágenes están optimizadas
- [ ] Consultas a BD son eficientes
- [ ] No hay memory leaks evidentes

## 🚀 Checklist Rápido para PRs Pequeños

Para cambios menores (< 50 líneas):
- [ ] Sin información sensible
- [ ] Usa design system Bukeer
- [ ] flutter analyze pasa
- [ ] Probado localmente

## 🛑 Red Flags - Rechazar PR Inmediatamente

1. **Cualquier API key o secret visible**
2. **Uso de FlutterFlowTheme en código nuevo**
3. **Modificación no autorizada de:**
   - `/backend/schema/`
   - `/backend/api_requests/`
   - `pubspec.yaml` (sin justificación)
   - Archivos de configuración de Firebase
4. **Código que bypasea autenticación o permisos**
5. **Eliminación de tests sin justificación**

## 📋 Plantilla de Comentario para Rechazo

```markdown
### ❌ Cambios Requeridos

**Seguridad:**
- [ ] [Descripción del problema de seguridad]

**Sistema de Diseño:**
- [ ] Migrar de FlutterFlowTheme a BukeerDesign en líneas X, Y, Z

**Código:**
- [ ] [Problema específico y cómo solucionarlo]

**Ejemplo de cómo debería ser:**
```dart
// Código correcto aquí
```

Por favor aplica estos cambios y vuelve a solicitar revisión. 
¡Buen trabajo en [mencionar algo positivo]! 👍
```

## 📋 Plantilla de Comentario para Aprobación

```markdown
### ✅ LGTM (Looks Good To Me)

**Bien hecho:**
- ✨ Excelente uso del sistema de diseño
- 🔒 Código seguro y bien validado
- 📝 Documentación clara

**Sugerencias para el futuro (no blockers):**
- [Sugerencia opcional de mejora]

Aprobado para merge! 🚀
```

---

**Recordatorio**: Un buen code review no solo encuentra problemas, 
sino que también educa y mejora al equipo. Sé constructivo y específico. 🤝