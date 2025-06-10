# Supabase Edge Functions Report

Generated: 2025-06-09T15:53:55.904Z

## Edge Functions Status

### ❌ Missing/Inaccessible Functions

- request_openai_extraction_edge
- hotel_pdf_generation
- sync_duffel_airlines
- sync_duffel_airports
- get_bukeer_data_for_wp_sync
- normalize_phone_colombia_only

## OpenAI Function Test

- Status: 404
- Response: {"code":"NOT_FOUND","message":"Requested function was not found"}...

## Important Note

Many functions found in the codebase (like `request_openai_extraction_edge`) appear to be RPC functions in the database, not Edge Functions. Edge Functions would be accessible at `/functions/v1/`, while RPC functions are accessed through `/rest/v1/rpc/`.
