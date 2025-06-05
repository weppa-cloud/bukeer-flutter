#!/bin/bash

# ===========================================
# BUKEER PROJECT - Development Flow Script
# ===========================================
# Flujo de trabajo simplificado para desarrollo colaborativo
# Uso: ./flow.sh [comando] [opciones]

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Configuración
MAIN_BRANCH="main"
DEVELOP_BRANCH="develop"
REMOTE="origin"

# Logging
log() { echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }

# Banner
show_banner() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    🏦 BUKEER DEVELOPMENT FLOW               ║"
    echo "║                 Flujo de Trabajo Colaborativo                ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Verificar que estamos en un repo Git
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        error "No estamos en un repositorio Git"
        exit 1
    fi
}

# Verificar si hay cambios sin commit
check_clean_working_tree() {
    if ! git diff --quiet || ! git diff --staged --quiet; then
        error "Hay cambios sin commit. Usa 'flow save' primero"
        git status --short
        exit 1
    fi
}

# Comando: dev - Crear nueva rama de desarrollo
cmd_dev() {
    local feature_name="$1"
    
    if [ -z "$feature_name" ]; then
        error "Debes especificar un nombre para la funcionalidad"
        echo "Uso: ./flow.sh dev nombre-funcionalidad"
        exit 1
    fi
    
    log "🚀 Iniciando desarrollo de: $feature_name"
    
    # Verificar estado limpio
    check_clean_working_tree
    
    # Asegurar que estamos en la rama principal
    git checkout $MAIN_BRANCH
    git pull $REMOTE $MAIN_BRANCH
    
    # Crear y cambiar a nueva rama
    local branch_name="feature/$feature_name"
    git checkout -b "$branch_name"
    
    info "✅ Rama '$branch_name' creada y activa"
    info "🔧 Puedes empezar a desarrollar. Usa 'flow save' para guardar cambios"
}

# Comando: save - Guardar cambios con commit automático
cmd_save() {
    local message="$1"
    
    if [ -z "$message" ]; then
        log "💾 Guardando con auto-commit..."
        # Usar el script existente de auto-commit
        bash scripts/git_auto_commit.sh
    else
        log "💾 Guardando con mensaje: $message"
        git add .
        git commit -m "$message

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
    fi
    
    # Push a la rama actual
    local current_branch=$(git branch --show-current)
    if [ "$current_branch" != "$MAIN_BRANCH" ]; then
        log "📤 Subiendo cambios a $current_branch..."
        git push -u $REMOTE "$current_branch" || git push $REMOTE "$current_branch"
        info "✅ Cambios guardados y subidos"
    else
        warning "⚠️  Estás en $MAIN_BRANCH - no se hace push automático"
    fi
}

# Comando: test - Ejecutar pruebas
cmd_test() {
    log "🧪 Ejecutando pruebas..."
    
    # Flutter analyze
    info "🔍 Analizando código..."
    if ! flutter analyze; then
        error "❌ Errores en el análisis de código"
        exit 1
    fi
    
    # Flutter test (si existen)
    if [ -d "test" ] && [ "$(find test -name "*.dart" | wc -l)" -gt 0 ]; then
        info "🧪 Ejecutando tests..."
        if ! flutter test; then
            error "❌ Tests fallaron"
            exit 1
        fi
    else
        info "ℹ️  No hay tests para ejecutar"
    fi
    
    # Build check
    info "🔨 Verificando build..."
    if ! flutter build web --no-sound-null-safety > /dev/null 2>&1; then
        error "❌ Error en el build"
        exit 1
    fi
    
    log "✅ Todas las pruebas pasaron"
}

