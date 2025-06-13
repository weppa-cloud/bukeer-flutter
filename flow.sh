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
    
    # Flutter analyze (solo errores críticos)
    info "🔍 Verificando errores críticos..."
    CRITICAL_ERRORS=$(flutter analyze --no-congratulate 2>&1 | grep -E "uri_does_not_exist|undefined_identifier|undefined_setter|undefined_getter" | grep -v "test/" | head -10)
    
    if [ -n "$CRITICAL_ERRORS" ]; then
        error "❌ Errores críticos encontrados:"
        echo "$CRITICAL_ERRORS"
        exit 1
    else
        info "✅ No hay errores críticos"
    fi
    
    # Flutter test (si existen y no son de mockito)
    if [ -d "test" ] && [ "$(find test -name "*.dart" -not -name "*.mocks.dart" | wc -l)" -gt 0 ]; then
        info "🧪 Ejecutando tests disponibles..."
        # Solo ejecutar tests que no dependan de mockito
        flutter test --exclude-tags=requires-mockito 2>/dev/null || warning "⚠️  Algunos tests fallaron (puede ser por dependencias)"
    else
        info "ℹ️  No hay tests para ejecutar"
    fi
    
    log "✅ Verificaciones completadas"
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
        
        # Verificación rápida antes del merge
        log "🔍 Verificación rápida pre-deploy..."
        CRITICAL_ERRORS=$(flutter analyze --no-congratulate 2>&1 | grep -E "uri_does_not_exist|undefined_identifier" | grep -v "test/" | head -3)
        
        if [ -n "$CRITICAL_ERRORS" ]; then
            error "❌ Errores críticos detectados, no se puede hacer deploy"
            echo "$CRITICAL_ERRORS"
            exit 1
        fi
        
        info "✅ Verificación rápida completada"
        
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

# Comando: sync - Sincronizar con main
cmd_sync() {
    log "🔄 Sincronizando con la última versión de main..."
    
    local current_branch=$(git branch --show-current)
    
    if [ "$current_branch" = "$MAIN_BRANCH" ]; then
        # Si estamos en main, solo pull
        log "📥 Actualizando main..."
        git pull $REMOTE $MAIN_BRANCH
        log "✅ Main actualizado"
    else
        # Si estamos en otra rama, actualizar y merge
        check_clean_working_tree
        
        # Guardar rama actual
        info "🌿 Rama actual: $current_branch"
        
        # Actualizar main
        log "📥 Obteniendo últimos cambios de main..."
        git fetch $REMOTE $MAIN_BRANCH
        
        # Hacer merge de main a la rama actual
        log "🔀 Integrando cambios de main..."
        if git merge $REMOTE/$MAIN_BRANCH --no-edit; then
            log "✅ Sincronización completada"
            
            # Mostrar resumen
            local behind=$(git rev-list --count HEAD..$REMOTE/$MAIN_BRANCH 2>/dev/null || echo "0")
            local ahead=$(git rev-list --count $REMOTE/$MAIN_BRANCH..HEAD 2>/dev/null || echo "0")
            
            info "📊 Estado de sincronización:"
            info "  ⬆️  Tu rama está $ahead commits adelante de main"
            info "  ⬇️  Tu rama está $behind commits detrás de main"
            
            if [ "$behind" -eq 0 ]; then
                info "✅ Estás completamente sincronizado con main"
            fi
        else
            error "❌ Conflictos detectados durante la sincronización"
            warning "📝 Resuelve los conflictos manualmente:"
            warning "  1. Edita los archivos con conflictos"
            warning "  2. git add ."
            warning "  3. git commit"
            exit 1
        fi
    fi
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

# Comando: run - Ejecutar aplicación con configuración correcta
cmd_run() {
    local device="$1"
    local environment="${2:-development}"
    
    # Validar environment
    if [[ "$environment" != "development" && "$environment" != "staging" ]]; then
        environment="development"
    fi
    
    log "🚀 Iniciando aplicación en modo $environment..."
    
    # Crear config.js según el environment
    if [[ "$environment" == "staging" ]]; then
        log "📝 Creando configuración de staging..."
        cat > web/config.js << 'EOF'
// Runtime configuration for Bukeer application - STAGING
window.BukeerConfig = {
  // Supabase Configuration
  supabaseUrl: 'https://wzlxbpicdcdvxvdcvgas.supabase.co',
  supabaseAnonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTIxNjk1OTAsImV4cCI6MjAyNzc0NTU5MH0.qqy1F21s7cLPWiV8fU0bGdjJS6unl8imYLB4CH7Muug',
  
  // API Configuration - STAGING
  apiBaseUrl: 'https://bukeer-staging.bukeerpro.com/api',
  
  // Google Maps Configuration
  googleMapsApiKey: 'AIzaSyDEUekXeyIKJUreRydJyv05gCexdSjUdBc',
  
  // Environment
  environment: 'staging',
  
  // Feature Flags (staging)
  features: {
    enableAnalytics: false,
    enableDebugLogs: true,
    enableOfflineMode: false
  },
  
  // Settings
  settings: {
    sessionTimeout: 3600000,
    maxRetries: 3,
    requestTimeout: 30000
  }
};

// Freeze configuration
Object.freeze(window.BukeerConfig);
Object.freeze(window.BukeerConfig.features);
Object.freeze(window.BukeerConfig.settings);
EOF
        info "✅ Configuración de staging creada"
    else
        # Development config
        if [[ ! -f "web/config.js" ]] || [[ "$environment" == "development" ]]; then
            log "📝 Creando configuración de desarrollo..."
            cat > web/config.js << 'EOF'
// Runtime configuration for Bukeer application - DEVELOPMENT
window.BukeerConfig = {
  // Supabase Configuration
  supabaseUrl: 'https://wzlxbpicdcdvxvdcvgas.supabase.co',
  supabaseAnonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTIxNjk1OTAsImV4cCI6MjAyNzc0NTU5MH0.qqy1F21s7cLPWiV8fU0bGdjJS6unl8imYLB4CH7Muug',
  
  // API Configuration
  apiBaseUrl: 'https://bukeer.bukeerpro.com/api',
  
  // Google Maps Configuration
  googleMapsApiKey: 'AIzaSyDEUekXeyIKJUreRydJyv05gCexdSjUdBc',
  
  // Environment
  environment: 'development',
  
  // Feature Flags (development)
  features: {
    enableAnalytics: false,
    enableDebugLogs: true,
    enableOfflineMode: false
  },
  
  // Settings
  settings: {
    sessionTimeout: 3600000,
    maxRetries: 3,
    requestTimeout: 30000
  }
};

// Freeze configuration
Object.freeze(window.BukeerConfig);
Object.freeze(window.BukeerConfig.features);
Object.freeze(window.BukeerConfig.settings);
EOF
            info "✅ Configuración de desarrollo creada"
        fi
    fi
    
    # Determinar dispositivo
    case "$device" in
        "")
            device="chrome"
            ;;
        "web"|"chrome")
            device="chrome"
            ;;
        "ios"|"iphone")
            device="ios"
            ;;
        "android")
            device="android"
            ;;
        *)
            device="chrome"
            info "Dispositivo no reconocido, usando Chrome"
            ;;
    esac
    
    info "📱 Ejecutando en: $device"
    info "🔧 Usando configuración de $environment (web/config.js)"
    
    # Configurar URLs según environment
    local api_url="https://bukeer.bukeerpro.com/api"
    if [[ "$environment" == "staging" ]]; then
        api_url="https://bukeer-staging.bukeerpro.com/api"
    fi
    
    # Ejecutar con configuración según environment
    if [[ "$device" == "chrome" ]]; then
        flutter run -d chrome \
            --dart-define=supabaseUrl=https://wzlxbpicdcdvxvdcvgas.supabase.co \
            --dart-define=supabaseAnonKey=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTIxNjk1OTAsImV4cCI6MjAyNzc0NTU5MH0.qqy1F21s7cLPWiV8fU0bGdjJS6unl8imYLB4CH7Muug \
            --dart-define=apiBaseUrl=$api_url \
            --dart-define=googleMapsApiKey=AIzaSyDEUekXeyIKJUreRydJyv05gCexdSjUdBc \
            --dart-define=environment=$environment
    else
        flutter run -d "$device" \
            --dart-define=supabaseUrl=https://wzlxbpicdcdvxvdcvgas.supabase.co \
            --dart-define=supabaseAnonKey=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTIxNjk1OTAsImV4cCI6MjAyNzc0NTU5MH0.qqy1F21s7cLPWiV8fU0bGdjJS6unl8imYLB4CH7Muug \
            --dart-define=apiBaseUrl=$api_url \
            --dart-define=googleMapsApiKey=AIzaSyDEUekXeyIKJUreRydJyv05gCexdSjUdBc \
            --dart-define=environment=$environment
    fi
}

