#!/bin/bash

# ===========================================
# BUKEER PROJECT - Smart Save Script
# ===========================================
# Script principal para guardado inteligente con Git
# Se puede llamar manualmente o desde hooks

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Configuración
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_FILE="$PROJECT_ROOT/.git/bukeer_auto_save.log"

# Función para logging
log() {
    local message="[$(date +'%Y-%m-%d %H:%M:%S')] $1"
    echo -e "${GREEN}$message${NC}"
    echo "$message" >> "$LOG_FILE"
}

error() {
    local message="[ERROR] $1"
    echo -e "${RED}$message${NC}"
    echo "$message" >> "$LOG_FILE"
}

warning() {
    local message="[WARNING] $1"
    echo -e "${YELLOW}$message${NC}"
    echo "$message" >> "$LOG_FILE"
}

info() {
    local message="[INFO] $1"
    echo -e "${BLUE}$message${NC}"
    echo "$message" >> "$LOG_FILE"
}

# Banner
echo -e "${PURPLE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    🏦 BUKEER SMART SAVE                     ║"
echo "║              Sistema de Guardado Inteligente con Git         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Verificar que estamos en el directorio correcto
cd "$PROJECT_ROOT"

# Verificar si hay cambios importantes
check_important_changes() {
    local changes=$(git status --porcelain)
    
    if [ -z "$changes" ]; then
        info "No hay cambios pendientes"
        return 1
    fi
    
    # Verificar si hay cambios en archivos importantes
    local important_changes=false
    
    while IFS= read -r line; do
        local file=$(echo "$line" | cut -c4-)
        
        case "$file" in
            # Archivos críticos del proyecto
            lib/services/* | \
            lib/bukeer/* | \
            lib/components/* | \
            lib/custom_code/* | \
            lib/config/* | \
            lib/main.dart | \
            lib/app_state*.dart | \
            pubspec.yaml | \
            README.md | \
            CLAUDE.md | \
            test/* )
                important_changes=true
                break
                ;;
        esac
    done <<< "$changes"
    
    if [ "$important_changes" = true ]; then
        log "🔍 Detectados cambios importantes que requieren guardado"
        return 0
    else
        info "Solo cambios menores detectados"
        return 1
    fi
}

# Verificar estado del proyecto
check_project_health() {
    log "🏥 Verificando salud del proyecto..."
    
    # Verificar que pubspec.yaml existe y es válido
    if [ ! -f "pubspec.yaml" ]; then
        error "❌ pubspec.yaml no encontrado"
        return 1
    fi
    
    # Verificar estructura básica de Flutter
    if [ ! -d "lib" ]; then
        error "❌ Directorio lib/ no encontrado"
        return 1
    fi
    
    # Verificar que main.dart existe
    if [ ! -f "lib/main.dart" ]; then
        error "❌ lib/main.dart no encontrado"
        return 1
    fi
    
    info "✅ Estructura del proyecto verificada"
    return 0
}

# Crear backup de seguridad
create_backup() {
    log "💾 Creando backup de seguridad..."
    
    local backup_dir="$PROJECT_ROOT/.git/backups"
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_name="bukeer_backup_$timestamp"
    
    mkdir -p "$backup_dir"
    
    # Crear backup de archivos importantes
    tar -czf "$backup_dir/$backup_name.tar.gz" \
        --exclude='.git' \
        --exclude='build' \
        --exclude='.dart_tool' \
        --exclude='node_modules' \
        lib/ test/ pubspec.yaml README.md CLAUDE.md 2>/dev/null || true
    
    # Mantener solo los últimos 10 backups
    cd "$backup_dir"
    ls -t bukeer_backup_*.tar.gz 2>/dev/null | tail -n +11 | xargs rm -f 2>/dev/null || true
    cd "$PROJECT_ROOT"
    
    info "✅ Backup creado: $backup_name.tar.gz"
}

# Ejecutar verificaciones de calidad de código
run_quality_checks() {
    log "🔍 Ejecutando verificaciones de calidad..."
    
    local has_errors=false
    
    # Flutter analyze
    if command -v flutter &> /dev/null; then
        info "Ejecutando flutter analyze..."
        if ! flutter analyze --no-congratulate 2>&1 | grep -E "(error •|Error:)" > /tmp/flutter_critical_errors.log; then
            info "✅ Análisis de Flutter exitoso"
        else
            warning "⚠️  Se encontraron errores críticos:"
            head -10 /tmp/flutter_critical_errors.log
            has_errors=true
        fi
    fi
    
    # Verificar sintaxis Dart en archivos modificados
    local dart_files=$(git diff --name-only --cached | grep '\.dart$' || true)
    if [ -n "$dart_files" ]; then
        info "Verificando sintaxis de archivos Dart..."
        for file in $dart_files; do
            if [ -f "$file" ]; then
                if ! dart analyze "$file" &>/dev/null; then
                    warning "⚠️  Errores de sintaxis en: $file"
                    has_errors=true
                fi
            fi
        done
    fi
    
    if [ "$has_errors" = true ]; then
        warning "⚠️  Se encontraron errores, pero continuando con el guardado"
    else
        info "✅ Verificaciones de calidad completadas"
    fi
}

# Función principal de guardado
smart_save() {
    log "🚀 Iniciando Smart Save..."
    
    # Verificar salud del proyecto
    if ! check_project_health; then
        error "❌ Proyecto en estado no saludable, abortando"
        exit 1
    fi
    
    # Verificar si hay cambios importantes
    if ! check_important_changes; then
        info "ℹ️  No hay cambios importantes para guardar"
        exit 0
    fi
    
    # Crear backup de seguridad
    create_backup
    
    # Ejecutar verificaciones de calidad
    run_quality_checks
    
    # Ejecutar el script de auto-commit
    log "📝 Ejecutando auto-commit..."
    if [ -f "$SCRIPT_DIR/git_auto_commit.sh" ]; then
        bash "$SCRIPT_DIR/git_auto_commit.sh"
    else
        error "❌ Script git_auto_commit.sh no encontrado"
        exit 1
    fi
    
    # Generar estadísticas
    generate_stats
    
    log "✅ Smart Save completado exitosamente!"
}

# Generar estadísticas del proyecto
generate_stats() {
    log "📊 Generando estadísticas del proyecto..."
    
    local total_commits=$(git rev-list --all --count 2>/dev/null || echo "0")
    local total_files=$(find lib -name "*.dart" | wc -l | tr -d ' ')
    local lines_of_code=$(find lib -name "*.dart" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
    local last_commit=$(git log -1 --pretty=format:"%h - %s (%an, %ar)" 2>/dev/null || echo "Sin commits")
    local current_branch=$(git branch --show-current 2>/dev/null || echo "unknown")
    
    info "📈 Estadísticas del proyecto:"
    info "  🔗 Branch actual: $current_branch"
    info "  📝 Total commits: $total_commits"
    info "  📄 Archivos Dart: $total_files"
    info "  📏 Líneas de código: $lines_of_code"
    info "  🕐 Último commit: $last_commit"
}

# Función para limpiar logs antiguos
cleanup_logs() {
    if [ -f "$LOG_FILE" ]; then
        # Mantener solo las últimas 1000 líneas del log
        tail -1000 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
    fi
}

# Función de ayuda
show_help() {
    echo -e "${BLUE}"
    echo "🏦 BUKEER SMART SAVE - Sistema de Guardado Inteligente"
    echo ""
    echo "Uso: $0 [OPCIÓN]"
    echo ""
    echo "Opciones:"
    echo "  save, -s, --save     Ejecutar guardado inteligente (por defecto)"
    echo "  check, -c, --check   Solo verificar cambios sin guardar"
    echo "  stats, --stats       Mostrar estadísticas del proyecto"
    echo "  backup, -b, --backup Solo crear backup"
    echo "  help, -h, --help     Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0                   # Guardado automático"
    echo "  $0 --check          # Solo verificar"
    echo "  $0 --stats          # Ver estadísticas"
    echo -e "${NC}"
}

# Procesar argumentos
case "${1:-save}" in
    save|-s|--save)
        smart_save
        ;;
    check|-c|--check)
        log "🔍 Verificando cambios..."
        check_project_health
        if check_important_changes; then
            log "✅ Hay cambios importantes pendientes de guardar"
        else
            log "ℹ️  No hay cambios importantes"
        fi
        ;;
    stats|--stats)
        generate_stats
        ;;
    backup|-b|--backup)
        create_backup
        ;;
    help|-h|--help)
        show_help
        ;;
    *)
        error "Opción desconocida: $1"
        show_help
        exit 1
        ;;
esac

# Limpiar logs al final
cleanup_logs