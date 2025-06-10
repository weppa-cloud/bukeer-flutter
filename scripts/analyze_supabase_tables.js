#!/usr/bin/env node

const https = require('https');
const fs = require('fs');
const path = require('path');

// Load environment variables
require('dotenv').config({ path: path.join(__dirname, '../supabase/.env') });

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

// Core tables to analyze (excluding views and RPC functions)
const coreTables = [
  'accounts', 'contacts', 'itineraries', 'itinerary_items',
  'hotels', 'hotel_rates', 'activities', 'activities_rates',
  'transfers', 'transfer_rates', 'flights', 'airlines', 'airports',
  'passenger', 'transactions', 'notes', 'images',
  'user_contact_info', 'user_roles', 'roles',
  'locations', 'regions', 'nationalities', 'points_of_interest'
];

async function fetchTableSample(tableName) {
  return new Promise((resolve) => {
    // Fetch just 1 row to understand structure
    const url = `${SUPABASE_URL}/rest/v1/${tableName}?limit=1`;
    
    https.get(url, {
      headers: {
        'apikey': SUPABASE_SERVICE_KEY,
        'Authorization': `Bearer ${SUPABASE_SERVICE_KEY}`,
        'Prefer': 'count=exact'
      }
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const result = JSON.parse(data);
          const sample = Array.isArray(result) && result.length > 0 ? result[0] : {};
          
          // Extract column info from sample
          const columns = {};
          Object.keys(sample).forEach(key => {
            const value = sample[key];
            let type = 'unknown';
            
            if (value === null) {
              type = 'nullable';
            } else if (typeof value === 'string') {
              if (value.match(/^\d{4}-\d{2}-\d{2}T/)) {
                type = 'timestamp';
              } else if (value.match(/^\d{4}-\d{2}-\d{2}$/)) {
                type = 'date';
              } else if (value.match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i)) {
                type = 'uuid';
              } else {
                type = 'text';
              }
            } else if (typeof value === 'number') {
              type = Number.isInteger(value) ? 'integer' : 'numeric';
            } else if (typeof value === 'boolean') {
              type = 'boolean';
            } else if (typeof value === 'object') {
              type = Array.isArray(value) ? 'array' : 'jsonb';
            }
            
            columns[key] = { type, sample: value };
          });
          
          resolve({
            table: tableName,
            columns: columns,
            rowCount: res.headers['content-range'] ? 
              parseInt(res.headers['content-range'].split('/')[1]) : 0
          });
        } catch (err) {
          resolve({
            table: tableName,
            error: err.message,
            columns: {}
          });
        }
      });
    }).on('error', err => {
      resolve({
        table: tableName,
        error: err.message,
        columns: {}
      });
    });
  });
}

async function analyzeRPCFunction(funcName) {
  // Extract actual function name (remove 'rpc/' prefix if present)
  const cleanName = funcName.replace('rpc/', '');
  
  return new Promise((resolve) => {
    const url = `${SUPABASE_URL}/rest/v1/rpc/${cleanName}`;
    
    const req = https.request(url, {
      method: 'OPTIONS',
      headers: {
        'apikey': SUPABASE_SERVICE_KEY,
        'Authorization': `Bearer ${SUPABASE_SERVICE_KEY}`
      }
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        resolve({
          name: cleanName,
          exists: res.statusCode < 400,
          status: res.statusCode
        });
      });
    });
    
    req.on('error', err => {
      resolve({
        name: cleanName,
        exists: false,
        error: err.message
      });
    });
    
    req.end();
  });
}

async function main() {
  console.log('🔍 Analyzing Supabase tables (READ ONLY - No modifications)...\n');
  
  const outputDir = path.join(__dirname, '../supabase/schema');
  
  // Analyze core tables
  console.log('📊 Analyzing table structures...');
  const tableAnalysis = [];
  
  for (const table of coreTables) {
    process.stdout.write(`Analyzing ${table}...`);
    const analysis = await fetchTableSample(table);
    tableAnalysis.push(analysis);
    console.log(` ✓ (${Object.keys(analysis.columns).length} columns)`);
  }
  
  // Generate comprehensive schema
  let schemaSQL = `-- Bukeer Database Schema
-- Generated from Supabase API Analysis
-- Date: ${new Date().toISOString()}
-- NOTE: This is inferred from data samples, actual types may vary

`;

  tableAnalysis.forEach(({ table, columns, rowCount, error }) => {
    if (error) {
      schemaSQL += `-- Error analyzing ${table}: ${error}\n\n`;
      return;
    }
    
    schemaSQL += `-- Table: ${table} (${rowCount} rows)\n`;
    schemaSQL += `CREATE TABLE IF NOT EXISTS ${table} (\n`;
    
    const columnDefs = [];
    Object.entries(columns).forEach(([colName, colInfo]) => {
      let sqlType = 'TEXT'; // default
      
      switch (colInfo.type) {
        case 'uuid':
          sqlType = 'UUID';
          if (colName === 'id') sqlType += ' PRIMARY KEY DEFAULT gen_random_uuid()';
          break;
        case 'timestamp':
          sqlType = 'TIMESTAMP WITH TIME ZONE';
          if (colName === 'created_at') sqlType += ' DEFAULT NOW()';
          break;
        case 'date':
          sqlType = 'DATE';
          break;
        case 'integer':
          sqlType = 'INTEGER';
          break;
        case 'numeric':
          sqlType = 'NUMERIC(10,2)';
          break;
        case 'boolean':
          sqlType = 'BOOLEAN';
          if (colInfo.sample === false) sqlType += ' DEFAULT FALSE';
          break;
        case 'jsonb':
        case 'array':
          sqlType = 'JSONB';
          if (colInfo.sample && JSON.stringify(colInfo.sample) === '[]') {
            sqlType += " DEFAULT '[]'::jsonb";
          }
          break;
        case 'text':
        default:
          sqlType = 'TEXT';
          break;
      }
      
      columnDefs.push(`    ${colName} ${sqlType}`);
    });
    
    schemaSQL += columnDefs.join(',\n');
    schemaSQL += '\n);\n\n';
  });
  
  // Save schema
  const schemaPath = path.join(outputDir, 'analyzed_schema.sql');
  fs.writeFileSync(schemaPath, schemaSQL);
  console.log(`\n✅ Schema analysis saved to: ${schemaPath}`);
  
  // Save detailed analysis
  const analysisPath = path.join(outputDir, 'table_analysis.json');
  fs.writeFileSync(analysisPath, JSON.stringify(tableAnalysis, null, 2));
  
  // Analyze RPC functions
  const rpcFunctions = JSON.parse(
    fs.readFileSync(path.join(outputDir, 'tables_list.json'), 'utf8')
  ).filter(name => name.startsWith('rpc/'));
  
  console.log(`\n🔌 Found ${rpcFunctions.length} RPC functions`);
  
  const functionAnalysis = [];
  for (const func of rpcFunctions.slice(0, 10)) { // Test first 10
    const result = await analyzeRPCFunction(func);
    functionAnalysis.push(result);
  }
  
  // Save function analysis
  const functionsPath = path.join(outputDir, 'rpc_functions.json');
  fs.writeFileSync(functionsPath, JSON.stringify(functionAnalysis, null, 2));
  
  console.log('\n✅ Analysis complete! No data was modified.');
}

main().catch(console.error);