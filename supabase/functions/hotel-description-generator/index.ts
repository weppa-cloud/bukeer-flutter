// supabase/functions/hotel-description-generator/index.ts
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
// Configure Supabase client
const supabaseUrl = Deno.env.get('SUPABASE_URL') || '';
const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') || '';
const openaiApiKey = Deno.env.get('OPENAI_API_KEY') || '';
const serperApiKey = Deno.env.get('SERPER_API_KEY') || '' // Add Serper API key for search
;
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
    const { hotelId } = await req.json();
    // Validate input
    if (!hotelId) {
      return new Response(JSON.stringify({
        error: 'Hotel ID is required'
      }), {
        headers,
        status: 400
      });
    }
    console.log(`Processing hotel with ID: ${hotelId}`);
    // Fetch hotel data from Supabase
    const { data: hotel, error: hotelError } = await supabase.from('hotels').select('name, description, inclutions, exclutions, recomendations, instructions, location').eq('id', hotelId).single();
    if (hotelError) {
      return new Response(JSON.stringify({
        error: 'Error fetching hotel data',
        details: hotelError
      }), {
        headers,
        status: 500
      });
    }
    if (!hotel) {
      return new Response(JSON.stringify({
        error: 'Hotel not found'
      }), {
        headers,
        status: 404
      });
    }
    // Fetch location data for the hotel
    let locationInfo = {};
    if (hotel.location) {
      const { data: location, error: locationError } = await supabase.from('locations').select('address, city, country, state').eq('id', hotel.location).single();
      if (!locationError && location) {
        locationInfo = location;
      }
    }
    // Remove web search code
    // Prepare prompt for OpenAI
    const prompt = `
**Objetivo:**  Crear una descripción persuasiva y concisa tipo recomendación de parte del travel planner de actividad, del hotel para compartir por WhatsApp, que presente la actividad como una opción atractiva sin dirigirse a un perfil específico de viajero. Esta descripción será una de varias que se enviarán al cliente para que elija su preferida.

**Instrucciones para la descripción:**

1. **Formato óptimo para WhatsApp:** 
   - Extensión exacta: 350-400 caracteres sin contar el llamando a la acción, 
   - Máximo 3 párrafos
   - Incorpora 2-3 emojis estratégicos relacionados con beneficios clave del hotel

2. **Elementos de persuasión:**
   - Inicia con una frase impactante sobre el hotel
   - Destaca características exclusivas o diferenciadoras del hotel
   - Menciona brevemente la ubicación solo si es un punto fuerte
    - No pongas llamdo a la acción al final.
    
3. **Estilo y tono:**
   - Lenguaje directo, claro y evocador (que cree imágenes mentales)
   - Enfoque en los atributos objetivos del hotel, no en el tipo de viajero
   - Tono profesional pero cercano, como el de un agente de viajes experimentado

4. **Consideraciones importantes:**
   - NO usar comillas ni simbiolos que error dentro de un json
   - NO segmentar ni dirigir el mensaje a familias, parejas o grupos específicos
   - Mantener la descripción genérica pero atractiva
   - Presentar el hotel como una opción, no como una recomendación personalizada

**Datos del Hotel:**
* **Nombre:** ${hotel.name}
* **Ubicación:** ${locationInfo.city || ''}, ${locationInfo.country || ''} - ${locationInfo.address || ''}
* **Descripción original:** ${hotel.description || ''}
* **Incluye:** ${hotel.inclutions || ''}
* **No incluye:** ${hotel.exclutions || ''}
* **Observaciones:** ${hotel.instructions || ''}

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
            "content": "Eres un experto consultor de viajes que escribe descripciones cortas y persuasivas para hoteles."
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
    // Update hotel with new short description
    const { error: updateError } = await supabase.from('hotels').update({
      description_short: shortDescription
    }).eq('id', hotelId);
    if (updateError) {
      return new Response(JSON.stringify({
        error: 'Error updating hotel description',
        details: updateError
      }), {
        headers,
        status: 500
      });
    }
    // Return success response
    return new Response(JSON.stringify({
      success: true,
      hotel_id: hotelId,
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
