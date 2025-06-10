// supabase/functions/generate-hotel-pdf/index.ts
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.7';
import { corsHeaders } from '../_shared/cors.ts';
import { fetchHotelData, fetchAccountData, fetchGalleryImages, fetchLocationData } from './data.fetcher.ts';
import { generateHotelPdfTemplate } from './template.generator.ts';
// --- Constantes ---
const GOTENBERG_URL = 'https://demo.gotenberg.dev/forms/chromium/convert/html'; // ¡USA TU PROPIA INSTANCIA EN PRODUCCIÓN!
const STORAGE_BUCKET_NAME = 'pdfs';
// --- Lógica Principal (Orquestador) ---
serve(async (req)=>{
  // --- Manejo CORS y Método ---
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: corsHeaders
    });
  }
  let supabaseClient;
  let hotelId = null;
  try {
    // --- Inicializar Cliente Supabase ---
    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
    if (!supabaseUrl || !serviceRoleKey) {
      throw new Error("SUPABASE_URL y SUPABASE_SERVICE_ROLE_KEY son requeridos.");
    }
    supabaseClient = createClient(supabaseUrl, serviceRoleKey);
    // --- Obtener hotelId (POST o GET) ---
    if (req.method === 'POST') {
      try {
        if (!req.headers.get('content-type')?.includes('application/json')) {
          return new Response(JSON.stringify({
            error: 'Se esperaba Content-Type: application/json para POST'
          }), {
            status: 415,
            headers: {
              ...corsHeaders,
              'Content-Type': 'application/json'
            }
          });
        }
        const body = await req.json();
        hotelId = body.hotelId;
      } catch (e) {
        console.error("Error parsing JSON body:", e);
        return new Response(JSON.stringify({
          error: 'Cuerpo JSON inválido o faltante',
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
      hotelId = url.searchParams.get('hotelId');
    } else {
      return new Response(JSON.stringify({
        error: `Método ${req.method} no soportado.`
      }), {
        status: 405,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
          'Allow': 'POST, GET, OPTIONS'
        }
      });
    }
    // --- Validar hotelId ---
    if (!hotelId) {
      console.error("hotelId is missing");
      return new Response(JSON.stringify({
        error: 'El parámetro/body hotelId es requerido'
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    if (!/^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/.test(hotelId)) {
      console.error(`[${hotelId}] Invalid UUID format`);
      return new Response(JSON.stringify({
        error: 'Formato de hotelId inválido'
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    console.log(`[${hotelId}] Iniciando proceso de generación de PDF...`);
    // --- Obtener Datos Principales y Relacionados ---
    console.log(`[${hotelId}] Fetching hotel data...`);
    const hotel = await fetchHotelData(hotelId, supabaseClient);
    if (!hotel) {
      console.warn(`[${hotelId}] Hotel no encontrado.`);
      return new Response(JSON.stringify({
        error: `Hotel con ID ${hotelId} no encontrado`
      }), {
        status: 404,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    console.log(`[${hotelId}] Hotel: ${hotel.name}. Fetching related data...`);
    // Ejecutar fetches relacionados en paralelo para eficiencia
    const [account, galleryImages, location] = await Promise.all([
      fetchAccountData(hotel.account_id, supabaseClient),
      fetchGalleryImages(hotelId, hotel.main_image, supabaseClient),
      fetchLocationData(hotel.location, supabaseClient)
    ]);
    // Debug para diagnóstico
    console.log(`[${hotelId}] Datos obtenidos - Account:`, account ? `ID: ${account.id}, Name: ${account.name}` : 'NULL');
    console.log(`[${hotelId}] Datos obtenidos - Gallery:`, `${galleryImages.length} imágenes`);
    console.log(`[${hotelId}] Datos obtenidos - Location:`, location ? `${location.city}, ${location.country}` : 'NULL');
    // --- Preparar Datos para la Plantilla ---
    const templateData = {
      hotel,
      account,
      galleryImages,
      location
    };
    // --- Generar HTML --- 
    console.log(`[${hotelId}] Rendering HTML...`);
    const htmlContent = generateHotelPdfTemplate(templateData);
    // Footer con barra azul abajo
    const footerHtmlContent = `
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
            }
            .footer-wrapper {
                position: fixed;
                bottom: 0;
                left: 0;
                right: 0;
                width: 100%;
            }
            .footer {
                font-family: 'Poppins', sans-serif;
                font-size: 10px;
                color: #6c757d;
                background-color: #f8f9fa;
                border-top: 1px solid #dee2e6;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 10px 24px;
                width: 100%;
            }
            .footer-col {
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: center;
                min-width: 0;
                text-align: center;
            }
            .footer-logo {
                height: 36px;
                max-width: 110px;
                object-fit: contain;
                margin-right: 8px;
            }
            .footer a {
                color: #007bff;
                text-decoration: none;
                word-break: break-all;
            }
            .footer a:hover {
                text-decoration: underline;
            }
            .footer-bar {
                height: 12px;
                background-color: #001f3f;
                width: 100%;
            }
            @media print {
                .footer-wrapper {
                    position: fixed !important;
                    bottom: 0 !important;
                    left: 0 !important;
                    right: 0 !important;
                }
                .footer {
                    background-color: #f8f9fa !important;
                    color: #6c757d !important;
                    -webkit-print-color-adjust: exact !important;
                    print-color-adjust: exact !important;
                }
                .footer a {
                    color: #007bff !important;
                }
                .footer-bar {
                    background-color: #001f3f !important;
                    -webkit-print-color-adjust: exact !important;
                    print-color-adjust: exact !important;
                    height: 12px !important;
                }
            }
        </style>
        <div class="footer-wrapper">
            <div class="footer">
                <div class="footer-col" style="justify-content: flex-start;">
                    ${account?.logo_image_base64 ? `<img src="${account.logo_image_base64}" alt="Logo" class="footer-logo">` : ''}
                </div>
                <div class="footer-col" style="flex:2; flex-direction:column; align-items:center; justify-content:center;">
                    ${account?.name ? `<div><strong>${account.name}</strong></div>` : ''}
                    ${account?.website ? `<div><a href="${account.website}" target="_blank">${account.website}</a></div>` : ''}
                </div>
                <div class="footer-col" style="justify-content: flex-end; flex-direction:column; align-items:flex-end;">
                    ${account?.phone ? `<div>Tel: ${account.phone}${account.phone2 ? ' / ' + account.phone2 : ''}</div>` : ''}
                    ${account?.mail ? `<div>Email: <a href="mailto:${account.mail}">${account.mail}</a></div>` : ''}
                </div>
            </div>
            <div class="footer-bar"></div>
        </div>
        `;
    // --- DEBUG: Log HTML content before sending ---
    console.log(`[${hotelId}] Generated index.html content:\n`, htmlContent);
    // console.log(`[${hotelId}] Generated footer.html content:\n`, footerHtmlContent); // Optional: Keep or remove
    // --- END DEBUG ---
    // --- Preparar y Llamar a Gotenberg ---
    const formData = new FormData();
    formData.append('files', new Blob([
      htmlContent
    ], {
      type: 'text/html'
    }), 'index.html');
    formData.append('files', new Blob([
      footerHtmlContent
    ], {
      type: 'text/html'
    }), 'footer.html');
    formData.append('paperWidth', '8.27');
    formData.append('paperHeight', '11.69');
    formData.append('printBackground', 'true');
    formData.append('marginTop', '0');
    formData.append('marginBottom', '0'); // <--- margen inferior en 0
    formData.append('marginLeft', '0');
    formData.append('marginRight', '0');
    formData.append('footerFilename', 'footer.html'); // Tell Gotenberg to use this file as the footer
    console.log(`[${hotelId}] Sending HTML and Footer to Gotenberg: ${GOTENBERG_URL}`);
    let gotenbergResponse;
    try {
      gotenbergResponse = await fetch(GOTENBERG_URL, {
        method: 'POST',
        body: formData
      });
    } catch (fetchError) {
      console.error(`[${hotelId}] Fetch Error:`, fetchError);
      return new Response(JSON.stringify({
        error: 'Error al conectar con el servicio de generación de PDF',
        details: fetchError.message
      }), {
        status: 502,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    console.log(`[${hotelId}] Gotenberg response status: ${gotenbergResponse.status}`);
    if (!gotenbergResponse.ok) {
      const errorBody = await gotenbergResponse.text();
      console.error(`[${hotelId}] Gotenberg Error ${gotenbergResponse.status}:`, errorBody);
      return new Response(JSON.stringify({
        error: 'Error al generar el PDF con el servicio externo',
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
    // --- Procesar Respuesta de Gotenberg y Subir a Storage ---
    const pdfBlob = await gotenbergResponse.blob();
    console.log(`[${hotelId}] PDF received, size: ${pdfBlob.size} bytes. Uploading...`);
    const safeHotelName = hotel.name?.replace(/[^a-zA-Z0-9_.-]/g, '_') || 'hotel';
    const timestamp = Date.now();
    const pdfPath = `hotel_pdfs/${hotelId}/${safeHotelName}_${timestamp}.pdf`;
    const { data: storageData, error: storageError } = await supabaseClient.storage.from(STORAGE_BUCKET_NAME).upload(pdfPath, pdfBlob, {
      contentType: 'application/pdf',
      cacheControl: '3600',
      upsert: false
    });
    if (storageError) {
      console.error(`[${hotelId}] Storage Upload Error:`, storageError);
      return new Response(JSON.stringify({
        error: 'PDF generado pero falló al guardarlo',
        details: storageError.message
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // --- Obtener URL Pública y Devolver Respuesta Final ---
    const { data: publicUrlData } = supabaseClient.storage.from(STORAGE_BUCKET_NAME).getPublicUrl(pdfPath);
    const publicUrl = publicUrlData?.publicUrl || '';
    console.log(`[${hotelId}] PDF successfully uploaded to: ${pdfPath}. Public URL: ${publicUrl || 'N/A'}`);
    const successResponse = {
      message: "PDF generado y guardado exitosamente.",
      hotelId: hotelId,
      hotelName: hotel.name,
      publicUrl: publicUrl,
      path: pdfPath
    };
    return new Response(JSON.stringify(successResponse), {
      status: 200,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  } catch (error) {
    // --- Manejo de Errores General ---
    console.error(`[${hotelId || 'N/A'}] Unhandled Exception in Edge Function:`, error);
    const errorMessage = error instanceof Error ? error.message : 'Error desconocido';
    return new Response(JSON.stringify({
      error: 'Error interno del servidor',
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
