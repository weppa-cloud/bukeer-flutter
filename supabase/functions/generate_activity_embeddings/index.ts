// supabase/functions/generate_activity_embeddings/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { OpenAI } from "https://deno.land/x/openai/mod.ts";
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { corsHeaders } from '../_shared/cors.ts'; // Import CORS headers
const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY");
const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
const SUPABASE_ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY");
const OPENAI_EMBEDDING_MODEL = Deno.env.get("OPENAI_EMBEDDING_MODEL") || "text-embedding-ada-002";
serve(async (req)=>{
  // Handle OPTIONS request for CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: corsHeaders
    });
  }
  if (!OPENAI_API_KEY) {
    console.error("OPENAI_API_KEY is not set.");
    return new Response(JSON.stringify({
      success: false,
      error: "OpenAI API key not configured."
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json"
      }
    });
  }
  if (!SUPABASE_URL) {
    return new Response(JSON.stringify({
      success: false,
      error: "Missing SUPABASE_URL"
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json"
      }
    });
  }
  if (!SUPABASE_ANON_KEY) {
    return new Response(JSON.stringify({
      success: false,
      error: "Missing SUPABASE_ANON_KEY"
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json"
      }
    });
  }
  const supabaseClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
  const openai = new OpenAI({
    apiKey: OPENAI_API_KEY
  }); // Correct initialization for v4+
  try {
    const { record: activityRequest } = await req.json();
    const activityId = activityRequest.id;
    if (!activityId) {
      return new Response(JSON.stringify({
        success: false,
        error: "Activity ID is required in the request record."
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json"
        }
      });
    }
    // Fetch activity details from Supabase
    const { data: activityDetails, error: fetchError } = await supabaseClient.from('activities').select('id, name, description, type, location, inclutions, exclutions, recomendations, instructions').eq('id', activityId).single();
    if (fetchError) {
      console.error("Error fetching activity details:", fetchError);
      return new Response(JSON.stringify({
        success: false,
        error: `Failed to fetch activity: ${fetchError.message}`
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json"
        }
      });
    }
    if (!activityDetails) {
      return new Response(JSON.stringify({
        success: false,
        error: `Activity with ID ${activityId} not found.`
      }), {
        status: 404,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json"
        }
      });
    }
    const activity = activityDetails;
    // Combine the relevant fields into a single string for embedding
    // Ensuring null or undefined fields are handled gracefully (e.g., replaced with empty strings)
    const inputText = [
      `ID: ${activity.id || ""}`,
      `Nombre: ${activity.name || ""}`,
      `Descripción: ${activity.description || ""}`,
      `Tipo: ${activity.type || ""}`,
      `Ubicación: ${activity.location || ""}`,
      `Inclusiones: ${activity.inclutions || ""}`,
      `Exclusiones: ${activity.exclutions || ""}`,
      `Recomendaciones: ${activity.recomendations || ""}`,
      `Instrucciones: ${activity.instructions || ""}`
    ].join(", ").trim();
    if (!inputText || inputText === "ID: , Nombre: , Descripción: , Tipo: , Ubicación: , Inclusiones: , Exclusiones: , Recomendaciones: , Instrucciones:") {
      console.warn(`No content available to generate embedding for activity ID: ${activityId}. All fields might be empty or null.`);
      return new Response(JSON.stringify({
        success: false,
        error: "No content available from the activity to generate embedding."
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json"
        }
      });
    }
    const embeddingResponse = await openai.embeddings.create({
      model: OPENAI_EMBEDDING_MODEL,
      input: inputText
    });
    const embedding = embeddingResponse.data[0].embedding;
    // Save the embedding to the 'activities' table
    const { data: updateData, error: updateError, count: updateCount, status: updateStatus } = await supabaseClient.from('activities').update({
      embedding: embedding
    }).eq('id', activity.id).select(); // Add .select() to get more details about the update operation
    if (updateError) {
      console.error("Error updating activity with embedding:", updateError);
      return new Response(JSON.stringify({
        success: false,
        error: `Failed to save embedding: ${updateError.message}`
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json"
        }
      });
    }
    // Log for debugging the update operation
    console.log(`Update operation details - Activity ID: ${activity.id}, Status: ${updateStatus}, Count: ${updateCount}, Updated Data: ${JSON.stringify(updateData)}`);
    if (updateCount === 0) {
      console.warn(`No rows were updated for activity ID: ${activity.id}. This might be due to RLS, the row not matching the .eq() condition, or the data being identical.`);
    // Optionally, return a specific error/warning if no rows were updated
    // return new Response(JSON.stringify({ 
    //   success: false, // Or true, but with a warning
    //   message: "Embedding generated, but no record was updated in the database. Please check RLS or if the activity exists and data differs.",
    //   embedding // Still return the embedding if generated
    // }), {
    //   status: 200, // Or an appropriate error status like 409 (Conflict) or 500
    //   headers: { ...corsHeaders, "Content-Type": "application/json" },
    // });
    }
    console.log(`Embedding for activity ${activity.id} saved successfully.`);
    return new Response(JSON.stringify({
      success: true,
      embedding,
      updateResult: {
        status: updateStatus,
        count: updateCount,
        data: updateData
      }
    }), {
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json"
      }
    });
  } catch (error) {
    console.error("Error in generate_activity_embeddings function:", error);
    if (error instanceof OpenAI.APIError) {
      return new Response(JSON.stringify({
        success: false,
        error: `OpenAI API Error: ${error.status} ${error.name} - ${error.message}`
      }), {
        status: error.status || 500,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json"
        }
      });
    }
    return new Response(JSON.stringify({
      success: false,
      error: error.message || "An unexpected error occurred."
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json"
      }
    });
  }
});
