# Tools - Bukeer Development

Esta carpeta contiene herramientas de desarrollo, scripts y utilidades para el proyecto Bukeer.

## Estructura

### `/scripts/`
Scripts de automatización y utilidades:
- **`bukeer-save`** - Script de guardado automático (legacy)

### `/testing/`
Scripts de testing y validación:
- **`runtime_test_services.dart`** - Testing de servicios en runtime
- **`test_services_migration.dart`** - Testing de migración de servicios
- **`test_services_quick.dart`** - Testing rápido de servicios

## Scripts Principales (en `/scripts/`)

### Git y Workflow
- **`scripts/git_auto_commit.sh`** - Auto-commit inteligente
- **`scripts/git_smart_save.sh`** - Guardado inteligente
- **`scripts/setup_git_hooks.sh`** - Configuración de Git hooks

### Development
- **`flow.sh`** (en root) - Script principal de desarrollo

## Uso

### Testing de Servicios
```bash
# Test completo de servicios
dart tools/testing/runtime_test_services.dart

# Test rápido
dart tools/testing/test_services_quick.dart

# Test de migración
dart tools/testing/test_services_migration.dart
```

### Scripts de Git
```bash
# Usar flow.sh principal
./flow.sh save
./flow.sh test
./flow.sh deploy

# Scripts individuales
./scripts/git_smart_save.sh
./scripts/git_auto_commit.sh
```

## Notas
- Los scripts de testing son para validación de arquitectura
- Los scripts de Git están integrados en el workflow principal
- `bukeer-save` es legacy, usar `flow.sh` en su lugar