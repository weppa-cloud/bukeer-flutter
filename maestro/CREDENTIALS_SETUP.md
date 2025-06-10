# 🔐 Configuración de Credenciales para Tests Maestro

## 📋 Credenciales Requeridas

Para ejecutar los tests de Maestro, necesitas configurar las siguientes credenciales:

### 1. Usuario de Prueba Principal
- **Email**: Usuario con acceso completo a la aplicación
- **Password**: Contraseña del usuario de prueba
- **Permisos**: Debe poder crear/editar/eliminar itinerarios, productos, contactos

### 2. Usuario Secundario (Opcional)
- Para tests multi-usuario
- Para validar permisos entre usuarios

### 3. Usuario Admin (Opcional)
- Para tests de funcionalidades administrativas
- Para validar restricciones de roles

## 🛠️ Configuración Local

### Paso 1: Copiar archivo de ejemplo
```bash
npm run maestro:setup
# o manualmente:
cp maestro/.env.maestro.example maestro/.env.maestro
```

### Paso 2: Editar credenciales
```bash
nano maestro/.env.maestro
```

### Paso 3: Configurar valores reales
```env
# IMPORTANTE: Usar credenciales de ambiente de STAGING/TEST
# NUNCA usar credenciales de producción

TEST_EMAIL=tu_usuario_test@ejemplo.com
TEST_PASSWORD=tu_password_seguro

# Opcional: Usuario secundario
TEST_EMAIL_2=segundo_usuario@ejemplo.com
TEST_PASSWORD_2=otro_password

# Opcional: Admin
ADMIN_EMAIL=admin_test@ejemplo.com
ADMIN_PASSWORD=admin_password

# URL del ambiente de pruebas
TEST_BASE_URL=http://localhost:3000  # o tu URL de staging
```

## 🚨 Seguridad

### NO hacer:
- ❌ Commitear el archivo `.env.maestro` (ya está en .gitignore)
- ❌ Usar credenciales de producción
- ❌ Compartir credenciales en canales públicos
- ❌ Hardcodear credenciales en los tests

### SÍ hacer:
- ✅ Usar usuarios específicos para tests
- ✅ Usar ambiente de staging/test
- ✅ Rotar credenciales periódicamente
- ✅ Mantener `.env.maestro` local

## 🏭 Configuración para CI/CD

Para GitHub Actions, configura los secrets en el repositorio:

### Paso 1: Ir a Settings → Secrets → Actions

### Paso 2: Agregar los siguientes secrets:
- `TEST_EMAIL`
- `TEST_PASSWORD`
- `TEST_EMAIL_2` (opcional)
- `TEST_PASSWORD_2` (opcional)
- `ADMIN_EMAIL` (opcional)
- `ADMIN_PASSWORD` (opcional)
- `TEST_BASE_URL`

### Paso 3: Los secrets se inyectan automáticamente
El workflow ya está configurado para usar estos secrets:

```yaml
- name: Create .env.maestro
  run: |
    cat > maestro/.env.maestro << EOF
    TEST_EMAIL=${{ secrets.TEST_EMAIL }}
    TEST_PASSWORD=${{ secrets.TEST_PASSWORD }}
    # ... más secrets
    EOF
```

## 🧪 Crear Usuarios de Test

### Opción 1: Usuario Manual
1. Crear usuario en tu ambiente de staging
2. Asignar permisos necesarios
3. Verificar que puede acceder a todas las funcionalidades

### Opción 2: Script de Setup (Recomendado)
```bash
# Crear usuario de test con datos predefinidos
curl -X POST https://tu-staging-api.com/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "maestro_test_user@ejemplo.com",
    "password": "Test123!@#",
    "name": "Maestro Test User"
  }'
```

### Opción 3: Datos de Seed
Si tu aplicación tiene seeders:
```bash
# En tu ambiente de staging
flutter run lib/seeds/test_users.dart
```

## 📊 Datos de Prueba Recomendados

El usuario de test debe tener:
- ✅ Al menos 2 itinerarios creados
- ✅ Al menos 3 productos diferentes
- ✅ Al menos 5 contactos
- ✅ Algunos pagos registrados
- ✅ Historial de transacciones

## 🔍 Verificar Configuración

### Test rápido de credenciales:
```bash
# Probar solo el login
cd maestro && maestro test flows/auth/01_login_success.yaml

# Si funciona, las credenciales están correctas
```

### Verificar ambiente:
```bash
# Asegurarse de que apunta al ambiente correcto
curl $TEST_BASE_URL/health
```

## 🆘 Troubleshooting

### Error: "Invalid login credentials"
- Verificar email y password
- Confirmar que el usuario existe en el ambiente
- Revisar que no hay espacios extra en `.env.maestro`

### Error: "Cannot connect to server"
- Verificar TEST_BASE_URL
- Confirmar que el servidor está corriendo
- Revisar configuración de red/firewall

### Error: "Permission denied"
- El usuario necesita más permisos
- Verificar rol del usuario en la base de datos
- Confirmar que puede acceder a todas las secciones

## 📝 Plantilla de Usuario de Test

Aquí hay una plantilla SQL para crear un usuario de test completo:

```sql
-- Crear usuario de test
INSERT INTO auth.users (email, encrypted_password, confirmed_at)
VALUES ('maestro_test@ejemplo.com', crypt('Test123!@#', gen_salt('bf')), NOW());

-- Asignar rol
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id 
FROM auth.users u, roles r 
WHERE u.email = 'maestro_test@ejemplo.com' 
AND r.name = 'admin';

-- Crear datos de test
-- ... más inserts para itinerarios, productos, etc.
```

## 🚀 Siguiente Paso

Una vez configuradas las credenciales:

```bash
# Ejecutar test de smoke para verificar
npm run test:e2e

# Si todo funciona, ejecutar suite completa
npm run test:e2e:all
```

---

**RECORDATORIO**: Las credenciales son el componente más crítico para los tests E2E. Sin ellas, ningún test funcionará correctamente.