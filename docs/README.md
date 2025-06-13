# 📚 Documentación Bukeer

## 🗺️ Navegación Rápida

### 🚀 Para Empezar
- **[Quick Start Guide](./01-getting-started/quick-start.md)** - Setup en 15 minutos
- **[Development Workflow](./02-development/workflow.md)** ⭐ - Flujo completo con flow.sh (incluye staging)
- **[Junior Onboarding](./04-guides/junior-onboarding.md)** - Plan de 3 días para nuevos devs

### 💻 Desarrollo
- **[Coding Standards](./CONTRIBUTING.md)** - Estándares de código
- **[Code Review Checklist](./CODE_REVIEW_CHECKLIST.md)** - Checklist para PRs
- **[Design System Migration](./DESIGN_SYSTEM_MIGRATION.md)** - Migrar de FlutterFlow

### 🏗️ Arquitectura
- **[Architecture Overview](./ARCHITECTURE.md)** - Arquitectura general
- **[Design System Guide](./BUKEER_DESIGN_SYSTEM_GUIDE.md)** - Sistema de diseño completo
- **[AppServices](./NEW_ARCHITECTURE_GUIDE.md)** - Nueva arquitectura de servicios

### 📖 Guías
- **[Testing Guide](./TESTING_GUIDE.md)** - Cómo escribir y ejecutar tests
- **[Performance Guide](./PERFORMANCE_GUIDE.md)** - Optimización y performance
- **[PWA Features](./PWA_FEATURES.md)** - Características PWA

## 📁 Estructura de Documentación

```
docs/
├── 01-getting-started/     # 🚀 Setup inicial
├── 02-development/         # 💻 Flujo de desarrollo
├── 03-architecture/        # 🏗️ Arquitectura (en migración)
├── 04-guides/             # 📖 Guías específicas  
├── 05-reference/          # 📋 Referencias rápidas (pendiente)
└── archive/               # 📦 Documentos antiguos
```

## 🔍 Buscar Documentación

```bash
# Buscar por tema
grep -r "flow.sh" docs/

# Buscar archivos
find docs -name "*onboarding*"

# Ver estructura
tree docs -L 2
```

## 📝 Estado de Migración

- ✅ **Completado**: Workflow, Onboarding, Quick Start
- 🚧 **En progreso**: Consolidación de arquitectura
- 📅 **Pendiente**: Referencias, comandos, variables de entorno

## 🆘 ¿No encuentras algo?

1. Busca en `/docs/archive/` para documentos antiguos
2. Revisa [CLAUDE.md](./CLAUDE.md) para contexto del proyecto
3. Pregunta al equipo en el canal de desarrollo

---

**Tip**: Usa `./flow.sh` para todo el desarrollo. Ver [workflow.md](./02-development/workflow.md) para detalles.