# Comando: pr - Crear Pull Request
cmd_pr() {
    local current_branch=$(git branch --show-current)
    
    if [ "$current_branch" = "$MAIN_BRANCH" ]; then
        error "No puedes crear PR desde $MAIN_BRANCH"
        exit 1
    fi
    
    log "📋 Creando Pull Request..."
    
    # Verificar que la rama está actualizada
    git push $REMOTE "$current_branch"
    
    # Ejecutar tests antes del PR
    cmd_test
    
    # Crear PR con gh CLI si está disponible
    if command -v gh &> /dev/null; then
        log "🔗 Creando PR con GitHub CLI..."
        
        # Obtener información para el PR
        local pr_title="$current_branch"
        local commits_since_main=$(git log --oneline $MAIN_BRANCH..HEAD)
        
        gh pr create \
            --title "$pr_title" \
            --body "$(cat <<EOF
## 🚀 Cambios en esta rama

$commits_since_main

## ✅ Tests
- [x] flutter analyze 
- [x] flutter test
- [x] flutter build web

## 📝 Descripción
Funcionalidad desarrollada en la rama \`$current_branch\`

🤖 Generated with [Claude Code](https://claude.ai/code)
EOF
)" \
            --base $MAIN_BRANCH \
            --head "$current_branch"
        
        log "✅ Pull Request creado"
    else
        warning "GitHub CLI no instalado. Crea el PR manualmente en:"
        echo "https://github.com/weppa-cloud/bukeer-flutter/compare/$MAIN_BRANCH...$current_branch"
    fi
}

# Comando: deploy - Hacer deploy (solo para admins)
cmd_deploy() {
    log "🚀 Iniciando deploy a producción..."
    
    local current_branch=$(git branch --show-current)
    
    if [ "$current_branch" = "$MAIN_BRANCH" ]; then
        # Ya estamos en main, solo hacer push
        check_clean_working_tree
        git pull $REMOTE $MAIN_BRANCH
        git push $REMOTE $MAIN_BRANCH
    else
        # Merge desde feature branch
        warning "⚠️  Esto va a hacer merge a $MAIN_BRANCH y deploy automático"
        read -p "¿Estás seguro? (y/N): " -n 1 -r
        echo
        
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            info "Deploy cancelado"
            exit 0
        fi
        
        # Ejecutar tests antes del merge
        cmd_test
        
        # Cambiar a main y hacer merge
        git checkout $MAIN_BRANCH
        git pull $REMOTE $MAIN_BRANCH
        git merge "$current_branch" --no-ff -m "feat: merge $current_branch

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
        
        # Push a main (esto activará CapRover)
        git push $REMOTE $MAIN_BRANCH
        
        # Limpiar rama de feature
        git branch -d "$current_branch"
        git push $REMOTE --delete "$current_branch"
    fi
    
    log "✅ Deploy completado - CapRover desplegará automáticamente"
    info "🌐 Revisa el deploy en tu panel de CapRover"
}

# Comando: status - Ver estado del proyecto
cmd_status() {
    log "📊 Estado del proyecto:"
    
    local current_branch=$(git branch --show-current)
    local total_commits=$(git rev-list --count HEAD)
    local uncommitted_changes=$(git status --porcelain | wc -l | tr -d ' ')
    
    info "🌿 Rama actual: $current_branch"
    info "📝 Total commits: $total_commits"
    info "📄 Cambios sin commit: $uncommitted_changes"
    
    if [ "$uncommitted_changes" -gt 0 ]; then
        warning "⚠️  Tienes cambios sin guardar:"
        git status --short
    fi
    
    # Mostrar últimos commits
    info "📚 Últimos 3 commits:"
    git log --oneline -3
}

# Comando: clean - Limpiar ramas viejas
cmd_clean() {
    log "🧹 Limpiando ramas viejas..."
    
    # Cambiar a main
    git checkout $MAIN_BRANCH
    git pull $REMOTE $MAIN_BRANCH
    
    # Limpiar ramas remotas eliminadas
    git remote prune $REMOTE
    
    # Mostrar ramas que se pueden eliminar
    local merged_branches=$(git branch --merged | grep -v "\*\|$MAIN_BRANCH\|$DEVELOP_BRANCH" | xargs -n 1 echo || true)
    
    if [ -n "$merged_branches" ]; then
        warning "Ramas que se pueden eliminar (ya están en $MAIN_BRANCH):"
        echo "$merged_branches"
        
        read -p "¿Eliminar estas ramas? (y/N): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "$merged_branches" | xargs -n 1 git branch -d
            log "✅ Ramas eliminadas"
        fi
    else
        info "✅ No hay ramas para limpiar"
    fi
}

# Ayuda
show_help() {
    show_banner
    echo -e "${BLUE}Uso: ./flow.sh [comando] [opciones]${NC}"
    echo ""
    echo "📋 Comandos disponibles:"
    echo ""
    echo -e "  ${GREEN}dev [nombre]${NC}     Crear nueva rama de desarrollo"
    echo -e "  ${GREEN}save [mensaje]${NC}   Guardar cambios (auto-commit si no hay mensaje)"
    echo -e "  ${GREEN}test${NC}             Ejecutar pruebas (analyze + test + build)"
    echo -e "  ${GREEN}pr${NC}               Crear Pull Request"
    echo -e "  ${GREEN}deploy${NC}           Deploy a producción (merge a main)"
    echo -e "  ${GREEN}status${NC}           Ver estado del proyecto"
    echo -e "  ${GREEN}clean${NC}            Limpiar ramas viejas"
    echo ""
    echo "📖 Ejemplos:"
    echo "  ./flow.sh dev nueva-funcionalidad"
    echo "  ./flow.sh save"
    echo "  ./flow.sh save \"fix: corregir bug en login\""
    echo "  ./flow.sh test"
    echo "  ./flow.sh pr"
    echo "  ./flow.sh deploy"
    echo ""
    echo "🔄 Flujo típico:"
    echo "  1. ./flow.sh dev mi-feature     # Crear rama"
    echo "  2. [desarrollar...]             # Hacer cambios"
    echo "  3. ./flow.sh save              # Guardar"
    echo "  4. ./flow.sh test              # Probar"
    echo "  5. ./flow.sh pr                # Pull Request"
    echo "  6. ./flow.sh deploy            # Deploy (tras revisión)"
}

# Verificar Git
check_git_repo

# Procesar comandos
case "${1:-help}" in
    dev)
        cmd_dev "$2"
        ;;
    save)
        cmd_save "$2"
        ;;
    test)
        cmd_test
        ;;
    pr)
        cmd_pr
        ;;
    deploy)
        cmd_deploy
        ;;
    status)
        cmd_status
        ;;
    clean)
        cmd_clean
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        error "Comando desconocido: $1"
        echo ""
        show_help
        exit 1
        ;;
esac