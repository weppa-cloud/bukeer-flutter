# 🏦 BUKEER - Flujo de Trabajo para Desarrollo Colaborativo

## 📋 Resumen

Sistema automatizado y seguro para desarrollo en equipo con **deploy automático** a producción vía CapRover.

## 🚀 Comandos Principales

### **Script Principal: `./flow.sh`**

```bash
# 🚀 EJECUCIÓN
./flow.sh run                     # Ejecutar app (Chrome con config correcta)
./flow.sh run ios                 # Ejecutar en iOS
./flow.sh run android             # Ejecutar en Android

# 🛠️  DESARROLLO
./flow.sh dev mi-funcionalidad    # Crear nueva rama
./flow.sh save                    # Guardar cambios (auto-commit)
./flow.sh save "fix: bug login"   # Guardar con mensaje custom

# 🧪 TESTING  
./flow.sh test                    # Ejecutar todas las pruebas

# 📋 COLABORACIÓN
./flow.sh pr                      # Crear Pull Request
./flow.sh status                  # Ver estado del proyecto
./flow.sh sync                    # Sincronizar con main (última versión)
./flow.sh clean                   # Limpiar ramas viejas

# 🚀 PRODUCCIÓN
./flow.sh deploy                  # Deploy a producción (solo admins)
```

## 🔄 Flujo de Trabajo Típico

### **Para Desarrollador Individual:**

```bash
# 1. Iniciar nueva funcionalidad
./flow.sh dev nueva-funcionalidad
# ↳ Crea rama feature/nueva-funcionalidad

# 2. Ejecutar app con configuración correcta
./flow.sh run
# ↳ Ejecuta con variables de entorno y config.js

# 3. Desarrollar y guardar frecuentemente
[... hacer cambios ...]
./flow.sh save
# ↳ Auto-commit inteligente + push

# 4. Probar antes de subir
./flow.sh test
# ↳ flutter analyze + flutter test + flutter build

# 5. Crear Pull Request
./flow.sh pr
# ↳ Crea PR en GitHub automáticamente

# 6. Deploy después de revisión
./flow.sh deploy
# ↳ Merge a main → CapRover auto-deploy 🚀
```

### **Para Equipo de 2+ Desarrolladores:**

```
Desarrollador A          │  Desarrollador B          │  Lead/Admin
━━━━━━━━━━━━━━━━━━━━━━━━━━━│━━━━━━━━━━━━━━━━━━━━━━━━━━━│━━━━━━━━━━━━━━━━━━━━
./flow.sh dev feature-A │ ./flow.sh dev feature-B  │
[desarrollar...]         │ [desarrollar...]          │
./flow.sh save          │ ./flow.sh save           │
./flow.sh test          │ ./flow.sh test           │
./flow.sh pr            │ ./flow.sh pr             │
                         │                           │ [revisar PRs]
                         │                           │ ./flow.sh deploy
                         │                           │      ↓
                         │                           │ 🌐 CapRover Deploy
```

## 🔄 Garantizar Última Versión del Código

### **📌 Buenas Prácticas Diarias:**

#### **🌅 Al Empezar el Día:**
```bash
# SIEMPRE empezar actualizando
git checkout main
git pull
./flow.sh dev tarea-del-dia
```

#### **🔄 Durante el Desarrollo:**
```bash
# Sincronizar frecuentemente (cada 2-3 horas)
./flow.sh sync              # Trae cambios de main a tu rama
./flow.sh save             # Guarda tu progreso
```

#### **📤 Antes de Pull Request:**
```bash
# OBLIGATORIO: Sincronizar antes de PR
./flow.sh sync              # Obtener últimos cambios
./flow.sh test             # Verificar que todo funciona
./flow.sh pr               # Crear PR
```

#### **🚨 Si hay Conflictos:**
```bash
./flow.sh sync
# Si aparecen conflictos:
# 1. Resolver en VS Code
# 2. git add .
# 3. git commit -m "merge: resolve conflicts with main"
# 4. ./flow.sh test
```

### **🛠️ Comandos de Verificación:**

