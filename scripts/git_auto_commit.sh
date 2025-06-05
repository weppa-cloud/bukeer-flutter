#!/bin/bash

# ===========================================
# BUKEER PROJECT - Auto Commit Script
# ===========================================
# Este script realiza commits automáticos inteligentes
# Analiza los cambios y crea commits descriptivos

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para logging
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Verificar si estamos en un repositorio Git
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    error "No estamos en un repositorio Git"
    exit 1
fi

# Verificar si hay cambios
if git diff --quiet && git diff --staged --quiet; then
    info "No hay cambios para hacer commit"
    exit 0
fi

log "🔍 Analizando cambios para auto-commit..."

# Crear arrays para categorizar archivos
declare -a new_files=()
declare -a modified_files=()
declare -a deleted_files=()
declare -a feature_files=()
declare -a fix_files=()
declare -a test_files=()
declare -a doc_files=()
declare -a config_files=()

# Analizar archivos modificados
while IFS= read -r line; do
    status=$(echo "$line" | cut -c1-2)
    file=$(echo "$line" | cut -c4-)
    
    case "$status" in
        "A " | "??" ) new_files+=("$file") ;;
        "M " | " M" ) modified_files+=("$file") ;;
        "D " | " D" ) deleted_files+=("$file") ;;
    esac
    
    # Categorizar por tipo de archivo
    case "$file" in
        *test* | *spec* | test/* | *_test.dart | *Test.dart )
            test_files+=("$file") ;;
        *.md | README* | docs/* | **/README* | CHANGELOG* | LICENSE* )
            doc_files+=("$file") ;;
        pubspec.yaml | pubspec.lock | *.json | *.yaml | *.yml | analysis_options.yaml | .gitignore )
            config_files+=("$file") ;;
        lib/services/* | lib/bukeer/* | lib/components/* | lib/custom_code/* )
            if [[ "$file" == *fix* ]] || [[ "$file" == *bug* ]] || [[ "$file" == *error* ]]; then
                fix_files+=("$file")
            else
                feature_files+=("$file")
            fi ;;
        * )
            if [[ "$file" == *fix* ]] || [[ "$file" == *bug* ]] || [[ "$file" == *error* ]]; then
                fix_files+=("$file")
            else
                feature_files+=("$file")
            fi ;;
    esac
done < <(git status --porcelain)

# Función para generar mensaje de commit inteligente
generate_commit_message() {
    local type=""
    local scope=""
    local description=""
    local details=""
    
    # Determinar tipo principal de cambio
    if [ ${#test_files[@]} -gt 0 ] && [ ${#feature_files[@]} -eq 0 ] && [ ${#fix_files[@]} -eq 0 ]; then
        type="test"
        description="add/update tests"
        if [ ${#test_files[@]} -le 3 ]; then
            details="- $(printf '%s\n' "${test_files[@]}" | head -3 | sed 's/.*\///' | tr '\n' ' ')"
        else
            details="- ${#test_files[@]} test files updated"
        fi
    elif [ ${#doc_files[@]} -gt 0 ] && [ ${#feature_files[@]} -eq 0 ] && [ ${#fix_files[@]} -eq 0 ]; then
        type="docs"
        description="update documentation"
        details="- $(printf '%s\n' "${doc_files[@]}" | head -3 | sed 's/.*\///' | tr '\n' ' ')"
    elif [ ${#config_files[@]} -gt 0 ] && [ ${#feature_files[@]} -eq 0 ] && [ ${#fix_files[@]} -eq 0 ]; then
        type="chore"
        description="update configuration"
        details="- $(printf '%s\n' "${config_files[@]}" | head -3 | sed 's/.*\///' | tr '\n' ' ')"
    elif [ ${#fix_files[@]} -gt 0 ]; then
        type="fix"
        description="resolve issues and bugs"
        if [ ${#fix_files[@]} -le 3 ]; then
            details="- $(printf '%s\n' "${fix_files[@]}" | head -3 | sed 's/.*\///' | tr '\n' ' ')"
        else
            details="- ${#fix_files[@]} files with bug fixes"
        fi
    elif [ ${#feature_files[@]} -gt 0 ]; then
        type="feat"
        
        # Determinar scope basado en archivos modificados
        if [[ " ${feature_files[*]} " =~ " lib/services/" ]]; then
            scope="services"
        elif [[ " ${feature_files[*]} " =~ " lib/bukeer/auth" ]]; then
            scope="auth"
        elif [[ " ${feature_files[*]} " =~ " lib/bukeer/itinerarios" ]]; then
            scope="itinerary"
        elif [[ " ${feature_files[*]} " =~ " lib/bukeer/productos" ]]; then
            scope="products"
        elif [[ " ${feature_files[*]} " =~ " lib/bukeer/contactos" ]]; then
            scope="contacts"
        elif [[ " ${feature_files[*]} " =~ " lib/bukeer/dashboard" ]]; then
            scope="dashboard"
        elif [[ " ${feature_files[*]} " =~ " lib/components" ]]; then
            scope="components"
        elif [[ " ${feature_files[*]} " =~ " lib/custom_code" ]]; then
            scope="actions"
        else
            scope="core"
        fi
        
        description="implement new functionality"
        if [ ${#feature_files[@]} -le 5 ]; then
            details="- $(printf '%s\n' "${feature_files[@]}" | head -5 | sed 's/.*\///' | tr '\n' ' ')"
        else
            details="- ${#feature_files[@]} files with new features"
        fi
    elif [ ${#new_files[@]} -gt 0 ]; then
        type="feat"
        scope="core"
        description="add new files and functionality"
        if [ ${#new_files[@]} -le 5 ]; then
            details="- $(printf '%s\n' "${new_files[@]}" | head -5 | sed 's/.*\///' | tr '\n' ' ')"
        else
            details="- ${#new_files[@]} new files added"
        fi
    else
        type="chore"
        description="update project files"
        details="- $(( ${#modified_files[@]} + ${#new_files[@]} + ${#deleted_files[@]} )) files changed"
    fi
    
    # Construir mensaje final
    local commit_msg=""
    if [ -n "$scope" ]; then
        commit_msg="${type}(${scope}): ${description}"
    else
        commit_msg="${type}: ${description}"
    fi
    
    # Agregar detalles si existen
    if [ -n "$details" ] && [ ${#details} -lt 200 ]; then
        commit_msg="${commit_msg}

${details}

🤖 Auto-commit generated on $(date +'%Y-%m-%d %H:%M:%S')
📊 Stats: ${#new_files[@]} new, ${#modified_files[@]} modified, ${#deleted_files[@]} deleted"
    else
        commit_msg="${commit_msg}

🤖 Auto-commit generated on $(date +'%Y-%m-%d %H:%M:%S')
📊 Stats: ${#new_files[@]} new, ${#modified_files[@]} modified, ${#deleted_files[@]} deleted"
    fi
    
    echo "$commit_msg"
}

# Mostrar resumen de cambios
info "📊 Resumen de cambios:"
[ ${#new_files[@]} -gt 0 ] && info "  ➕ ${#new_files[@]} archivos nuevos"
[ ${#modified_files[@]} -gt 0 ] && info "  ✏️  ${#modified_files[@]} archivos modificados"
[ ${#deleted_files[@]} -gt 0 ] && info "  ❌ ${#deleted_files[@]} archivos eliminados"
[ ${#test_files[@]} -gt 0 ] && info "  🧪 ${#test_files[@]} archivos de testing"
[ ${#doc_files[@]} -gt 0 ] && info "  📚 ${#doc_files[@]} archivos de documentación"
[ ${#config_files[@]} -gt 0 ] && info "  ⚙️  ${#config_files[@]} archivos de configuración"

# Ejecutar análisis de código antes del commit
log "🔍 Ejecutando análisis de código..."

# Flutter analyze (solo errores críticos)
if command -v flutter &> /dev/null; then
    info "Ejecutando flutter analyze..."
    if ! flutter analyze --no-congratulate 2>&1 | grep -E "(error|Error)" > /tmp/flutter_errors.log; then
        info "✅ No se encontraron errores críticos en el análisis"
    else
        warning "⚠️  Se encontraron algunos errores, pero continuando con el commit"
        cat /tmp/flutter_errors.log
    fi
fi

# Agregar archivos importantes primero
log "📥 Agregando archivos al staging area..."

# Agregar archivos por categorías, priorizando los más importantes
for category in "config_files" "doc_files" "test_files" "feature_files" "fix_files"; do
    declare -n arr=$category
    if [ ${#arr[@]} -gt 0 ]; then
        for file in "${arr[@]}"; do
            if [ -f "$file" ] || [ -d "$file" ]; then
                git add "$file"
                info "  ✅ $file"
            fi
        done
    fi
done

# Agregar archivos nuevos
for file in "${new_files[@]}"; do
    if [ -f "$file" ] || [ -d "$file" ]; then
        git add "$file"
        info "  ➕ $file"
    fi
done

# Generar mensaje de commit
commit_message=$(generate_commit_message)

log "📝 Mensaje de commit generado:"
echo -e "${BLUE}${commit_message}${NC}"

# Realizar commit
log "🚀 Realizando commit..."
if git commit -m "$commit_message"; then
    log "✅ Commit realizado exitosamente!"
    
    # Mostrar información del commit
    commit_hash=$(git rev-parse --short HEAD)
    info "🔗 Hash del commit: $commit_hash"
    info "🌿 Branch actual: $(git branch --show-current)"
    
    # Opcional: Push automático si la variable está configurada
    if [ "$AUTO_PUSH" = "true" ] && [ "$(git branch --show-current)" != "main" ] && [ "$(git branch --show-current)" != "master" ]; then
        log "📤 Realizando push automático..."
        if git push origin "$(git branch --show-current)" 2>/dev/null; then
            log "✅ Push realizado exitosamente!"
        else
            warning "⚠️  No se pudo realizar push automático (normal si es la primera vez)"
        fi
    fi
    
else
    error "❌ Error al realizar el commit"
    exit 1
fi

log "🎉 Auto-commit completado exitosamente!"