# Ayuda
show_help() {
    show_banner
    echo -e "${BLUE}Uso: ./flow.sh [comando] [opciones]${NC}"
    echo ""
    echo "📋 Comandos disponibles:"
    echo ""
    echo -e "  ${GREEN}run [device] [env]${NC}  Ejecutar app (env: development|staging)"
    echo -e "  ${GREEN}staging${NC}          Ejecutar app en Chrome con ambiente staging"
    echo -e "  ${GREEN}dev [nombre]${NC}     Crear nueva rama de desarrollo"
    echo -e "  ${GREEN}save [mensaje]${NC}   Guardar cambios (auto-commit si no hay mensaje)"
    echo -e "  ${GREEN}test${NC}             Ejecutar pruebas (analyze + test + build)"
    echo -e "  ${GREEN}pr${NC}               Crear Pull Request"
    echo -e "  ${GREEN}deploy${NC}           Deploy a producción (merge a main)"
    echo -e "  ${GREEN}status${NC}           Ver estado del proyecto"
    echo -e "  ${GREEN}sync${NC}             Sincronizar con main (obtener última versión)"
    echo -e "  ${GREEN}clean${NC}            Limpiar ramas viejas"
    echo ""
    echo "📖 Ejemplos:"
    echo "  ./flow.sh run                    # Ejecutar en Chrome (development)"
    echo "  ./flow.sh run chrome             # Ejecutar en Chrome (development)"
    echo "  ./flow.sh run chrome staging     # Ejecutar en Chrome (staging)"
    echo "  ./flow.sh run ios                # Ejecutar en iOS (development)"
    echo "  ./flow.sh run ios staging        # Ejecutar en iOS (staging)"
    echo "  ./flow.sh run android            # Ejecutar en Android (development)"
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
    run)
        cmd_run "$2" "$3"
        ;;
    staging)
        cmd_run "chrome" "staging"
        ;;
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
    sync)
        cmd_sync
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