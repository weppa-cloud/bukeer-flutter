# Comandos de Flujo de Desarrollo

## Mapeo de Comandos Cortos

Cuando recibas estos comandos cortos, ejecuta los scripts correspondientes:

### Comandos principales:
- `run` → `./flow.sh run`
- `staging` → `./flow.sh staging`
- `dev [nombre]` → `./flow.sh dev [nombre]`
- `save` → `./flow.sh save`
- `save [mensaje]` → `./flow.sh save "[mensaje]"`
- `test` → `./flow.sh test`
- `pr` → `./flow.sh pr`
- `deploy` → `./flow.sh deploy`
- `status` → `./flow.sh status`
- `sync` → `./flow.sh sync`
- `clean` → `./flow.sh clean`

### Flujo de trabajo para nueva característica:
1. `dev nombre-feature` - Crear rama feature/nombre-feature
2. `save` - Guardar cambios con auto-commit
3. `test` - Ejecutar pruebas
4. `pr` - Crear Pull Request
5. `deploy` - Deploy a producción (después de revisión)

### Comandos de commit:
- Para commit automático: `save`
- Para commit con mensaje personalizado: `save "feat: descripción"`

## Uso

Simplemente escribe el comando corto (ej: "dev mi-feature") y ejecutaré automáticamente el script de flujo correspondiente.