```bash
# Ver si estás actualizado
./flow.sh status

# Ver cambios remotos sin descargar
git fetch
git log HEAD..origin/main --oneline

# Ver tus cambios vs main
git log origin/main..HEAD --oneline

# Comparar archivos
git diff origin/main --name-only
```

### **⚡ Flujo Automatizado:**

1. **`./flow.sh dev`** → Ya descarga lo último automáticamente
2. **`./flow.sh sync`** → Sincroniza en cualquier momento
3. **`./flow.sh deploy`** → Verifica actualización antes de deploy

### **🎯 Regla de Oro:**
> **"Sincroniza al empezar, sincroniza antes de PR, sincroniza si dudas"**

## 🔒 Protecciones Automáticas

### **🪝 Git Hooks Configurados:**

#### **Pre-commit** (antes de cada commit):
- ✅ **Auto-formatea** código Dart
- ✅ **Ejecuta** `flutter analyze`
- ✅ **Verifica** sintaxis de archivos modificados
- ✅ **Detecta** TODOs/FIXMEs (warning)
- ❌ **Bloquea** commit si hay errores críticos

#### **Pre-push** (antes de cada push):
- 🛡️ **Protege rama main** - requiere confirmación manual
- 🔍 **Detecta archivos grandes** (>1MB)
- 🔐 **Escanea secretos** (passwords, API keys, tokens)
- 🧪 **Ejecuta tests completos** en ramas feature
- 🔨 **Verifica build** antes de push
- ❌ **Bloquea** push si algo falla

#### **Post-commit** (después de cada commit):
- 💾 **Crea backups automáticos** (.git/auto-backups/)
- 📊 **Actualiza estadísticas** del proyecto
- 🧹 **Limpia archivos temporales**
- 📝 **Registra logs** detallados
- 🚀 **Notifica deploys** en rama main

## 🌿 Estrategia de Ramas

```
main
├── feature/nueva-funcionalidad-1    # Desarrollador A
├── feature/nueva-funcionalidad-2    # Desarrollador B
└── feature/hotfix-bug-critical      # Fixes urgentes
```

### **Ramas Protegidas:**
- **`main`** - Solo via Pull Request + Deploy autorizado
- Push directo requiere confirmación manual

### **Ramas de Trabajo:**
- **`feature/nombre-descriptivo`** - Nuevas funcionalidades
- **`fix/descripcion-bug`** - Corrección de bugs
- **`hotfix/descripcion-urgente`** - Fixes críticos

## 🚀 Deploy Automático

### **Configuración CapRover:**
- **Trigger:** Push a rama `main`
- **Dockerfile:** `Dockerfile.caprover`
- **Tiempo:** ~2-5 minutos (automático)

### **Proceso de Deploy:**
```
1. ./flow.sh deploy
   ↓
2. Merge a main + push
   ↓
3. CapRover detecta push
   ↓
4. Build automático (Docker)
   ↓
5. Deploy a producción 🌐
```

## 🛠️ Setup Inicial

### **1. Permisos del Script:**
```bash
chmod +x flow.sh
```

### **2. Git Hooks (ya configurados):**
```bash
# Los hooks ya están en .git/hooks/
ls -la .git/hooks/
# pre-commit, pre-push, post-commit ✅
```

### **3. GitHub CLI (opcional para PRs automáticos):**
```bash
# macOS
brew install gh

# Autenticar
gh auth login
```

### **4. Verificar Setup:**
```bash
./flow.sh status
```

## 🎯 Ejemplos Prácticos

### **Ejemplo 1: Nueva Funcionalidad**
```bash
# Iniciar
./flow.sh dev agregar-filtros-busqueda

# Desarrollar...
# Modificar lib/bukeer/productos/main_products_widget.dart
# Agregar filtros de búsqueda

# Guardar progreso
./flow.sh save "feat(products): add search filters UI"

# Continuar desarrollando...
# Implementar lógica de filtros

# Guardar final
./flow.sh save "feat(products): implement filter functionality"

# Sincronizar antes de PR
./flow.sh sync

# Probar
./flow.sh test

# Crear PR
./flow.sh pr

# Deploy (después de revisión)
./flow.sh deploy
```

