// index.ts
import { serve } from "https://deno.land/std@0.131.0/http/server.ts";
import { createClient } from "@supabase/supabase-js";
import { corsHeaders } from "../_shared/cors.ts";
import { fetchHotelData, fetchAccountData, fetchLocationData, fetchGalleryImages } from "./data.fetcher.ts";
import { generateHotelSocialImageHtml } from "./template.generator.ts";
// Constantes para los servicios externos
const GOTENBERG_URL = Deno.env.get("GOTENBERG_URL") || "https://gotenberg.example.com";
const PDF_PASSWORD = Deno.env.get("PDF_PASSWORD");
console.log("Función generate-hotel-social-image-gotenberg iniciando...");
serve(async (req)=>{
  console.log("Recibiendo solicitud para generate-hotel-social-image-gotenberg");
  // Handle CORS
  if (req.method === "OPTIONS") {
    return new Response(null, {
      headers: corsHeaders,
      status: 204
    });
  }
  try {
    let hotelId = null;
    // Extraer hotelId dependiendo del método HTTP
    if (req.method === "GET") {
      // Para peticiones GET, extraer el hotelId de los parámetros de consulta
      const url = new URL(req.url);
      hotelId = url.searchParams.get("hotelId");
    } else if (req.method === "POST") {
      // Para peticiones POST, extraer el hotelId del cuerpo de la solicitud
      try {
        const body = await req.json();
        hotelId = body.hotelId;
      } catch (e) {
        return new Response(JSON.stringify({
          error: "Invalid JSON body or missing 'hotelId' in request body"
        }), {
          status: 400,
          headers: {
            ...corsHeaders,
            'Content-Type': 'application/json'
          }
        });
      }
    } else {
      // Si el método no es GET ni POST, devolver error
      return new Response(JSON.stringify({
        error: "Method not allowed. Use GET or POST."
      }), {
        status: 405,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
          'Allow': 'GET, POST, OPTIONS'
        }
      });
    }
    // Verificar que se proporcionó un hotelId
    if (!hotelId) {
      return new Response(JSON.stringify({
        error: "Missing 'hotelId' parameter"
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // Initialize Supabase client
    const supabase = createClient(Deno.env.get("SUPABASE_URL") ?? "", Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "");
    // Obtener datos del hotel
    const hotel = await fetchHotelData(hotelId, supabase);
    if (!hotel) {
      return new Response(JSON.stringify({
        error: "Hotel not found"
      }), {
        status: 404,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // Obtener datos relacionados
    const [account, location, galleryImages] = await Promise.all([
      fetchAccountData(hotel.account_id, supabase),
      fetchLocationData(hotel.location, supabase),
      fetchGalleryImages(hotelId, hotel.main_image, supabase)
    ]);
    // Generar datos de la plantilla
    const templateData = {
      hotel,
      account,
      location,
      galleryImages
    };
    // Generar HTML para la imagen social
    const html = generateHotelSocialImageHtml(templateData);
    // Configurar la solicitud a Gotenberg
    const gotenbergUrl = `${GOTENBERG_URL}/forms/chromium/convert/image`;
    // Crear formulario con los datos
    const formData = new FormData();
    formData.append('index.html', new Blob([
      html
    ], {
      type: 'text/html'
    }), 'index.html');
    // Configuración para la conversión de HTML a imagen
    formData.append('paperWidth', '800');
    formData.append('paperHeight', '800');
    formData.append('marginTop', '0');
    formData.append('marginBottom', '0');
    formData.append('marginLeft', '0');
    formData.append('marginRight', '0');
    formData.append('preferCssPageSize', 'true');
    formData.append('imageFormat', 'png');
    formData.append('waitForExpression', 'document.fonts.ready');
    console.log(`Enviando solicitud a Gotenberg (${gotenbergUrl})`);
    // Enviar solicitud a Gotenberg
    const gotenbergResponse = await fetch(gotenbergUrl, {
      method: 'POST',
      body: formData
    });
    if (!gotenbergResponse.ok) {
      console.error(`Error en Gotenberg: ${gotenbergResponse.status} ${gotenbergResponse.statusText}`);
      const errorText = await gotenbergResponse.text();
      console.error(`Detalle del error: ${errorText}`);
      return new Response(JSON.stringify({
        error: `Gotenberg error: ${gotenbergResponse.status}`
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    console.log('Imagen social generada correctamente');
    // Devolver la imagen generada
    return new Response(gotenbergResponse.body, {
      status: 200,
      headers: {
        ...corsHeaders,
        'Content-Type': 'image/png',
        'Content-Disposition': `inline; filename="hotel_${hotelId}_social_image.png"`
      }
    });
  } catch (error) {
    console.error("Error en generate-hotel-social-image-gotenberg:", error);
    return new Response(JSON.stringify({
      error: `Internal error: ${error.message}`
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
});
