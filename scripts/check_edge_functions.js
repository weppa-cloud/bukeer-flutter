#!/usr/bin/env node

const https = require('https');
const fs = require('fs');
const path = require('path');

// Load environment variables
require('dotenv').config({ path: path.join(__dirname, '../supabase/.env') });

const SUPABASE_URL = process.env.SUPABASE_URL || 'https://wzlxbpicdcdvxvdcvgas.supabase.co';
const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0NjQyODAsImV4cCI6MjA0MTA0MDI4MH0.dSh-yGzemDC7DL_rf7fwgWlMoEKv1SlBCxd8ElFs_d8';

// Edge functions mentioned in the code
const knownEdgeFunctions = [
  'request_openai_extraction_edge',
  'hotel_pdf_generation',
  'sync_duffel_airlines', 
  'sync_duffel_airports',
  'get_bukeer_data_for_wp_sync',
  'normalize_phone_colombia_only'
];

// Common edge function endpoints
const commonEndpoints = [
  'hello-world',
  'openai',
  'pdf-generator',
  'email',
  'webhook'
];

async function checkEdgeFunction(functionName) {
  return new Promise((resolve) => {
    const url = `${SUPABASE_URL}/functions/v1/${functionName}`;
    
    const req = https.request(url, {
      method: 'OPTIONS', // Use OPTIONS to check if endpoint exists
      headers: {
        'apikey': SUPABASE_ANON_KEY,
        'Authorization': `Bearer ${SUPABASE_ANON_KEY}`
      }
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        resolve({
          name: functionName,
          url: url,
          exists: res.statusCode < 400,
          status: res.statusCode,
          headers: res.headers
        });
      });
    });

    req.on('error', err => {
      resolve({
        name: functionName,
        url: url,
        exists: false,
        error: err.message
      });
    });

    req.end();
  });
}

async function testOpenAIFunction() {
  // Special test for the OpenAI extraction function
  return new Promise((resolve) => {
    const url = `${SUPABASE_URL}/functions/v1/request_openai_extraction_edge`;
    
    const testPayload = {
      query: "test",
      type: "test"
    };

    const req = https.request(url, {
      method: 'POST',
      headers: {
        'apikey': SUPABASE_ANON_KEY,
        'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
        'Content-Type': 'application/json'
      }
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        resolve({
          name: 'request_openai_extraction_edge',
          method: 'POST',
          status: res.statusCode,
          response: data,
          headers: res.headers
        });
      });
    });

    req.on('error', err => {
      resolve({
        name: 'request_openai_extraction_edge',
        method: 'POST',
        error: err.message
      });
    });

    req.write(JSON.stringify(testPayload));
    req.end();
  });
}

async function main() {
  console.log('🔍 Checking Supabase Edge Functions...\n');
  
  const outputDir = path.join(__dirname, '../supabase/functions');
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  console.log('📡 Testing known edge functions from codebase...');
  const results = [];
  
  for (const func of knownEdgeFunctions) {
    const result = await checkEdgeFunction(func);
    console.log(`${result.exists ? '✅' : '❌'} ${func} - Status: ${result.status}`);
    results.push(result);
  }

  console.log('\n📡 Testing common edge function names...');
  for (const func of commonEndpoints) {
    const result = await checkEdgeFunction(func);
    if (result.exists) {
      console.log(`✅ Found: ${func} - Status: ${result.status}`);
      results.push(result);
    }
  }

  // Test OpenAI function specifically
  console.log('\n🤖 Testing OpenAI extraction function...');
  const openAITest = await testOpenAIFunction();
  console.log(`OpenAI function test - Status: ${openAITest.status}`);
  
  // Generate report
  let report = '# Supabase Edge Functions Report\n\n';
  report += `Generated: ${new Date().toISOString()}\n\n`;
  
  report += '## Edge Functions Status\n\n';
  
  const existingFunctions = results.filter(r => r.exists);
  const missingFunctions = results.filter(r => !r.exists);
  
  if (existingFunctions.length > 0) {
    report += '### ✅ Available Functions\n\n';
    existingFunctions.forEach(f => {
      report += `- **${f.name}**\n`;
      report += `  - URL: ${f.url}\n`;
      report += `  - Status: ${f.status}\n\n`;
    });
  }
  
  if (missingFunctions.length > 0) {
    report += '### ❌ Missing/Inaccessible Functions\n\n';
    missingFunctions.forEach(f => {
      report += `- ${f.name}\n`;
    });
  }

  report += '\n## OpenAI Function Test\n\n';
  report += `- Status: ${openAITest.status}\n`;
  if (openAITest.response) {
    report += `- Response: ${openAITest.response.substring(0, 200)}...\n`;
  }

  // Check if we're looking at RPC functions vs Edge Functions
  report += '\n## Important Note\n\n';
  report += 'Many functions found in the codebase (like `request_openai_extraction_edge`) ';
  report += 'appear to be RPC functions in the database, not Edge Functions. ';
  report += 'Edge Functions would be accessible at `/functions/v1/`, while RPC functions ';
  report += 'are accessed through `/rest/v1/rpc/`.\n';

  // Save report
  const reportPath = path.join(outputDir, 'edge_functions_report.md');
  fs.writeFileSync(reportPath, report);
  console.log(`\n📄 Report saved to: ${reportPath}`);

  // Save detailed results
  const resultsPath = path.join(outputDir, 'edge_functions_check.json');
  fs.writeFileSync(resultsPath, JSON.stringify({
    results,
    openAITest,
    timestamp: new Date().toISOString()
  }, null, 2));
}

main().catch(console.error);