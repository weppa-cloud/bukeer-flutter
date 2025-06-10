#!/usr/bin/env node

const https = require('https');
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Edge Functions conocidas
const edgeFunctions = [
  'process-flight-extraction',
  'create-hotel-pdf',
  'generate-itinerary-pdf',
  'create-hotel-social-image',
  'create-activity-social-image',
  'hotel-description-generator',
  'activity-description-generator',
  'generate-activity-social-image-gotenberg',
  'generate-hotel-social-image-gotenberg',
  'create-hotel-pdf-image',
  'generate_activity_embeddings'
];

// Configuración
const PROJECT_ID = 'wzlxbpicdcdvxvdcvgas';
const SUPABASE_URL = `https://${PROJECT_ID}.supabase.co`;
const ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0NjQyODAsImV4cCI6MjA0MTA0MDI4MH0.dSh-yGzemDC7DL_rf7fwgWlMoEKv1SlBCxd8ElFs_d8';
const SERVICE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyNTQ2NDI4MCwiZXhwIjoyMDQxMDQwMjgwfQ.J2MyuGuGDpLb3gPkXmJ9obh1wCu3ETOec9lvlT3rO8I';

async function checkSupabaseCLI() {
  try {
    execSync('supabase --version', { stdio: 'ignore' });
    return true;
  } catch (error) {
    console.log('❌ Supabase CLI no está instalado.');
    console.log('\nPara instalar Supabase CLI:');
    console.log('  brew install supabase/tap/supabase');
    console.log('  o');
    console.log('  npm install -g supabase');
    return false;
  }
}

async function downloadWithCLI() {
  console.log('\n📥 Intentando descargar con Supabase CLI...\n');
  
  const outputDir = path.join(__dirname, '../supabase/functions');
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  try {
    // Primero intentamos hacer login si es necesario
    console.log('🔐 Configurando acceso...');
    
    // Crear un archivo .env temporal para el CLI
    const envPath = path.join(__dirname, '../supabase/.env.cli');
    const envContent = `SUPABASE_ACCESS_TOKEN=${SERVICE_KEY}
SUPABASE_PROJECT_ID=${PROJECT_ID}
SUPABASE_DB_PASSWORD=your_db_password`;
    
    fs.writeFileSync(envPath, envContent);
    
    // Intentar descargar cada función
    for (const funcName of edgeFunctions) {
      console.log(`\n📦 Descargando ${funcName}...`);
      
      try {
        const funcDir = path.join(outputDir, funcName);
        if (!fs.existsSync(funcDir)) {
          fs.mkdirSync(funcDir, { recursive: true });
        }
        
        // Comando para descargar la función
        const cmd = `cd ${outputDir} && supabase functions download ${funcName} --project-ref ${PROJECT_ID}`;
        execSync(cmd, { stdio: 'inherit' });
        
        console.log(`✅ ${funcName} descargada exitosamente`);
      } catch (error) {
        console.log(`❌ Error descargando ${funcName}: ${error.message}`);
      }
    }
    
    // Limpiar archivo temporal
    fs.unlinkSync(envPath);
    
  } catch (error) {
    console.error('Error general:', error);
  }
}

async function downloadViaAPI() {
  console.log('\n📥 Intentando obtener información via API...\n');
  
  const outputDir = path.join(__dirname, '../supabase/functions');
  
  // Crear estructura de ejemplo para cada función
  for (const funcName of edgeFunctions) {
    const funcDir = path.join(outputDir, funcName);
    if (!fs.existsSync(funcDir)) {
      fs.mkdirSync(funcDir, { recursive: true });
    }
    
    // Crear un archivo de documentación basado en lo que sabemos
    const docContent = `# Edge Function: ${funcName}

## Información
- **URL**: ${SUPABASE_URL}/functions/v1/${funcName}
- **Método**: POST
- **Autenticación**: Bearer token requerido

## Uso en el código

\`\`\`dart
// Headers requeridos
headers: {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer \${authToken}',
  'apikey': '${ANON_KEY}',
}
\`\`\`

## Notas
Para obtener el código fuente de esta función, necesitas:
1. Acceso al dashboard de Supabase
2. O usar Supabase CLI con las credenciales correctas

## Ejemplo de request
\`\`\`json
{
  // Agregar estructura del body según la función
}
\`\`\`
`;
    
    fs.writeFileSync(path.join(funcDir, 'README.md'), docContent);
  }
  
  // Crear un resumen general
  const summaryPath = path.join(outputDir, 'EDGE_FUNCTIONS_SUMMARY.md');
  const summaryContent = `# Resumen de Edge Functions

## Funciones disponibles

${edgeFunctions.map(func => `- ${func}`).join('\n')}

## Cómo descargar el código fuente

### Opción 1: Desde el Dashboard
1. Ve a https://supabase.com/dashboard/project/${PROJECT_ID}/functions
2. Click en cada función
3. Descarga el código fuente

### Opción 2: Con Supabase CLI
\`\`\`bash
# Login
supabase login

# Link al proyecto
supabase link --project-ref ${PROJECT_ID}

# Descargar función
supabase functions download <function-name>
\`\`\`

### Opción 3: Acceso directo (requiere autenticación)
Las Edge Functions no son accesibles directamente via API para descarga del código fuente.
Necesitas usar el dashboard o CLI.
`;
  
  fs.writeFileSync(summaryPath, summaryContent);
  console.log(`\n📄 Documentación creada en: ${outputDir}`);
}

async function main() {
  console.log('🚀 Descarga de Edge Functions de Supabase\n');
  
  // Verificar si tenemos Supabase CLI
  const hasCLI = await checkSupabaseCLI();
  
  if (hasCLI) {
    // Intentar con CLI
    await downloadWithCLI();
  } else {
    // Crear documentación via API
    await downloadViaAPI();
  }
  
  console.log('\n✨ Proceso completado');
  console.log('\nNOTA: Para descargar el código fuente real de las Edge Functions necesitas:');
  console.log('1. Instalar Supabase CLI: brew install supabase/tap/supabase');
  console.log('2. Autenticarte: supabase login');
  console.log('3. Conectar al proyecto: supabase link --project-ref ' + PROJECT_ID);
  console.log('4. Descargar funciones: supabase functions download <nombre>');
}

main().catch(console.error);