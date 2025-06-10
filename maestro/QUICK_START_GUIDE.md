# 🚀 Maestro Quick Start Guide

Esta guía te ayudará a ejecutar tests E2E rápidamente usando los scripts npm configurados.

## 📋 Prerequisitos

1. **Flutter** instalado y configurado
2. **Node.js** y npm instalados
3. **Xcode** (para iOS) o **Android Studio** (para Android)

## 🛠️ Instalación Rápida

```bash
# 1. Instalar Maestro CLI
npm run maestro:install

# 2. Configurar variables de entorno
npm run maestro:setup

# 3. Editar el archivo .env.maestro con tus credenciales
nano maestro/.env.maestro
```

## 🎯 Comandos Disponibles

### Tests por Categoría

```bash
# Ejecutar todos los tests
npm run maestro:test

# Tests de smoke (críticos)
npm run maestro:test:smoke

# Tests de regresión completos
npm run maestro:test:regression

# Solo tests críticos
npm run maestro:test:critical
```

### Tests por Módulo

```bash
# Tests de autenticación
npm run maestro:test:auth

# Tests de productos
npm run maestro:test:products

# Tests de contactos
npm run maestro:test:contacts

# Tests de itinerarios
npm run maestro:test:itineraries
```

### Herramientas de Desarrollo

```bash
# Abrir Maestro Studio (interfaz visual)
npm run maestro:studio

# Grabar nuevos tests
npm run maestro:record

# Ver jerarquía de elementos
npm run maestro:hierarchy

# Limpiar resultados anteriores
npm run maestro:clean
```

### Tests con Video

```bash
# Ejecutar tests con grabación de video
npm run maestro:test:video

# Grabar videos en alta calidad para todos los tests
npm run maestro:test:video:all

# Grabar video de un test específico
cd maestro && maestro test --video flows/auth/01_login_success.yaml
```

### Comandos E2E Simplificados

```bash
# Tests E2E básicos (smoke)
npm run test:e2e

# Todos los tests E2E
npm run test:e2e:all
```

## 🏃‍♂️ Flujo de Trabajo Típico

### 1. Primera vez

```bash
# Instalar y configurar
npm run maestro:install
npm run maestro:setup

# Editar credenciales
# TEST_EMAIL=tu_email@test.com
# TEST_PASSWORD=tu_password
```

### 2. Desarrollo diario

```bash
# Ejecutar tests smoke antes de commit
npm run test:e2e

# Ejecutar módulo específico después de cambios
npm run maestro:test:products
```

### 3. Antes de PR

```bash
# Ejecutar suite completa
npm run test:e2e:all

# Limpiar y ejecutar de nuevo si hay problemas
npm run maestro:clean
npm run test:e2e:all
```

## 🔍 Ejecutar Test Individual

```bash
# Navegar a la carpeta maestro
cd maestro

# Ejecutar test específico
maestro test flows/auth/01_login_success.yaml

# O usar el comando npm
npm run maestro:test:single flows/auth/01_login_success.yaml
```

## 📱 Plataformas

### iOS (por defecto)
```bash
npm run maestro:test
```

### Android
```bash
cd maestro && maestro test --platform=android flows/
```

### Web
```bash
cd maestro && maestro test --platform=web --browser=chrome flows/
```

## 🐛 Debugging

### Ver logs detallados
```bash
cd maestro && maestro test --debug flows/auth/01_login_success.yaml
```

### Usar Maestro Studio
```bash
npm run maestro:studio
# Luego seleccionar el test a debuggear visualmente
```

## 📊 Resultados

Los resultados se guardan en:
- **Screenshots**: `maestro/screenshots/`
- **Reportes**: `maestro/test-results/`
- **Videos** (si habilitado): `maestro/recordings/`

## 🔧 Troubleshooting Común

### Error: "Maestro command not found"
```bash
npm run maestro:install
# Reiniciar terminal
```

### Error: "No .env.maestro file"
```bash
npm run maestro:setup
```

### Tests fallan por timeouts
Aumentar timeout en `maestro/.env.maestro`:
```
TEST_TIMEOUT=60000
```

## 📚 Más Información

- [README completo](./README.md)
- [Guía de inicio detallada](./GETTING_STARTED.md)
- [Documentación oficial de Maestro](https://maestro.mobile.dev)