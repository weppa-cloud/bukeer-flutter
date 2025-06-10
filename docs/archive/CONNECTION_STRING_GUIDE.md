# 🔗 Guía para Connection String de Supabase

## Formatos de Connection String

Supabase tiene diferentes formatos según el modo:

### 1. Transaction Mode (Recomendado para apps)
```
postgresql://postgres.[PROJECT-REF]:[YOUR-PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres?pgbouncer=true
```
Puerto: **6543**

### 2. Session Mode (Para migraciones)
```
postgresql://postgres.[PROJECT-REF]:[YOUR-PASSWORD]@aws-0-[REGION].pooler.supabase.com:5432/postgres
```
Puerto: **5432**

### 3. Direct Connection (No pooled)
```
postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
```

## Para tu proyecto Staging:

- **Project Ref**: wrgkiastpqituocblopg
- **Password**: fZGE3YShagCIeTON
- **Region**: us-west-1

### Intenta estos formatos:

**Opción 1 - Direct Connection**:
```
postgresql://postgres:fZGE3YShagCIeTON@db.wrgkiastpqituocblopg.supabase.co:5432/postgres
```

**Opción 2 - Session Pooled**:
```
postgresql://postgres.wrgkiastpqituocblopg:fZGE3YShagCIeTON@aws-0-us-west-1.pooler.supabase.com:5432/postgres
```

## Cómo obtener la correcta:

1. Ve a: https://supabase.com/dashboard/project/wrgkiastpqituocblopg/settings/database
2. Click en "Connect"
3. Copia la string EXACTA que te muestra
4. Solo reemplaza [YOUR-PASSWORD] con tu password