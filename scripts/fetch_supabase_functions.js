#!/usr/bin/env node

const https = require('https');
const fs = require('fs');
const path = require('path');

// Load environment variables
require('dotenv').config({ path: path.join(__dirname, '../supabase/.env') });

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

// List of known RPC functions from the codebase analysis
const knownFunctions = [
  'function_get_contacts_search',
  'function_get_contacts_related',
  'function_validate_delete_contact',
  'function_get_products',
  'function_get_products_paginated',
  'function_get_products_from_views',
  'function_search_products',
  'function_get_product_rates',
  'function_add_edit_product_rates',
  'function_create_itinerary',
  'function_duplicate_itinerary',
  'function_get_itineraries_with_contact_names',
  'function_get_itinerary_details',
  'function_all_items_itinerary',
  'function_get_passengers_itinerary',
  'function_cuentas_por_cobrar',
  'function_cuentas_por_pagar',
  'function_reporte_ventas',
  'function_get_provider_payments',
  'function_get_agenda',
  'function_get_locations_products',
  'function_get_user_roles_for_authenticated_user',
  'request_openai_extraction_edge'
];

async function testFunction(functionName) {
  return new Promise((resolve) => {
    const url = `${SUPABASE_URL}/rest/v1/rpc/${functionName}`;
    
    const req = https.request(url, {
      method: 'POST',
      headers: {
        'apikey': SUPABASE_SERVICE_KEY,
        'Authorization': `Bearer ${SUPABASE_SERVICE_KEY}`,
        'Content-Type': 'application/json',
        'Prefer': 'return=representation'
      }
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        resolve({
          name: functionName,
          status: res.statusCode,
          exists: res.statusCode !== 404,
          error: res.statusCode >= 400 ? data : null
        });
      });
    });

    req.on('error', err => {
      resolve({
        name: functionName,
        status: 0,
        exists: false,
        error: err.message
      });
    });

    // Send empty params to test
    req.write(JSON.stringify({}));
    req.end();
  });
}

async function fetchTables() {
  return new Promise((resolve, reject) => {
    https.get(`${SUPABASE_URL}/rest/v1/`, {
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
          const tables = Object.keys(spec.paths || {})
            .map(path => path.replace('/', '').split('?')[0])
            .filter(name => name && !name.includes('{'));
          resolve([...new Set(tables)]);
        } catch (err) {
          reject(err);
        }
      });
    }).on('error', reject);
  });
}

async function main() {
  console.log('Fetching Supabase schema information...\n');
  
  const outputDir = path.join(__dirname, '../supabase/schema');
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  // Fetch tables
  console.log('📊 Fetching tables...');
  try {
    const tables = await fetchTables();
    console.log(`Found ${tables.length} tables`);
    
    const tablesPath = path.join(outputDir, 'tables_list.json');
    fs.writeFileSync(tablesPath, JSON.stringify(tables, null, 2));
    
    // Create a markdown report
    let report = '# Supabase Schema Report\n\n';
    report += `Generated: ${new Date().toISOString()}\n\n`;
    
    report += '## Tables\n\n';
    tables.forEach(table => {
      report += `- ${table}\n`;
    });
    
    // Test RPC functions
    console.log('\n🔌 Testing RPC functions...');
    report += '\n## RPC Functions\n\n';
    
    const functionResults = [];
    for (const func of knownFunctions) {
      const result = await testFunction(func);
      functionResults.push(result);
      console.log(`${result.exists ? '✅' : '❌'} ${func}`);
    }
    
    report += '### Available Functions\n\n';
    functionResults
      .filter(f => f.exists)
      .forEach(f => report += `- ${f.name}\n`);
    
    report += '\n### Missing Functions\n\n';
    functionResults
      .filter(f => !f.exists)
      .forEach(f => report += `- ${f.name}\n`);
    
    // Save report
    const reportPath = path.join(outputDir, 'schema_report.md');
    fs.writeFileSync(reportPath, report);
    console.log(`\n📄 Report saved to: ${reportPath}`);
    
    // Save function details
    const functionsPath = path.join(outputDir, 'functions_status.json');
    fs.writeFileSync(functionsPath, JSON.stringify(functionResults, null, 2));
    
  } catch (err) {
    console.error('Error:', err);
  }
}

main().catch(console.error);