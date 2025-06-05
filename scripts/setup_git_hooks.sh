#!/bin/bash

# ===========================================
# BUKEER PROJECT - Git Hooks Setup
# ===========================================
# Configura hooks de Git para automatización

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Rutas
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOKS_DIR="$PROJECT_ROOT/.git/hooks"

log() {
    echo -e "${GREEN}[SETUP]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log "🔧 Configurando Git Hooks para Bukeer..."

# Crear directorio de hooks si no existe
mkdir -p "$HOOKS_DIR"

# ===========================================
# PRE-COMMIT HOOK
# ===========================================
log "📝 Creando pre-commit hook..."

cat > "$HOOKS_DIR/pre-commit" << 'EOF'
#!/bin/bash

# Pre-commit hook para Bukeer
# Ejecuta verificaciones antes de cada commit

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🔍 [PRE-COMMIT] Verificando cambios antes del commit...${NC}"

# Obtener archivos modificados
MODIFIED_DART_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.dart$' || true)

# Verificar sintaxis de archivos Dart
if [ -n "$MODIFIED_DART_FILES" ]; then
    echo -e "${GREEN}📝 Verificando sintaxis Dart...${NC}"
    
    for file in $MODIFIED_DART_FILES; do
        if [ -f "$file" ]; then
            # Verificar sintaxis básica
            if ! dart analyze "$file" &>/dev/null; then
                echo -e "${RED}❌ Error de sintaxis en: $file${NC}"
                echo -e "${YELLOW}💡 Ejecuta 'dart analyze $file' para ver detalles${NC}"
                exit 1
            fi
        fi
    done
    
    echo -e "${GREEN}✅ Sintaxis Dart verificada${NC}"
fi

# Verificar que no se commiteen archivos de configuración sensibles
SENSITIVE_FILES=$(git diff --cached --name-only | grep -E '\.(env|key|secret|pem)$|config/secrets|api_keys' || true)

if [ -n "$SENSITIVE_FILES" ]; then
    echo -e "${RED}❌ ALERTA: Intentando commitear archivos sensibles:${NC}"
    echo "$SENSITIVE_FILES"
    echo -e "${YELLOW}💡 Agrega estos archivos a .gitignore${NC}"
    exit 1
fi

# Verificar tamaño de archivos
LARGE_FILES=$(git diff --cached --name-only | xargs -I {} find {} -size +10M 2>/dev/null || true)

if [ -n "$LARGE_FILES" ]; then
    echo -e "${YELLOW}⚠️  Archivos grandes detectados (>10MB):${NC}"
    echo "$LARGE_FILES"
    echo -e "${YELLOW}💡 Considera usar Git LFS para archivos grandes${NC}"
fi

echo -e "${GREEN}✅ Pre-commit verificaciones completadas${NC}"
EOF

chmod +x "$HOOKS_DIR/pre-commit"
info "✅ Pre-commit hook creado"

# ===========================================
# POST-COMMIT HOOK
# ===========================================
log "📝 Creando post-commit hook..."

cat > "$HOOKS_DIR/post-commit" << 'EOF'
#!/bin/bash

# Post-commit hook para Bukeer
# Ejecuta acciones después de cada commit exitoso

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}✅ [POST-COMMIT] Commit exitoso!${NC}"

# Obtener información del commit
COMMIT_HASH=$(git rev-parse --short HEAD)
COMMIT_MESSAGE=$(git log -1 --pretty=format:"%s")
BRANCH=$(git branch --show-current)
FILES_CHANGED=$(git diff --name-only HEAD~1..HEAD | wc -l | tr -d ' ')

echo -e "${BLUE}📊 Información del commit:${NC}"
echo -e "${BLUE}  🔗 Hash: $COMMIT_HASH${NC}"
echo -e "${BLUE}  🌿 Branch: $BRANCH${NC}"
echo -e "${BLUE}  📝 Mensaje: $COMMIT_MESSAGE${NC}"
echo -e "${BLUE}  📄 Archivos cambiados: $FILES_CHANGED${NC}"

# Log del commit en archivo especial
LOG_FILE=".git/bukeer_commits.log"
echo "[$(date +'%Y-%m-%d %H:%M:%S')] $COMMIT_HASH | $BRANCH | $COMMIT_MESSAGE" >> "$LOG_FILE"

# Mantener solo los últimos 100 commits en el log
tail -100 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE" 2>/dev/null || true

# Si es un commit importante (más de 10 archivos o contiene palabras clave)
if [ "$FILES_CHANGED" -gt 10 ] || echo "$COMMIT_MESSAGE" | grep -qE "(feat|fix|refactor|major|release)"; then
    echo -e "${YELLOW}⭐ Commit importante detectado!${NC}"
    
    # Generar estadísticas rápidas
    TOTAL_COMMITS=$(git rev-list --all --count)
    DART_FILES=$(find lib -name "*.dart" 2>/dev/null | wc -l | tr -d ' ')
    
    echo -e "${BLUE}📈 Stats del proyecto:${NC}"
    echo -e "${BLUE}  📝 Total commits: $TOTAL_COMMITS${NC}"
    echo -e "${BLUE}  📄 Archivos Dart: $DART_FILES${NC}"
fi

echo -e "${GREEN}🎉 Post-commit completado${NC}"
EOF

chmod +x "$HOOKS_DIR/post-commit"
info "✅ Post-commit hook creado"

# ===========================================
# PRE-PUSH HOOK
# ===========================================
log "📝 Creando pre-push hook..."

cat > "$HOOKS_DIR/pre-push" << 'EOF'
#!/bin/bash