### **Ejemplo 2: Fix Rápido**
```bash
# Bug crítico encontrado
./flow.sh dev fix-login-validation

# Cambio rápido
# Modificar lib/bukeer/users/auth_login/auth_login_widget.dart

# Guardar y probar
./flow.sh save "fix(auth): validate email format correctly"
./flow.sh test

# PR y deploy inmediato
./flow.sh pr
./flow.sh deploy
```

### **Ejemplo 3: Trabajo en Paralelo**
```bash
# Desarrollador A
./flow.sh dev mejoras-dashboard
./flow.sh save "feat(dashboard): add sales chart"

# Desarrollador B (al mismo tiempo)
./flow.sh dev optimizar-imagenes  
./flow.sh save "perf(images): lazy loading implementation"

# Ambos sincronizan antes de PR
./flow.sh sync  # (cada uno)
./flow.sh pr    # (cada uno)

# Admin revisa y hace deploy por separado
./flow.sh deploy  # PR de A
./flow.sh deploy  # PR de B
```

### **Ejemplo 4: Mantenerse Actualizado**
```bash
# Trabajando en feature larga (varios días)
./flow.sh dev feature-compleja

# Día 1
./flow.sh save "wip: initial structure"

# Día 2 - Empezar sincronizando
./flow.sh sync  # Traer cambios del día anterior
./flow.sh save "feat: add business logic"

# Día 3 - Antes de finalizar
./flow.sh sync  # Asegurar última versión
./flow.sh test
./flow.sh save "feat: complete feature with tests"
./flow.sh pr
```

## 🚨 Solución de Problemas

### **Hook Bloquea Commit:**
```bash
# Ver errores específicos
flutter analyze
flutter test

# Formatear código
dart format .

# Bypass hook (solo emergencias)
git commit --no-verify -m "emergency fix"
```

### **Hook Bloquea Push:**
```bash
# Ver qué está fallando
./flow.sh test

# Push a main bloqueado (correcto):
# Usar: ./flow.sh deploy

# Push con archivos grandes:
# Revisar y reducir tamaños, usar .gitignore
```

### **Build Falla:**
```bash
# Limpiar y reconstruir
flutter clean
flutter pub get
flutter build web --no-sound-null-safety
```

### **Hooks No Funcionan:**
```bash
# Verificar permisos
ls -la .git/hooks/
chmod +x .git/hooks/*

# Reinstalar hooks
./scripts/setup_git_hooks.sh  # (si existe)
```

## 📊 Monitoreo

### **Logs Automáticos:**
- `.git/hooks/pre-commit.log` - Verificaciones pre-commit
- `.git/hooks/pre-push.log` - Verificaciones pre-push  
- `.git/hooks/post-commit.log` - Post-commit activities
- `.git/deploy_history.log` - Historial de deploys

### **Backups Automáticos:**
- `.git/auto-backups/` - Backups por commit
- Retiene últimos 20 backups automáticamente

### **Estadísticas:**
```bash
./flow.sh status
# Muestra: rama, commits, cambios pendientes, últimos commits
```

## 🎉 Beneficios del Sistema

### **🛡️ Seguridad:**
- No pushes directos a main
- Detección de secretos
- Verificaciones automáticas
- Backups automáticos

### **🤖 Automatización:**
- Commits inteligentes
- Tests automáticos  
- Deploy automático
- Limpieza automática

### **👥 Colaboración:**
- Pull Requests automáticos
- Protección de conflictos
- Historial claro
- Branches organizados

### **🚀 Productividad:**
- Comandos simples
- Menos errores manuales
- Deploy inmediato
- Workflow consistente

---

## 📞 Soporte

Para problemas o mejoras del workflow:
1. Revisar logs en `.git/hooks/`
2. Ejecutar `./flow.sh status` para diagnóstico
3. Consultar este documento
4. Revisar `CLAUDE.md` para contexto del proyecto