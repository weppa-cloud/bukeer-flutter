// supabase/functions/generate-activity-social-image-gotenberg/index.ts
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from '@supabase/supabase-js';
import { corsHeaders } from '../_shared/cors.ts';
import { fetchActivityData, fetchAccountData, fetchGalleryImages, fetchLocationData } from './data.fetcher.ts';
import { generateActivitySocialImageHtml } from './template.generator.ts';
// --- Constants ---
// Corrected endpoint path based on actual Gotenberg documentation
const GOTENBERG_URL = 'https://demo.gotenberg.dev/forms/chromium/screenshot/html'; // Correct screenshot endpoint
const STORAGE_BUCKET_NAME = 'social-images';
const DEBUG = true; // Set to true to show HTML in response in case of error
const IMAGE_FORMAT = 'jpeg'; // Options: 'jpeg', 'png', or 'webp'
const IMAGE_QUALITY = 90; // Only applicable for jpeg and webp (1-100)
// --- Main Logic (Orchestrator) ---
serve(async (req)=>{
  // --- CORS and Method Handling ---
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: corsHeaders
    });
  }
  let supabaseClient;
  let activityId = null;
  let htmlContent = '';
  try {
    // --- Initialize Supabase Client ---
    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
    if (!supabaseUrl || !serviceRoleKey) {
      throw new Error("SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required.");
    }
    supabaseClient = createClient(supabaseUrl, serviceRoleKey);
    // --- Get activityId (POST or GET) ---
    if (req.method === 'POST') {
      try {
        if (!req.headers.get('content-type')?.includes('application/json')) {
          return new Response(JSON.stringify({
            error: 'Content-Type: application/json expected for POST'
          }), {
            status: 415,
            headers: {
              ...corsHeaders,
              'Content-Type': 'application/json'
            }
          });
        }
        const body = await req.json();
        activityId = body.activityId;
      } catch (e) {
        console.error("Error parsing JSON body:", e);
        return new Response(JSON.stringify({
          error: 'Invalid or missing JSON body',
          details: e.message
        }), {
          status: 400,
          headers: {
            ...corsHeaders,
            'Content-Type': 'application/json'
          }
        });
      }
    } else if (req.method === 'GET') {
      const url = new URL(req.url);
      activityId = url.searchParams.get('activityId');
    } else {
      return new Response(JSON.stringify({
        error: `Method ${req.method} not supported.`
      }), {
        status: 405,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
          'Allow': 'POST, GET, OPTIONS'
        }
      });
    }
    // --- Validate activityId ---
    if (!activityId) {
      console.error("activityId is missing");
      return new Response(JSON.stringify({
        error: 'activityId parameter/body is required'
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    if (!/^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/.test(activityId)) {
      console.error(`[${activityId}] Invalid UUID format`);
      return new Response(JSON.stringify({
        error: 'Invalid activityId format'
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    console.log(`[${activityId}] Starting social image generation process...`);
    // --- Fetch Main Data and Related Data ---
    console.log(`[${activityId}] Fetching activity data...`);
    const activity = await fetchActivityData(activityId, supabaseClient);
    if (!activity) {
      console.warn(`[${activityId}] Activity not found.`);
      return new Response(JSON.stringify({
        error: `Activity with ID ${activityId} not found`
      }), {
        status: 404,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    console.log(`[${activityId}] Activity found: ${activity.name}`);
    // --- Fetch related data in parallel for efficiency ---
    console.log(`[${activityId}] Fetching related data...`);
    const [account, galleryImages, location] = await Promise.all([
      fetchAccountData(activity.account_id, supabaseClient),
      fetchGalleryImages(activityId, activity.main_image, supabaseClient),
      fetchLocationData(activity.location, supabaseClient)
    ]);
    // Debug logs
    console.log(`[${activityId}] Data fetched - Account:`, account ? `ID: ${account.id}, Name: ${account.name}` : 'NULL');
    console.log(`[${activityId}] Data fetched - Gallery Images:`, `${galleryImages.length} images`);
    console.log(`[${activityId}] Data fetched - Location:`, location ? `${location.city || ''}, ${location.country || ''}` : 'NULL');
    // --- Prepare Template Data ---
    const templateData = {
      activity,
      account,
      galleryImages,
      location
    };
    // --- Generate HTML ---
    console.log(`[${activityId}] Generating HTML template...`);
    htmlContent = generateActivitySocialImageHtml(templateData);
    // DEBUG: Verify if HTML is generated correctly
    console.log(`[${activityId}] HTML template generated (${htmlContent.length} characters)`);
    // --- Prepare and Call Gotenberg for HTML to Image conversion ---
    const formData = new FormData();
    // Adding the HTML file - this is the primary requirement
    formData.append('files', new Blob([
      htmlContent
    ], {
      type: 'text/html'
    }), 'index.html');
    // Screenshot-specific parameters according to Gotenberg documentation
    formData.append('format', IMAGE_FORMAT); // 'jpeg', 'png', or 'webp'
    formData.append('quality', IMAGE_QUALITY.toString()); // 1-100 for JPEG and WebP
    formData.append('width', '800'); // Image width
    formData.append('height', '800'); // Image height
    // Speed optimization
    formData.append('optimizeForSpeed', 'true');
    // Wait for resources to load - important for accurate screenshot
    formData.append('waitDelay', '3s'); // 3 seconds wait
    formData.append('waitForExpression', 'window.imagesLoaded === true'); // Wait for our custom flag
    // Network idle event can help with loading dynamic content
    formData.append('skipNetworkIdleEvent', 'false');
    // Set User-Agent for better compatibility
    formData.append('extraHttpHeaders', JSON.stringify({
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }));
    console.log(`[${activityId}] Sending HTML to Gotenberg for image generation: ${GOTENBERG_URL}`);
    let gotenbergResponse;
    try {
      gotenbergResponse = await fetch(GOTENBERG_URL, {
        method: 'POST',
        body: formData
      });
    } catch (fetchError) {
      console.error(`[${activityId}] Fetch Error:`, fetchError);
      // Return detailed error if in debug mode
      if (DEBUG) {
        return new Response(JSON.stringify({
          error: 'Error connecting to image generation service',
          details: fetchError.message,
          html: htmlContent.substring(0, 1000) + "... [truncated]"
        }), {
          status: 502,
          headers: {
            ...corsHeaders,
            'Content-Type': 'application/json'
          }
        });
      }
      return new Response(JSON.stringify({
        error: 'Error connecting to image generation service',
        details: fetchError.message
      }), {
        status: 502,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    console.log(`[${activityId}] Gotenberg response status: ${gotenbergResponse.status}`);
    if (!gotenbergResponse.ok) {
      const errorBody = await gotenbergResponse.text();
      console.error(`[${activityId}] Gotenberg Error ${gotenbergResponse.status}:`, errorBody);
      // Return detailed error if in debug mode
      if (DEBUG) {
        return new Response(JSON.stringify({
          error: 'Error generating image with external service',
          details: `Gotenberg Status ${gotenbergResponse.status}`,
          gotenberg_error: errorBody,
          html: htmlContent.substring(0, 1000) + "... [truncated]"
        }), {
          status: 502,
          headers: {
            ...corsHeaders,
            'Content-Type': 'application/json'
          }
        });
      }
      return new Response(JSON.stringify({
        error: 'Error generating image with external service',
        details: `Gotenberg Status ${gotenbergResponse.status}`,
        gotenberg_error: errorBody
      }), {
        status: 502,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // --- Process Gotenberg Response and Upload to Storage ---
    const imageBuffer = await gotenbergResponse.arrayBuffer();
    console.log(`[${activityId}] Image received, size: ${imageBuffer.byteLength} bytes. Uploading...`);
    if (imageBuffer.byteLength === 0) {
      console.warn(`[${activityId}] Image generation returned empty buffer.`);
      // Return detailed error if in debug mode
      if (DEBUG) {
        return new Response(JSON.stringify({
          error: 'Image generation failed (empty buffer)',
          html: htmlContent.substring(0, 1000) + "... [truncated]"
        }), {
          status: 500,
          headers: {
            ...corsHeaders,
            'Content-Type': 'application/json'
          }
        });
      }
      return new Response(JSON.stringify({
        error: 'Image generation failed (empty buffer)'
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // --- Upload Image to Storage ---
    const safeActivityName = activity.name?.replace(/[^a-zA-Z0-9_.-]/g, '_') || 'activity';
    const timestamp = Date.now();
    const imagePath = `activity_social_images/${activityId}/${safeActivityName}_${timestamp}.${IMAGE_FORMAT}`;
    const contentType = `image/${IMAGE_FORMAT}`;
    const { data: storageData, error: storageError } = await supabaseClient.storage.from(STORAGE_BUCKET_NAME).upload(imagePath, imageBuffer, {
      contentType,
      cacheControl: '3600',
      upsert: false
    });
    if (storageError) {
      console.error(`[${activityId}] Storage Upload Error:`, storageError);
      return new Response(JSON.stringify({
        error: 'Image generated but failed to save it',
        details: storageError.message
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // --- Get Public URL and Return Final Response ---
    const { data: publicUrlData } = supabaseClient.storage.from(STORAGE_BUCKET_NAME).getPublicUrl(imagePath);
    const publicUrl = publicUrlData?.publicUrl || '';
    console.log(`[${activityId}] Image successfully uploaded to: ${imagePath}. Public URL: ${publicUrl || 'N/A'}`);
    // --- Update fields in activities table ---
    let databaseUpdated = false;
    if (publicUrl) {
      console.log(`[${activityId}] Updating social_image field in activities table...`);
      // Use social_image field 
      const { data: updateData, error: updateError } = await supabaseClient.from('activities').update({
        social_image: publicUrl
      }).eq('id', activityId);
      if (updateError) {
        console.error(`[${activityId}] Error updating social_image in database:`, updateError);
      } else {
        console.log(`[${activityId}] social_image field successfully updated in database`);
        databaseUpdated = true;
      }
    }
    const successResponse = {
      message: "Activity social image generated and saved successfully.",
      activityId: activityId,
      activityName: activity.name,
      publicUrl: publicUrl,
      path: imagePath,
      format: IMAGE_FORMAT,
      databaseUpdated: databaseUpdated
    };
    return new Response(JSON.stringify(successResponse), {
      status: 200,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  } catch (error) {
    // --- General Error Handling ---
    console.error(`[${activityId || 'N/A'}] Unhandled Exception in Edge Function:`, error);
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    // Return detailed error if in debug mode
    if (DEBUG && htmlContent) {
      return new Response(JSON.stringify({
        error: 'Internal server error',
        details: errorMessage,
        html: htmlContent.substring(0, 1000) + "... [truncated]"
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    return new Response(JSON.stringify({
      error: 'Internal server error',
      details: errorMessage
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
});
