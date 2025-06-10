// supabase/functions/process-flight-extraction/index.ts
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'; // O una versión más reciente si prefieres
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'; // Asegúrate de que la versión sea compatible
import { corsHeaders } from '../_shared/cors.ts'; // Asume que tienes este archivo para CORS
// Función para redondear a 2 decimales y evitar errores de punto flotante
function roundToTwoDecimals(value) {
  return Math.round((value + Number.EPSILON) * 100) / 100;
}
// --- Función para llamar a OpenAI ---
async function callOpenAI(prompt, apiKey) {
  console.log("Sending request to OpenAI...");
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${apiKey}`
    },
    body: JSON.stringify({
      model: 'gpt-4o',
      messages: [
        {
          role: 'user',
          content: prompt
        }
      ]
    })
  });
  const responseBodyText = await response.text(); // Leer cuerpo siempre
  if (!response.ok) {
    console.error(`OpenAI API Error (${response.status}): ${responseBodyText}`);
    throw new Error(`OpenAI API Error: ${response.status}. Body: ${responseBodyText}`);
  }
  console.log("Received response from OpenAI.");
  try {
    const data = JSON.parse(responseBodyText);
    const content = data.choices?.[0]?.message?.content;
    if (!content) {
      console.error("Invalid OpenAI response structure:", data);
      throw new Error("Invalid OpenAI response structure - missing content");
    }
    return content;
  } catch (parseError) {
    console.error("Failed to parse OpenAI JSON response:", parseError);
    console.error("Raw OpenAI response body:", responseBodyText);
    throw new Error("Failed to parse OpenAI JSON response.");
  }
}
// --- Función para parsear y limpiar la respuesta JSON de OpenAI ---
function parseOpenAIResponse(rawContent) {
  console.log("Parsing OpenAI response...");
  try {
    // Quitar ```json y parsear
    const cleanedString = rawContent.replace(/(^```json|```$)/g, '').trim();
    const parsedJson = JSON.parse(cleanedString);
    if (!parsedJson.itinerary_items || !Array.isArray(parsedJson.itinerary_items)) {
      console.error("Parsed JSON missing 'itinerary_items' array:", parsedJson);
      throw new Error("Parsed JSON missing 'itinerary_items' array");
    }
    console.log("Successfully parsed itinerary_items array.");
    return parsedJson.itinerary_items;
  } catch (error) {
    console.error("Failed to parse OpenAI response string:", error);
    console.error("Raw content was:", rawContent);
    throw new Error(`Failed to parse OpenAI response string: ${error.message}`);
  }
}
// --- Función Principal del Servidor ---
serve(async (req)=>{
  // Manejar preflight CORS (necesario para invocaciones desde navegador, menos crítico para pg_net)
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: corsHeaders
    });
  }
  let itineraryIdForErrorLogging = null; // Para loguear errores
  try {
    // 1. Obtener datos del cuerpo de la solicitud (enviados por pg_net)
    const { itinerary_id, account_id, text_to_analyze } = await req.json();
    itineraryIdForErrorLogging = itinerary_id; // Guardar para logs de error
    console.log(`Processing request for itinerary: ${itinerary_id}, account: ${account_id}`);
    if (!itinerary_id || !account_id || !text_to_analyze) {
      throw new Error("Missing required parameters: itinerary_id, account_id, or text_to_analyze.");
    }
    // 2. Obtener Secretos (Variables de Entorno)
    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
    // El de OpenAI sigue igual:
    const openAIKey = Deno.env.get('OPENAI_API_KEY');
    // La verificación ahora usa los nombres estándar:
    if (!supabaseUrl || !supabaseServiceKey || !openAIKey) {
      console.error('Missing required environment variables (OpenAI Key, Supabase URL or Service Key).');
      throw new Error('Server configuration error: Missing environment variables.');
    }
    // 3. Construir el Prompt (Asegúrate de pedir números limpios y solo los datos base necesarios)
    const prompt = `
Eres un asistente que extrae información de vuelos de un texto.
Extrae los vuelos como trayectos completos, no por tramos individuales. Identifica si el texto contiene información de ida y vuelta. 

IMPORTANTE: Debes generar un JSON válido sin comentarios. Los comentarios que se muestran a continuación son solo para tu comprensión, pero NO debes incluirlos en tu respuesta final.

INSTRUCCIONES ESPECIALES PARA QUANTITY (NÚMERO DE PASAJEROS):
1. Busca en TODO el texto referencias a la cantidad de pasajeros como "X pasajeros", "X adultos", "X boletos", "por X personas", etc.
2. Si encuentras el número total de pasajeros en cualquier parte del texto, usa ese número en el campo "quantity" para TODOS los vuelos.
3. Si hay información específica de diferentes tipos de pasajeros (adultos, niños, etc.), suma todos para obtener el total.
4. Si no encuentras información explícita, asume que es 1 pasajero.

INSTRUCCIONES ESPECIALES PARA PRECIOS:
1. Para valores monetarios, elimina TODOS los puntos (.) que son separadores de miles
2. Reemplaza TODAS las comas (,) por puntos (.) para los decimales
3. Por ejemplo: si ves "1.217.474,00" debes convertirlo a "1217474.00"
4. Nunca uses separador de miles, solo decimal con punto (.) si aplica

INSTRUCCIONES ESPECIALES PARA AEROLÍNEAS:
1. Para el campo "airline", incluye SOLO el nombre comercial de la aerolínea (JetSMART, Avianca, LATAM, etc.)
2. Elimina sufijos legales como "Airlines", "S.A.", "S.A.S", "LLC", etc.

Devuelve estrictamente un JSON con la siguiente estructura. Para los campos numéricos (unit_cost, quantity), devuelve solo el número, sin símbolos de moneda ni separadores de miles, usando punto (.) como separador decimal si es necesario.

{
  "itinerary_items": [
    {
      "Date": "YYYY-MM-DD", // Fecha de salida
      "Product_name": "Vuelo [ORIGEN]-[DESTINO]", // Ejemplo: "Vuelo BOG-MAD"
      "unit_cost": 1217474.00, // Costo del vuelo completo para TODOS los pasajeros - SIN SEPARADORES DE MILES
      "quantity": 2, // IMPORTANTE: Número de pasajeros - BUSCA ESTA INFORMACIÓN EN TODO EL TEXTO
      "flight_departure": "Código IATA o Ciudad Origen del trayecto completo",
      "flight_arrival": "Código IATA o Ciudad Destino final",
      "departure_time": "HH:MM", // Hora de salida del origen
      "arrival_time": "HH:MM", // Hora de llegada al destino final
      "airline": "Nombre de la aerolínea principal", // SOLO el nombre comercial de la aerolínea, sin sufijos legales
      "layovers": "Descripción de escalas con nombres de ciudades - Ejemplo: 1 escala en Miami (2h 30m), 1 escala en Madrid (1h 45m)",
      "baggage_info": "Información sobre equipaje - Ejemplo: 1 maleta de 23kg",
      "is_return": false // true si es el vuelo de regreso, false si es vuelo de ida
    }
    // ... más trayectos si los hay ...
  ]
}

Texto a analizar:
"""
${text_to_analyze}
"""`;
    // 4. Llamar a OpenAI
    const openAIResultString = await callOpenAI(prompt, openAIKey);
    // 5. Parsear la respuesta
    const flightItemsFromAI = parseOpenAIResponse(openAIResultString);
    console.log(`Parsed ${flightItemsFromAI.length} potential flight items.`);
    console.log("Items extraídos por la IA:", JSON.stringify(flightItemsFromAI, null, 2));
    if (flightItemsFromAI.length === 0) {
      console.log("No flight items extracted by AI.");
      // Considera si quieres actualizar el estado del itinerario a 'completado_vacio' o similar
      return new Response(JSON.stringify({
        success: true,
        items_added: 0,
        message: "No items extracted."
      }), {
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        },
        status: 200
      });
    }
    // 6. Crear cliente Supabase Admin (con Service Role Key)
    // Esto bypaseará RLS, ten cuidado si necesitas aplicar permisos específicos.
    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey);
    // 7. Preparar datos para insertar
    // Primero, identificamos si hay vuelos de ida y vuelta para distribuir costos
    const hasReturnFlights = flightItemsFromAI.some((item)=>item.is_return === true);
    const outboundFlights = flightItemsFromAI.filter((item)=>item.is_return !== true);
    const returnFlights = flightItemsFromAI.filter((item)=>item.is_return === true);
    console.log(`Detected ${outboundFlights.length} outbound flights and ${returnFlights.length} return flights`);
    const resolvedItems = await Promise.all(flightItemsFromAI.map(async (item, index, array)=>{
      // Obtener la cantidad (número de pasajeros)
      const quantity = parseInt(String(item.quantity)) || 1;
      // Determinar si es un vuelo de regreso
      const isReturn = item.is_return === true;
      // Calcular el costo unitario basado en:
      // 1. Si hay vuelos de ida y vuelta, dividir el costo total entre 2
      // 2. Luego dividir entre el número de pasajeros
      const rawTotalCost = parseFloat(String(item.unit_cost)) || 0;
      // Si hay vuelos de ida y vuelta, el costo proporcionado es para ambos trayectos
      let effectiveUnitCost;
      if (hasReturnFlights && !isReturn) {
        // Si hay vuelos de ida y vuelta, y este es el vuelo de ida
        // Asignamos el costo total completo al vuelo de ida
        // Solo dividimos entre el número de pasajeros
        effectiveUnitCost = rawTotalCost / quantity;
        console.log(`Vuelo ida: Costo total ${rawTotalCost}, Pasajeros ${quantity}, Costo unitario ${effectiveUnitCost}`);
      } else if (isReturn) {
        // Para vuelos de regreso, establecemos costo en 0 para evitar duplicar
        effectiveUnitCost = 0;
        console.log(`Vuelo regreso: Costo unitario ${effectiveUnitCost} (costo asignado al vuelo de ida)`);
      } else {
        // Si solo hay vuelo de ida (sin regreso), simplemente dividimos entre pasajeros
        effectiveUnitCost = rawTotalCost / quantity;
        console.log(`Solo ida: Costo total ${rawTotalCost}, Pasajeros ${quantity}, Costo unitario ${effectiveUnitCost}`);
      }
      const profitPercentage = 0;
      const unitPrice = effectiveUnitCost * (1 + profitPercentage / 100);
      const totalCost = effectiveUnitCost * quantity;
      const totalPrice = unitPrice * quantity;
      // Buscar ID de la aerolínea en la tabla airlines
      let airlineId = null;
      let airlineName = item.airline || "No especificada";
      if (item.airline) {
        try {
          // Primero intenta una búsqueda exacta
          const { data: exactMatch, error: exactMatchError } = await supabaseAdmin.from('airlines').select('id, name').eq('name', item.airline).maybeSingle();
          if (exactMatch?.id) {
            airlineId = exactMatch.id;
            console.log(`Found exact match for airline '${item.airline}': ${exactMatch.name} (ID: ${airlineId})`);
          } else {
            // Si no hay coincidencia exacta, intenta una búsqueda parcial
            const { data: partialMatches, error: partialMatchError } = await supabaseAdmin.from('airlines').select('id, name').ilike('name', `%${item.airline}%`).limit(1);
            if (partialMatches && partialMatches.length > 0) {
              airlineId = partialMatches[0].id;
              console.log(`Found partial match for airline '${item.airline}': ${partialMatches[0].name} (ID: ${airlineId})`);
            } else {
              console.warn(`No airline found for '${item.airline}' (neither exact nor partial match)`);
            }
          }
        } catch (airlineError) {
          console.warn(`Error fetching airline ID for ${item.airline}:`, airlineError.message);
        }
      }
      // Calcular duración del vuelo
      const departureTime = new Date(`1970-01-01T${item.departure_time}:00Z`);
      const arrivalTime = new Date(`1970-01-01T${item.arrival_time}:00Z`);
      const durationMs = arrivalTime - departureTime;
      const durationHours = Math.floor(durationMs / (1000 * 60 * 60));
      const durationMinutes = Math.floor(durationMs % (1000 * 60 * 60) / (1000 * 60));
      const duration = `${durationHours}h ${durationMinutes}m`;
      // Determinar si es vuelo de ida o regreso para incluir en el mensaje
      const flightDirection = isReturn ? "Vuelo de Regreso" : "Vuelo de Ida";
      // Crear mensaje personalizado con toda la información
      const personalizedMessage = `${flightDirection}, Escalas: ${item.layovers || 'Directo'}, Duración: ${duration}, Equipaje: ${item.baggage_info || 'No especificado'}`;
      return {
        id_itinerary: itinerary_id,
        account_id: account_id,
        date: item.Date,
        product_name: isReturn ? `${item.Product_name} (Regreso)` : item.Product_name,
        unit_cost: roundToTwoDecimals(effectiveUnitCost),
        profit_percentage: profitPercentage,
        unit_price: roundToTwoDecimals(unitPrice),
        total_cost: roundToTwoDecimals(totalCost),
        total_price: roundToTwoDecimals(totalPrice),
        quantity: quantity,
        flight_departure: item.flight_departure,
        flight_arrival: item.flight_arrival,
        departure_time: item.departure_time,
        arrival_time: item.arrival_time,
        airline: airlineId,
        airline_name_extracted: airlineName,
        id_product: airlineId,
        product_type: 'Vuelos',
        personalized_message: personalizedMessage // Toda la información en este campo
      };
    }));
    // Verificar si todas las aerolíneas fueron encontradas
    const missingAirlines = resolvedItems.filter((item)=>item.airline_name_extracted && !item.airline).map((item)=>item.airline_name_extracted);
    if (missingAirlines.length > 0) {
      const errorMessage = `No se encontraron las aerolineas, indicalas de forma especifica en el texto`;
      console.error("AIRLINE_NOT_FOUND:", errorMessage);
      // Actualizar el estado del itinerario a fallido con mensaje específico
      if (itinerary_id) {
        await supabaseAdmin.from('itineraries').update({
          last_import_status: 'failed',
          last_import_details: {
            timestamp: new Date().toISOString(),
            error_code: 'AIRLINE_NOT_FOUND',
            error_message: errorMessage,
            airlines_not_found: missingAirlines
          },
          updated_at: new Date().toISOString()
        }).eq('id', itinerary_id);
      }
      // Detener la ejecución con un error específico
      return new Response(JSON.stringify({
        success: false,
        error_code: 'AIRLINE_NOT_FOUND',
        error_message: errorMessage,
        airlines_not_found: missingAirlines
      }), {
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        },
        status: 422 // Unprocessable Entity - código apropiado para datos válidos pero no procesables
      });
    }
    // Filtrar los elementos válidos después de resolver todas las promesas y asegurar formato decimal correcto
    const itemsToInsert = resolvedItems.filter((item)=>item.date && item.product_name).map((item)=>{
      // Eliminar el campo airline_name_extracted que no existe en la tabla
      const { airline_name_extracted, ...itemWithoutExtraFields } = item;
      // Asegurar que todos los campos numéricos tienen exactamente 2 decimales
      return {
        ...itemWithoutExtraFields,
        unit_cost: roundToTwoDecimals(item.unit_cost),
        unit_price: roundToTwoDecimals(item.unit_price),
        total_cost: roundToTwoDecimals(item.total_cost),
        total_price: roundToTwoDecimals(item.total_price)
      };
    });
    if (itemsToInsert.length === 0) {
      console.log("No valid items to insert after mapping.");
      return new Response(JSON.stringify({
        success: true,
        items_added: 0,
        message: "No valid items to insert."
      }), {
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        },
        status: 200
      });
    }
    console.log(`Attempting to insert ${itemsToInsert.length} items into database...`);
    // 8. Insertar en Supabase
    const { data: insertedData, error: insertError } = await supabaseAdmin.from('itinerary_items').insert(itemsToInsert).select(); // Devuelve los registros insertados
    if (insertError) {
      console.error('Database - Error inserting itinerary items:', insertError);
      // Podrías intentar actualizar el estado a 'failed' aquí
      throw insertError; // Propaga el error para que sea capturado abajo
    }
    const itemsAddedCount = insertedData?.length ?? 0;
    console.log(`Database - Successfully inserted ${itemsAddedCount} items.`);
    // 9. (Opcional) Actualizar estado en itinerario para notificar al frontend vía Realtime
    // Crea un campo 'last_import_status' (TEXT) y 'last_import_details' (JSONB) en tu tabla 'itineraries' si quieres usar esto.
    console.log(`Updating itinerary ${itinerary_id} status...`);
    const { error: updateError } = await supabaseAdmin.from('itineraries').update({
      last_import_status: 'completed',
      last_import_details: {
        timestamp: new Date().toISOString(),
        items_added: itemsAddedCount
      },
      updated_at: new Date().toISOString() // Importante para disparar Realtime si escucha por updated_at
    }).eq('id', itinerary_id);
    if (updateError) {
      // No es crítico, solo loguear
      console.warn(`Database - Could not update itinerary ${itinerary_id} status after import:`, updateError.message);
    } else {
      console.log(`Database - Successfully updated itinerary ${itinerary_id} status.`);
    }
    // 10. Devolver éxito
    return new Response(JSON.stringify({
      success: true,
      items_added: itemsAddedCount
    }), {
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      },
      status: 200
    });
  } catch (error) {
    console.error(`Unhandled error processing itinerary ${itineraryIdForErrorLogging || 'unknown'}:`, error);
    // Intentar actualizar estado de itinerario a fallido si tenemos el ID
    if (itineraryIdForErrorLogging && Deno.env.get('PROJECT_URL') && Deno.env.get('SERVICE_ROLE_KEY')) {
      try {
        const supabaseAdminForError = createClient(Deno.env.get('PROJECT_URL'), Deno.env.get('SERVICE_ROLE_KEY'));
        await supabaseAdminForError.from('itineraries').update({
          last_import_status: 'failed',
          last_import_details: {
            timestamp: new Date().toISOString(),
            error: error.message
          },
          updated_at: new Date().toISOString()
        }).eq('id', itineraryIdForErrorLogging);
        console.log(`Database - Updated itinerary ${itineraryIdForErrorLogging} status to failed.`);
      } catch (updateErr) {
        console.error(`Database - Critical: Failed to update itinerary ${itineraryIdForErrorLogging} status to failed:`, updateErr);
      }
    }
    // Devolver error
    return new Response(JSON.stringify({
      success: false,
      error: error.message
    }), {
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      },
      status: 500
    });
  }
});
