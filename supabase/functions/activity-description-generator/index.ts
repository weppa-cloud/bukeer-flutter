// supabase/functions/activity-description-generator/index.ts
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
// Configure Supabase client
const supabaseUrl = Deno.env.get('SUPABASE_URL') || '';
const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') || '';
const openaiApiKey = Deno.env.get('OPENAI_API_KEY') || '';
const supabase = createClient(supabaseUrl, supabaseServiceKey);
serve(async (req)=>{
  // CORS headers
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Content-Type': 'application/json'
  };
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      headers,
      status: 204
    });
  }
  try {
    // Parse request body
    const { activityId } = await req.json();
    // Validate input
    if (!activityId) {
      return new Response(JSON.stringify({
        error: 'Activity ID is required'
      }), {
        headers,
        status: 400
      });
    }
    console.log(`Processing activity with ID: ${activityId}`);
    // Fetch activity data from Supabase
    const { data: activity, error: activityError } = await supabase.from('activities').select('name, description, inclutions, exclutions, recomendations, instructions, location, type, duration_minutes').eq('id', activityId).single();
    if (activityError) {
      return new Response(JSON.stringify({
        error: 'Error fetching activity data',
        details: activityError
      }), {
        headers,
        status: 500
      });
    }
    if (!activity) {
      return new Response(JSON.stringify({
        error: 'Activity not found'
      }), {
        headers,
        status: 404
      });
    }
    // Fetch location data for the activity
    let locationInfo = {};
    if (activity.location) {
      const { data: location, error: locationError } = await supabase.from('locations').select('address, city, country, state').eq('id', activity.location).single();
      if (!locationError && location) {
        locationInfo = location;
      }
    }
    // Prepare prompt for OpenAI
    const prompt = `
**Objetivo:** Crear una descripción persuasiva y concisa tipo recomendación de parte del travel planner de actividad, paquete o servicio turístico para compartir por WhatsApp, que presente la actividad como una opción atractiva sin dirigirse a un perfil específico de viajero. Esta descripción será una de varias que se enviarán al cliente para que elija su preferida.

**Instrucciones para la descripción:**

1. **Formato óptimo para WhatsApp:** 
   - Extensión exacta: 350-400 caracteres sin contar el llamando a la acción, 
   - máximo 3 párrafos
   - Incorpora 2-3 emojis estratégicos relacionados con los aspectos más atractivos de la actividad


2. **Elementos de persuasión:**
   - Inicia con una frase impactante sobre la experiencia o lo que hace única esta actividad
   - Destaca qué podrá ver, hacer o experimentar el visitante
   - Menciona la duración y ubicación si son relevantes
   - No pongas llamdo a la acción al final.

3. **Estilo y tono:**
   - Lenguaje dinámico, vívido y evocador (que cree imágenes mentales)
   - Enfatiza la experiencia sensorial/emocional, no solo aspectos logísticos
   - Tono entusiasta pero profesional, como el de un guía turístico experto

4. **Consideraciones importantes:**
    - NO usar comillas ni simbiolos que error dentro de un json
   - NO segmentar ni dirigir el mensaje a perfiles específicos de turistas
   - La descripción debe ser atractiva para un público general
   - Presentar la actividad como una experiencia memorable, resaltando sus aspectos únicos

**Datos de la Actividad:**
* **Nombre:** ${activity.name}
* **Tipo:** ${activity.type || ''}
* **Duración:** ${activity.duration_minutes ? `${activity.duration_minutes} minutos` : 'No especificada'}
* **Ubicación:** ${locationInfo.city || ''}, ${locationInfo.country || ''} - ${locationInfo.address || ''}
* **Descripción original:** ${activity.description || ''}
* **Incluye:** ${activity.inclutions || ''}
* **No incluye:** ${activity.exclutions || ''}
* **Recomendaciones:** ${activity.recomendations || ''}

Genera ÚNICAMENTE la descripción para WhatsApp con exactamente 450-500 caracteres.
`;
    // Call OpenAI API directly using fetch
    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${openaiApiKey}`
      },
      body: JSON.stringify({
        model: "gpt-4o",
        messages: [
          {
            "role": "system",
            "content": "Eres un experto en turismo que escribe descripciones cortas y persuasivas para actividades y experiencias turísticas."
          },
          {
            "role": "user",
            "content": prompt
          }
        ],
        max_tokens: 200,
        temperature: 0.7
      })
    });
    // Parse the response
    const completion = await response.json();
    if (!completion.choices || !completion.choices[0] || !completion.choices[0].message) {
      throw new Error('Invalid response from OpenAI API: ' + JSON.stringify(completion));
    }
    const shortDescription = completion.choices[0].message.content.trim();
    // Update activity with new short description
    const { error: updateError } = await supabase.from('activities').update({
      description_short: shortDescription
    }).eq('id', activityId);
    if (updateError) {
      return new Response(JSON.stringify({
        error: 'Error updating activity description',
        details: updateError
      }), {
        headers,
        status: 500
      });
    }
    // Return success response
    return new Response(JSON.stringify({
      success: true,
      activity_id: activityId,
      description_short: shortDescription,
      model_used: "gpt-4o"
    }), {
      headers,
      status: 200
    });
  } catch (error) {
    console.error('Error:', error);
    return new Response(JSON.stringify({
      error: 'Internal server error',
      details: error.message
    }), {
      headers,
      status: 500
    });
  }
});
