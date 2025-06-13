# =� Gu�a de Onboarding para Desarrollador Junior - Bukeer

## =� Flujo de Trabajo con flow.sh

### <� Script Automatizado flow.sh

El proyecto incluye un script que simplifica TODO el flujo de trabajo:

```bash
# Dar permisos de ejecuci�n (solo la primera vez)
chmod +x flow.sh

# Ver ayuda completa
./flow.sh help
```

### = Flujo de Desarrollo Simplificado

```mermaid
flowchart TD
    A[Tech Lead asigna tarea] --> B[Junior: ./flow.sh dev nombre-feature]
    B --> C[Junior: ./flow.sh run]
    C --> D[Junior desarrolla]
    D --> E[Junior: ./flow.sh save]
    E --> F[Junior: ./flow.sh test]
    F --> G{�Tests pasan?}
    G -->|No| D
    G -->|S�| H[Junior: ./flow.sh pr]
    H --> I[Tech Lead revisa PR]
    I --> J{�Aprobado?}
    J -->|No| K[Junior aplica cambios]
    K --> E
    J -->|S�| L[Tech Lead: ./flow.sh deploy]
```

## =� Proceso Paso a Paso (Junior)

### 1. **Configuraci�n Inicial (Solo Primera Vez)**
```bash
# Clonar repositorio
git clone https://github.com/weppa-cloud/bukeer-flutter.git
cd bukeer-flutter

# Dar permisos al script
chmod +x flow.sh

# Instalar dependencias
flutter pub get
```

### 2. **Flujo Diario de Desarrollo**

#### < Inicio del D�a
```bash
# Sincronizar con los �ltimos cambios
./flow.sh sync

# Ver estado del proyecto
./flow.sh status
```

#### =� Nueva Tarea
```bash
# 1. Crear rama para tu feature
./flow.sh dev agregar-filtro-productos

# 2. Ejecutar la aplicaci�n
./flow.sh run              # Por defecto en Chrome
./flow.sh run ios          # En iOS
./flow.sh run android      # En Android
```

#### =� Durante el Desarrollo
```bash
# Guardar cambios frecuentemente (auto-commit)
./flow.sh save

# O con mensaje espec�fico
./flow.sh save "feat: agregar filtro por categor�a en productos"

# Verificar que todo est� bien
./flow.sh test
```

#### =� Finalizar Tarea
```bash
# 1. Asegurarte que todo funciona
./flow.sh test

# 2. Crear Pull Request
./flow.sh pr

# 3. Notificar al Tech Lead para revisi�n
```

## =� Reglas Cr�ticas de Seguridad

### NUNCA hacer esto:
```dart
// L PROHIBIDO - API Keys
const apiKey = "sk-1234567890abcdef";

// L PROHIBIDO - URLs hardcodeadas
const prodUrl = "https://api.produccion.com";

// L PROHIBIDO - Sistema obsoleto
import 'package:bukeer/legacy/flutter_flow/flutter_flow_theme.dart';
FlutterFlowTheme.of(context).primaryText
```

### SIEMPRE hacer esto:
```dart
//  CORRECTO - Configuraci�n externa
final apiKey = window.BukeerConfig.apiKey;

//  CORRECTO - Sistema de dise�o nuevo
import 'package:bukeer/design_system/index.dart';
BukeerColors.textPrimary
```

## =� Checklist Diario del Junior

### Antes de Empezar:
- [ ] `./flow.sh sync` - Sincronizar con main
- [ ] `./flow.sh status` - Verificar estado limpio
- [ ] Leer la tarea asignada completamente
- [ ] Preguntar si hay dudas ANTES de empezar

### Durante el Desarrollo:
- [ ] `./flow.sh save` - Guardar cambios cada hora
- [ ] Usar SOLO el sistema de dise�o Bukeer
- [ ] NO modificar archivos en `/backend/` sin permiso
- [ ] `./flow.sh test` - Verificar antes de cada save importante

