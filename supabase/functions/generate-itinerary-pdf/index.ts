// supabase/functions/generate-itinerary-pdf/index.ts
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { fetchItineraryData } from './data.fetcher.ts';
import { generateItineraryPdfTemplate } from './template.generator.ts';
// CORS headers for cross-origin requests
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, GET, OPTIONS'
};
// Configuración
const GOTENBERG_URL = 'https://demo.gotenberg.dev/forms/chromium/convert/html'; // Reemplazar con tu URL de Gotenberg
const STORAGE_BUCKET_NAME = 'pdfs'; // Nombre del bucket en Supabase Storage
serve(async (req)=>{
  // Manejo de solicitudes OPTIONS (CORS preflight)
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: corsHeaders
    });
  }
  // Variables para el proceso
  let supabaseClient;
  let itineraryId = null;
  let accountId = null;
  try {
    // Inicializar cliente Supabase
    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
    if (!supabaseUrl || !serviceRoleKey) {
      throw new Error('SUPABASE_URL y SUPABASE_SERVICE_ROLE_KEY son requeridas.');
    }
    supabaseClient = createClient(supabaseUrl, serviceRoleKey);
    // Obtener parámetros de la solicitud (POST o GET)
    if (req.method === 'POST') {
      try {
        // Verificar que Content-Type sea application/json
        if (!req.headers.get('content-type')?.includes('application/json')) {
          return new Response(JSON.stringify({
            error: 'Se esperaba Content-Type: application/json'
          }), {
            status: 415,
            headers: {
              ...corsHeaders,
              'Content-Type': 'application/json'
            }
          });
        }
        // Obtener y validar parámetros del body
        const body = await req.json();
        itineraryId = body.itineraryId;
        accountId = body.accountId;
      } catch (e) {
        console.error('Error al parsear el body JSON:', e);
        return new Response(JSON.stringify({
          error: 'Body JSON inválido',
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
      // Obtener parámetros de la URL
      const url = new URL(req.url);
      itineraryId = url.searchParams.get('itineraryId');
      accountId = url.searchParams.get('accountId');
    } else {
      return new Response(JSON.stringify({
        error: `Método ${req.method} no soportado`
      }), {
        status: 405,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
          'Allow': 'POST, GET, OPTIONS'
        }
      });
    }
    // Validar itineraryId (requerido)
    if (!itineraryId) {
      return new Response(JSON.stringify({
        error: 'El parámetro itineraryId es requerido'
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // Validar formato UUID
    if (!/^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/.test(itineraryId)) {
      return new Response(JSON.stringify({
        error: 'Formato de itineraryId inválido (se esperaba UUID)'
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // Log de inicio del proceso
    console.log(`[${itineraryId}] Iniciando generación de PDF...`);
    // Obtener datos del itinerario
    console.log(`[${itineraryId}] Obteniendo datos del itinerario...`);
    const itineraryData = await fetchItineraryData(itineraryId, accountId, supabaseClient);
    if (!itineraryData) {
      return new Response(JSON.stringify({
        error: `No se encontraron datos para el itinerario ${itineraryId}`
      }), {
        status: 404,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // Log de datos obtenidos
    console.log(`[${itineraryId}] Datos obtenidos - Itinerario: ${itineraryData.itinerary.name}`);
    console.log(`[${itineraryId}] Datos obtenidos - Cliente: ${itineraryData.contact.name} ${itineraryData.contact.lastname}`);
    console.log(`[${itineraryId}] Datos obtenidos - Items: ${itineraryData.items.length} elementos`);
    // Generar HTML para el PDF
    console.log(`[${itineraryId}] Generando HTML...`);
    const htmlContent = generateItineraryPdfTemplate(itineraryData);
    // Generar contenido del footer
    const footerHtmlContent = generateFooterHtml(itineraryData.account);
    // Log de HTML generado (para depuración)
    // console.log(`[${itineraryId}] HTML generado:`, htmlContent.substring(0, 200) + '...');
    // Preparar datos para enviar a Gotenberg
    console.log(`[${itineraryId}] Preparando solicitud a Gotenberg...`);
    const formData = new FormData();
    // Agregar archivos HTML
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
    // Configurar opciones de Gotenberg
    formData.append('paperWidth', '8.27'); // A4
    formData.append('paperHeight', '11.69'); // A4
    formData.append('marginTop', '0.4'); // Valores en pulgadas, no en píxeles
    formData.append('marginBottom', '1.2'); // Valores en pulgadas
    formData.append('marginLeft', '0');
    formData.append('marginRight', '0');
    formData.append('printBackground', 'true');
    formData.append('preferCssPageSize', 'false');
    formData.append('waitForFunction', 'document.fonts.ready');
    formData.append('footerFilename', 'footer.html');
    formData.append('footerHeight', '30mm'); // Usar unidades que Gotenberg entiende (mm)
    formData.append('waitDelay', '1s');
    // Enviar a Gotenberg
    console.log(`[${itineraryId}] Enviando a Gotenberg: ${GOTENBERG_URL}`);
    let gotenbergResponse;
    try {
      gotenbergResponse = await fetch(GOTENBERG_URL, {
        method: 'POST',
        body: formData
      });
    } catch (fetchError) {
      console.error(`[${itineraryId}] Error al conectar con Gotenberg:`, fetchError);
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
    // Verificar respuesta de Gotenberg
    console.log(`[${itineraryId}] Respuesta de Gotenberg: ${gotenbergResponse.status}`);
    if (!gotenbergResponse.ok) {
      const errorBody = await gotenbergResponse.text();
      console.error(`[${itineraryId}] Error de Gotenberg ${gotenbergResponse.status}:`, errorBody);
      return new Response(JSON.stringify({
        error: 'Error al generar el PDF',
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
    // Procesar respuesta y guardar PDF
    const pdfBlob = await gotenbergResponse.blob();
    console.log(`[${itineraryId}] PDF recibido, tamaño: ${formatBytes(pdfBlob.size)}. Subiendo...`);
    // Generar nombre de archivo seguro
    const safeItineraryName = itineraryData.itinerary.name?.replace(/[^a-zA-Z0-9_.-]/g, '_').substring(0, 50) || 'itinerario';
    const timestamp = Date.now();
    const pdfPath = `itineraries/${accountId || 'default'}/${itineraryId}/${safeItineraryName}_${timestamp}.pdf`;
    // Subir a Supabase Storage
    const { data: storageData, error: storageError } = await supabaseClient.storage.from(STORAGE_BUCKET_NAME).upload(pdfPath, pdfBlob, {
      contentType: 'application/pdf',
      cacheControl: '3600',
      upsert: false
    });
    if (storageError) {
      console.error(`[${itineraryId}] Error al subir a Storage:`, storageError);
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
    // Obtener URL pública
    const { data: publicUrlData } = supabaseClient.storage.from(STORAGE_BUCKET_NAME).getPublicUrl(pdfPath);
    const publicUrl = publicUrlData?.publicUrl || '';
    console.log(`[${itineraryId}] PDF subido exitosamente a: ${pdfPath}`);
    console.log(`[${itineraryId}] URL pública: ${publicUrl}`);
    // Respuesta exitosa
    const successResponse = {
      message: "PDF generado y guardado exitosamente",
      itineraryId: itineraryId,
      itineraryName: itineraryData.itinerary.name,
      publicUrl: publicUrl,
      path: pdfPath,
      size: pdfBlob.size
    };
    return new Response(JSON.stringify(successResponse), {
      status: 200,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  } catch (error) {
    // Manejo global de errores
    console.error(`[${itineraryId || 'unknown'}] Error no controlado:`, error);
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
// Función para generar HTML del footer
function generateFooterHtml(account) {
  return `
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
        font-family: 'Poppins', sans-serif;
      }
      .footer-wrapper {
        width: 100%;
        position: relative;
      }
      .footer {
        font-size: 10px; /* Incrementado de 9px a 10px */
        color: #555;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 8px 30px 6px; /* Incrementado */
        border-top: 1px solid #eee;
      }
      .footer-col {
        display: flex;
        align-items: center;
      }
      .footer-logo {
        height: 35px; /* Incrementado de 30px a 35px */
        max-width: 110px; /* Incrementado */
        object-fit: contain;
        margin-right: 15px;
      }
      .footer-text {
        text-align: center;
        font-weight: 500; /* Añadido */
      }
      .footer-bar {
        height: 10px; /* Incrementado de 8px a 10px */
        background-color: rgb(32, 76, 167);
        width: 100%;
      }
      @media print {
        .footer-wrapper {
          width: 100% !important;
          position: fixed !important; /* Asegurar que siempre esté visible */
          bottom: 0 !important;
          left: 0 !important;
        }
        .footer-bar {
          background-color: rgb(32, 76, 167) !important;
          -webkit-print-color-adjust: exact !important;
          print-color-adjust: exact !important;
        }
      }
    </style>
    <div class="footer-wrapper">
      <div class="footer">
        <div class="footer-col">
          ${account?.logo_image_base64 ? `<img src="${account.logo_image_base64}" alt="Logo" class="footer-logo">` : ''}
          <div>
            ${account?.type_id && account?.number_id ? `${account.type_id}: ${account.number_id}` : ''}
          </div>
        </div>
        
        <div class="footer-text">
          ${account?.name ? account.name : ''}
        </div>
        
        <div class="footer-col" style="text-align: right;">
          ${account?.phone ? `Tel: ${account.phone}` : ''}
          ${account?.mail ? ` • Email: ${account.mail}` : ''}
        </div>
      </div>
      <div class="footer-bar"></div>
    </div>
  `;
}
// Utilidad para formatear tamaño en bytes
function formatBytes(bytes, decimals = 2) {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const dm = decimals < 0 ? 0 : decimals;
  const sizes = [
    'Bytes',
    'KB',
    'MB',
    'GB',
    'TB'
  ];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
}
