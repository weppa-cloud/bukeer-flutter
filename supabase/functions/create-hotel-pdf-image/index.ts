// supabase/functions/create-hotel-pdf-image/index.ts
// Esta función genera una imagen de un hotel usando la misma plantilla HTML del PDF y Gotenberg para la renderización
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.7';
import { corsHeaders } from '../_shared/cors.ts';
import { fetchHotelData, fetchAccountData, fetchGalleryImages, fetchLocationData } from './data.fetcher.ts';
import { generateHotelPdfTemplate } from './template.generator.ts';
// --- Constantes ---
// URL de Gotenberg para captura de pantalla HTML
const GOTENBERG_URL = 'https://demo.gotenberg.dev/forms/chromium/screenshot/html'; // ¡USA TU PROPIA INSTANCIA EN PRODUCCIÓN!
let STORAGE_BUCKET_NAME = 'social-images'; // Bucket que ya existe en Supabase Storage
const DEBUG = true; // Establecer a true para mostrar HTML en respuesta en caso de error (establecer a false en producción)
const IMAGE_FORMAT = 'png'; // Cambiado de 'jpeg' a 'png' para mayor calidad (sin compresión con pérdida)
const IMAGE_QUALITY = 100; // Solo aplicable para jpeg y webp (1-100). 100 es máxima calidad
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
  let htmlContent = '';
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
    // --- Generar HTML usando la misma plantilla del PDF --- 
    console.log(`[${hotelId}] Generating HTML template...`);
    const htmlContent = generateHotelPdfTemplate(templateData);
    // --- DEBUG: Log HTML content before sending ---
    console.log(`[${hotelId}] HTML template generated (${htmlContent.length} characters)`);
    // --- Preparar y Llamar a Gotenberg para HTML a Imagen ---
    const formData = new FormData();
    // Agregar el archivo HTML - este es el requisito principal
    formData.append('files', new Blob([
      htmlContent
    ], {
      type: 'text/html'
    }), 'index.html');
    // Parámetros específicos de screenshot según documentación de Gotenberg
    formData.append('format', IMAGE_FORMAT); // 'jpeg', 'png', or 'webp'
    formData.append('quality', IMAGE_QUALITY.toString()); // 1-100 para JPEG y WebP
    formData.append('width', '816'); // Ancho de imagen (coincide con ancho máximo del contenedor en el HTML)
    // Usar altura fija exactamente igual al page-container para asegurar que todo quede en una página
    formData.append('height', '1056'); // Alto de imagen que debe coincidir con .page-container height (Letter size)
    // Optimización de velocidad
    formData.append('optimizeForSpeed', 'false'); // Cambiado a false para priorizar calidad
    // Esperar a que se carguen los recursos - importante para una captura precisa
    formData.append('waitDelay', '6s'); // Aumentado a 6 segundos para mejor carga
    formData.append('waitForExpression', 'window.imagesLoaded === true'); // Esperar a nuestra bandera personalizada
    // El evento de inactividad de red puede ayudar con la carga de contenido dinámico
    formData.append('skipNetworkIdleEvent', 'false');
    // Aumentar escala a 2.0 para mejor resolución y nitidez
    formData.append('scale', '2.0');
    // Configuraciones adicionales para mayor calidad
    formData.append('emulatedMediaType', 'print'); // Mejor para documentos
    formData.append('printBackground', 'true'); // Incluir fondos en la captura
    // Establecer DPI más alto para mejor calidad
    formData.append('paperWidth', '8.5'); // Pulgadas
    formData.append('paperHeight', '11'); // Pulgadas
    // Establecer User-Agent para mejor compatibilidad
    formData.append('extraHttpHeaders', JSON.stringify({
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
    }));
    console.log(`[${hotelId}] Sending HTML to Gotenberg for image generation: ${GOTENBERG_URL}`);
    let gotenbergResponse;
    try {
      gotenbergResponse = await fetch(GOTENBERG_URL, {
        method: 'POST',
        body: formData
      });
    } catch (fetchError) {
      console.error(`[${hotelId}] Fetch Error:`, fetchError);
      // Devolver error detallado si está en modo debug
      if (DEBUG) {
        return new Response(JSON.stringify({
          error: 'Error al conectar con el servicio de generación de imagen',
          details: fetchError.message,
          html: htmlContent.substring(0, 1000) + "... [truncado]"
        }), {
          status: 502,
          headers: {
            ...corsHeaders,
            'Content-Type': 'application/json'
          }
        });
      }
      return new Response(JSON.stringify({
        error: 'Error al conectar con el servicio de generación de imagen',
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
      // Devolver error detallado si está en modo debug
      if (DEBUG) {
        return new Response(JSON.stringify({
          error: 'Error al generar la imagen con el servicio externo',
          details: `Gotenberg Status ${gotenbergResponse.status}`,
          gotenberg_error: errorBody,
          html: htmlContent.substring(0, 1000) + "... [truncado]"
        }), {
          status: 502,
          headers: {
            ...corsHeaders,
            'Content-Type': 'application/json'
          }
        });
      }
      return new Response(JSON.stringify({
        error: 'Error al generar la imagen con el servicio externo',
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
    const imageBuffer = await gotenbergResponse.arrayBuffer();
    console.log(`[${hotelId}] Image received, size: ${imageBuffer.byteLength} bytes. Uploading...`);
    if (imageBuffer.byteLength === 0) {
      console.warn(`[${hotelId}] La generación de la imagen devolvió un buffer vacío.`);
      // Devolver error detallado si está en modo debug
      if (DEBUG) {
        return new Response(JSON.stringify({
          error: 'La generación de la imagen falló (buffer vacío)',
          html: htmlContent.substring(0, 1000) + "... [truncado]"
        }), {
          status: 500,
          headers: {
            ...corsHeaders,
            'Content-Type': 'application/json'
          }
        });
      }
      return new Response(JSON.stringify({
        error: 'La generación de la imagen falló (buffer vacío)'
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // --- Subir Imagen a Storage ---
    const safeHotelName = hotel.name?.replace(/[^a-zA-Z0-9_.-]/g, '_') || 'hotel';
    const timestamp = Date.now();
    const imagePath = `hotel_pdf_images/${hotelId}/${safeHotelName}_${timestamp}.${IMAGE_FORMAT}`;
    const contentType = `image/${IMAGE_FORMAT}`;
    // Intentar asegurarse de que el bucket existe (ignorar errores si ya existe)
    try {
      // Verificar si tenemos permiso para acceder al bucket
      const { data: bucketExists } = await supabaseClient.storage.getBucket(STORAGE_BUCKET_NAME);
      if (!bucketExists) {
        console.log(`[${hotelId}] Bucket ${STORAGE_BUCKET_NAME} no encontrado, intentando usar 'pdfs'...`);
      // Si no existe o no tenemos acceso, intentar con otro bucket
      }
    } catch (bucketErr) {
      console.warn(`[${hotelId}] Error al verificar bucket ${STORAGE_BUCKET_NAME}:`, bucketErr);
    // Continuar de todos modos, tal vez tengamos permisos de escritura
    }
    // Intentar subir primero al bucket configurado
    let { data: storageData, error: storageError } = await supabaseClient.storage.from(STORAGE_BUCKET_NAME).upload(imagePath, imageBuffer, {
      contentType,
      cacheControl: '3600',
      upsert: false
    });
    // Si hay error, intentar con bucket alternativo 'pdfs'
    if (storageError && (storageError.message === 'Bucket not found' || storageError.error === 'Bucket not found')) {
      console.log(`[${hotelId}] Intentando subir a bucket alternativo 'pdfs'...`);
      try {
        const altResult = await supabaseClient.storage.from('pdfs').upload(imagePath, imageBuffer, {
          contentType,
          cacheControl: '3600',
          upsert: false
        });
        storageData = altResult.data;
        storageError = altResult.error;
        if (!altResult.error) {
          console.log(`[${hotelId}] Éxito al subir a bucket alternativo 'pdfs'`);
          STORAGE_BUCKET_NAME = 'pdfs';
        }
      } catch (altError) {
        console.error(`[${hotelId}] También falló el intento con bucket alternativo:`, altError);
      }
    }
    if (storageError) {
      console.error(`[${hotelId}] Storage Upload Error:`, storageError);
      // Mensaje específico cuando el problema es que no existe ningún bucket disponible
      if (storageError.message === 'Bucket not found' || storageError.error === 'Bucket not found') {
        return new Response(JSON.stringify({
          error: 'No se pudo guardar la imagen: no existe el bucket de storage',
          details: `El bucket '${STORAGE_BUCKET_NAME}' no existe. Por favor crea el bucket '${STORAGE_BUCKET_NAME}' o 'pdfs' en Supabase Storage.`,
          solution: "Crea un bucket en Supabase Storage Management con nombre 'social-images' o 'pdfs'."
        }), {
          status: 500,
          headers: {
            ...corsHeaders,
            'Content-Type': 'application/json'
          }
        });
      }
      return new Response(JSON.stringify({
        error: 'Imagen generada pero falló al guardarla',
        details: storageError.message || storageError.error || JSON.stringify(storageError)
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // --- Obtener URL Pública ---
    const { data: publicUrlData } = supabaseClient.storage.from(STORAGE_BUCKET_NAME).getPublicUrl(imagePath);
    const publicUrl = publicUrlData?.publicUrl || '';
    console.log(`[${hotelId}] Image successfully uploaded to: ${imagePath}. Public URL: ${publicUrl || 'N/A'}`);
    // --- Actualizar campo en la tabla hotels ---
    let databaseUpdated = false;
    if (publicUrl) {
      console.log(`[${hotelId}] Updating pdf_image field in hotels table...`);
      const { data: updateData, error: updateError } = await supabaseClient.from('hotels').update({
        pdf_image: publicUrl
      }).eq('id', hotelId);
      if (updateError) {
        console.error(`[${hotelId}] Error al actualizar pdf_image en la base de datos:`, updateError);
      } else {
        console.log(`[${hotelId}] Campo pdf_image actualizado correctamente en la base de datos`);
        databaseUpdated = true;
      }
    }
    const successResponse = {
      message: "Imagen del hotel generada y guardada exitosamente.",
      hotelId: hotelId,
      hotelName: hotel.name,
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
    // --- Manejo de Errores General ---
    console.error(`[${hotelId || 'N/A'}] Unhandled Exception in Edge Function:`, error);
    const errorMessage = error instanceof Error ? error.message : 'Error desconocido';
    // Devolver error detallado si está en modo debug
    if (DEBUG && htmlContent) {
      return new Response(JSON.stringify({
        error: 'Error interno del servidor',
        details: errorMessage,
        html: htmlContent.substring(0, 1000) + "... [truncado]"
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
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