### Antes del Pull Request:
- [ ] `./flow.sh test` - Todos los tests pasan
- [ ] Revisar que NO hay informaci�n sensible
- [ ] Screenshots si hay cambios visuales
- [ ] `./flow.sh pr` - Crear PR con descripci�n clara

## =h=� Proceso de Revisi�n (Tech Lead)

### Comandos para Revisi�n:
```bash
# Ver PRs pendientes
gh pr list

# Revisar un PR espec�fico
gh pr checkout [numero-pr]

# Ejecutar y probar localmente
./flow.sh run

# Aprobar y hacer deploy
gh pr merge [numero-pr]
./flow.sh deploy
```

### Checklist de Revisi�n:
1. **Seguridad**: No hay API keys, tokens o secretos
2. **Dise�o**: Usa sistema Bukeer, no FlutterFlow
3. **Calidad**: Tests pasan, c�digo limpio
4. **Funcionalidad**: Feature funciona como se espera

## <� Tareas de Pr�ctica (Primeras Semanas)

### Semana 1: Familiarizaci�n
```bash
# D�a 1-2: Setup y exploraci�n
./flow.sh run
# Explorar la aplicaci�n, entender navegaci�n

# D�a 3-4: Primer fix simple
./flow.sh dev mi-primer-fix
# Arreglar un typo o ajustar espaciado
./flow.sh save "fix: corregir typo en p�gina de contactos"
./flow.sh pr

# D�a 5: Pr�ctica completa del flujo
./flow.sh dev practica-componente
# Crear un componente simple en /core/widgets/
```

### Semana 2: Componentes y Migraci�n
```bash
# Migrar un componente de FlutterFlow a Bukeer
./flow.sh dev migrar-componente-x
# Buscar componentes que usen FlutterFlowTheme
# Migrarlos al sistema de dise�o Bukeer
```

### Semana 3: Features Completas
```bash
# Implementar una feature peque�a completa
./flow.sh dev feature-filtros-avanzados
# Integrar con AppServices
# Agregar tests
```

## <� Cuando Pedir Ayuda

### Usa este formato para preguntas:
```
=4 BLOQUEO: [Descripci�n]
=� Archivo: [path/al/archivo.dart]
<� Intent�: [qu� intentaste]
S Error: [mensaje de error si hay]
```

### Canales de Comunicaci�n:
- **Dudas r�pidas**: Slack/Discord del equipo
- **Bloqueos**: Mensaje directo al Tech Lead
- **Code review**: Comentarios en el PR

## =� M�tricas de �xito (30 d�as)

### Para el Junior:
- [ ] 100% de desarrollo usando `flow.sh`
- [ ] 0 commits con informaci�n sensible
- [ ] 90%+ de PRs sin FlutterFlowTheme
- [ ] M�nimo 1 PR aprobado por semana
- [ ] Tests ejecutados antes de cada PR

### Para el Tech Lead:
- [ ] Revisi�n de PR en < 24 horas
- [ ] Feedback constructivo y educativo
- [ ] Deploy seguro sin vulnerabilidades

## =' Troubleshooting Com�n

### Error: "Permission denied"
```bash
chmod +x flow.sh
```

### Error: "flutter: command not found"
```bash
# Verificar instalaci�n de Flutter
flutter --version
```

### Error al crear PR
```bash
# Instalar GitHub CLI
brew install gh  # En macOS
gh auth login    # Autenticarse
```

### Conflictos al sincronizar
```bash
# El script te guiar�, pero b�sicamente:
# 1. Resolver conflictos en VS Code
# 2. git add .
# 3. git commit
# 4. ./flow.sh save
```

---

**Recuerda**: 
- =� La seguridad es PRIORIDAD #1
- <� SIEMPRE usar el sistema de dise�o Bukeer
- =� Es mejor preguntar que romper algo
- =� `flow.sh` es tu mejor amigo

�Bienvenido al equipo! <