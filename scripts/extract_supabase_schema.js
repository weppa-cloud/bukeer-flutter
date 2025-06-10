#!/usr/bin/env node

const https = require('https');
const fs = require('fs');
const path = require('path');

// Load environment variables
require('dotenv').config({ path: path.join(__dirname, '../supabase/.env') });

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_KEY) {
  console.error('Missing Supabase credentials in .env file');
  process.exit(1);
}

// Helper function to make API requests
function makeRequest(endpoint, query) {
  return new Promise((resolve, reject) => {
    const url = new URL(`${SUPABASE_URL}/rest/v1/rpc/${endpoint}`);
    
    const options = {
      method: 'POST',
      headers: {
        'apikey': SUPABASE_SERVICE_KEY,
        'Authorization': `Bearer ${SUPABASE_SERVICE_KEY}`,
        'Content-Type': 'application/json',
        'Prefer': 'return=representation'
      }
    };

    const req = https.request(url, options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        if (res.statusCode === 200) {
          resolve(JSON.parse(data));
        } else {
          reject(new Error(`HTTP ${res.statusCode}: ${data}`));
        }
      });
    });

    req.on('error', reject);
    if (query) req.write(JSON.stringify(query));
    req.end();
  });
}

// SQL queries to extract schema information
const queries = {
  tables: `
    SELECT 
      t.table_name,
      obj_description(c.oid) as table_comment
    FROM information_schema.tables t
    JOIN pg_class c ON c.relname = t.table_name
    WHERE t.table_schema = 'public' 
      AND t.table_type = 'BASE TABLE'
    ORDER BY t.table_name;
  `,
  
  columns: `
    SELECT 
      c.table_name,
      c.column_name,
      c.data_type,
      c.is_nullable,
      c.column_default,
      c.character_maximum_length,
      c.numeric_precision,
      c.numeric_scale
    FROM information_schema.columns c
    WHERE c.table_schema = 'public'
    ORDER BY c.table_name, c.ordinal_position;
  `,
  
  constraints: `
    SELECT
      tc.table_name,
      tc.constraint_name,
      tc.constraint_type,
      kcu.column_name,
      ccu.table_name AS foreign_table_name,
      ccu.column_name AS foreign_column_name
    FROM information_schema.table_constraints tc
    LEFT JOIN information_schema.key_column_usage kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    LEFT JOIN information_schema.constraint_column_usage ccu
      ON ccu.constraint_name = tc.constraint_name
      AND ccu.table_schema = tc.table_schema
    WHERE tc.table_schema = 'public'
    ORDER BY tc.table_name, tc.constraint_type;
  `,
  
  functions: `
    SELECT 
      p.proname as function_name,
      pg_get_function_arguments(p.oid) as arguments,
      pg_get_function_result(p.oid) as return_type,
      pg_get_functiondef(p.oid) as definition
    FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'public'
      AND p.prokind = 'f'
    ORDER BY p.proname;
  `,
  
  views: `
    SELECT 
      table_name as view_name,
      view_definition
    FROM information_schema.views
    WHERE table_schema = 'public'
    ORDER BY table_name;
  `
};

async function extractSchema() {
  console.log('Extracting Supabase schema...\n');
  
  const outputDir = path.join(__dirname, '../supabase/schema');
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  // For each query, we'll need to use the SQL endpoint
  // Since we can't directly query the database, we'll use the API
  console.log('Note: Direct SQL queries require database connection.');
  console.log('Creating schema documentation from API analysis...\n');

  // Instead, let's fetch the OpenAPI spec which contains schema info
  const apiUrl = `${SUPABASE_URL}/rest/v1/`;
  
  https.get(apiUrl, {
    headers: {
      'apikey': SUPABASE_SERVICE_KEY,
      'Authorization': `Bearer ${SUPABASE_SERVICE_KEY}`
    }
  }, (res) => {
    let data = '';
    res.on('data', chunk => data += chunk);
    res.on('end', () => {
      try {
        const spec = JSON.parse(data);
        
        // Extract table information from OpenAPI spec
        const tables = {};
        const paths = spec.paths || {};
        
        Object.keys(paths).forEach(path => {
          const tableName = path.replace('/', '').split('?')[0];
          if (tableName && !tables[tableName]) {
            const tableInfo = paths[path];
            const schema = tableInfo.get?.responses?.['200']?.content?.['application/json']?.schema;
            
            if (schema && schema.items && schema.items.properties) {
              tables[tableName] = {
                name: tableName,
                columns: schema.items.properties
              };
            }
          }
        });
        
        // Write the extracted schema
        const schemaPath = path.join(outputDir, 'api_schema.json');
        fs.writeFileSync(schemaPath, JSON.stringify(tables, null, 2));
        console.log(`Schema extracted to: ${schemaPath}`);
        
        // Generate SQL from the schema
        generateSQL(tables, outputDir);
        
      } catch (err) {
        console.error('Error parsing API response:', err);
      }
    });
  }).on('error', err => {
    console.error('Error fetching API schema:', err);
  });
}

function generateSQL(tables, outputDir) {
  let sql = '-- Bukeer Database Schema\n';
  sql += '-- Generated from Supabase API\n\n';
  
  Object.keys(tables).sort().forEach(tableName => {
    const table = tables[tableName];
    sql += `-- Table: ${tableName}\n`;
    sql += `CREATE TABLE IF NOT EXISTS ${tableName} (\n`;
    
    const columns = [];
    Object.keys(table.columns).forEach(colName => {
      const col = table.columns[colName];
      let colDef = `    ${colName}`;
      
      // Infer SQL type from JSON schema
      if (col.type === 'string' && col.format === 'uuid') {
        colDef += ' UUID';
      } else if (col.type === 'string' && col.format === 'date-time') {
        colDef += ' TIMESTAMP WITH TIME ZONE';
      } else if (col.type === 'string' && col.format === 'date') {
        colDef += ' DATE';
      } else if (col.type === 'string') {
        colDef += ' TEXT';
      } else if (col.type === 'number') {
        colDef += ' NUMERIC';
      } else if (col.type === 'integer') {
        colDef += ' INTEGER';
      } else if (col.type === 'boolean') {
        colDef += ' BOOLEAN';
      } else if (col.type === 'object' || col.type === 'array') {
        colDef += ' JSONB';
      }
      
      columns.push(colDef);
    });
    
    sql += columns.join(',\n');
    sql += '\n);\n\n';
  });
  
  const sqlPath = path.join(outputDir, 'generated_schema.sql');
  fs.writeFileSync(sqlPath, sql);
  console.log(`SQL schema generated at: ${sqlPath}`);
}

// Run the extraction
extractSchema().catch(console.error);