# Pre-push hook para Bukeer
# Ejecuta verificaciones antes de push

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 [PRE-PUSH] Verificando antes del push...${NC}"

# Verificar que no estamos en main/master sin autorización
CURRENT_BRANCH=$(git branch --show-current)

if [[ "$CURRENT_BRANCH" == "main" || "$CURRENT_BRANCH" == "master" ]]; then
    if [[ "$FORCE_PUSH_MAIN" != "true" ]]; then
        echo -e "${RED}❌ Push a $CURRENT_BRANCH bloqueado${NC}"
        echo -e "${YELLOW}💡 Usa: FORCE_PUSH_MAIN=true git push para forzar${NC}"
        exit 1
    fi
fi

# Verificar que el build está funcionando (solo si Flutter está disponible)
if command -v flutter &> /dev/null; then
    echo -e "${GREEN}🔨 Verificando que el proyecto compila...${NC}"
    
    # Intentar build para web (más rápido que otros targets)
    if ! flutter build web --no-pub --quiet &>/dev/null; then
        echo -e "${YELLOW}⚠️  El proyecto no compila correctamente${NC}"
        echo -e "${YELLOW}💡 Ejecuta 'flutter build web' para ver errores${NC}"
        
        # No bloquear el push, solo advertir
        read -p "¿Continuar con el push? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        echo -e "${GREEN}✅ Build exitoso${NC}"
    fi
fi

# Verificar que hay commits nuevos para pushear
COMMITS_TO_PUSH=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")

if [ "$COMMITS_TO_PUSH" -eq 0 ]; then
    echo -e "${YELLOW}ℹ️  No hay commits nuevos para pushear${NC}"
fi

echo -e "${GREEN}✅ Pre-push verificaciones completadas${NC}"
EOF

chmod +x "$HOOKS_DIR/pre-push"
info "✅ Pre-push hook creado"

# ===========================================
# CONFIGURAR GIT
# ===========================================
log "⚙️ Configurando Git settings..."

# Configurar Git para usar hooks
git config core.hooksPath .git/hooks

# Configurar otras opciones útiles
git config pull.rebase false
git config core.autocrlf input
git config core.safecrlf true

# Configurar alias útiles
git config alias.st "status"
git config alias.co "checkout"
git config alias.br "branch"
git config alias.ci "commit"
git config alias.unstage "reset HEAD --"
git config alias.last "log -1 HEAD"
git config alias.visual "!gitk"
git config alias.save "!bash scripts/git_smart_save.sh"
git config alias.smartsave "!bash scripts/git_smart_save.sh"

info "✅ Git configurado con alias útiles"

# ===========================================
# CREAR ARCHIVO DE CONFIGURACIÓN
# ===========================================
log "📄 Creando archivo de configuración..."

cat > "$PROJECT_ROOT/.git/bukeer_config" << EOF
# Configuración de Bukeer Git Automation
# Generado el $(date)

# Configuraciones de auto-commit
AUTO_COMMIT_ENABLED=true
AUTO_COMMIT_ON_SAVE=false
AUTO_PUSH_ENABLED=false

# Configuraciones de calidad
RUN_FLUTTER_ANALYZE=true
RUN_DART_FIX=false
BLOCK_ON_ERRORS=false

# Configuraciones de backup
AUTO_BACKUP_ENABLED=true
BACKUP_RETENTION_DAYS=30

# Configuraciones de hooks
PRE_COMMIT_CHECKS=true
POST_COMMIT_STATS=true
PRE_PUSH_BUILD_CHECK=true

# Última actualización: $(date)
EOF

info "✅ Archivo de configuración creado en .git/bukeer_config"

# ===========================================
# HACER ARCHIVOS EJECUTABLES
# ===========================================
log "🔧 Configurando permisos..."

chmod +x "$SCRIPT_DIR"/*.sh
chmod +x "$HOOKS_DIR"/*

# ===========================================
# CREAR COMANDO GLOBAL
# ===========================================
log "🌍 Creando comando global 'bukeer-save'..."

cat > "$PROJECT_ROOT/bukeer-save" << 'EOF'
#!/bin/bash
# Comando global para Bukeer Smart Save
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec bash "$SCRIPT_DIR/scripts/git_smart_save.sh" "$@"
EOF

chmod +x "$PROJECT_ROOT/bukeer-save"

info "✅ Comando global 'bukeer-save' creado"

# ===========================================
# MENSAJE FINAL
# ===========================================
echo ""
echo -e "${GREEN}🎉 ¡Git Hooks configurados exitosamente para Bukeer!${NC}"
echo ""
echo -e "${BLUE}📋 Comandos disponibles:${NC}"
echo -e "${BLUE}  git save                    # Guardado inteligente${NC}"
echo -e "${BLUE}  git smartsave               # Alias para git save${NC}"
echo -e "${BLUE}  ./bukeer-save               # Comando directo${NC}"
echo -e "${BLUE}  ./scripts/git_smart_save.sh # Script completo${NC}"
echo ""
echo -e "${BLUE}🔧 Hooks instalados:${NC}"
echo -e "${BLUE}  pre-commit   # Verificaciones antes de commit${NC}"
echo -e "${BLUE}  post-commit  # Estadísticas después de commit${NC}"
echo -e "${BLUE}  pre-push     # Verificaciones antes de push${NC}"
echo ""
echo -e "${BLUE}⚙️ Configuración en: .git/bukeer_config${NC}"
echo -e "${BLUE}📊 Logs en: .git/bukeer_auto_save.log${NC}"
echo ""
echo -e "${GREEN}✨ ¡Listo para usar! Ejecuta 'git save' para probar${NC}"