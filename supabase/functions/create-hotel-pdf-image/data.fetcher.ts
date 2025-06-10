// supabase/functions/generate-hotel-pdf/data.fetcher.ts
export async function fetchHotelData(hotelId, supabaseClient) {
  console.log(`Fetching hotel data for ID: ${hotelId}`);
  const { data, error } = await supabaseClient.from('hotels').select('*').eq('id', hotelId).single();
  if (error) {
    console.error(`[${hotelId}] Error fetching hotel data:`, error.message);
    if (error.code === 'PGRST116') {
      console.warn(`Hotel with ID ${hotelId} not found`);
      return null; // Not found es esperado
    }
    throw error; // Re-lanzar otros errores
  }
  if (!data) {
    console.warn(`No data returned for hotel ID ${hotelId}`);
    return null;
  }
  console.log(`Successfully fetched hotel: ${data.name}, Account ID: ${data.account_id}`);
  return data;
}
export async function fetchAccountData(accountId, supabaseClient) {
  if (!accountId) {
    console.warn('No account ID provided for fetchAccountData');
    return null;
  }
  console.log(`Fetching account data for ID: ${accountId}`);
  const { data, error } = await supabaseClient.from('accounts').select('id, name, logo_image, phone, phone2, mail, website, currency, location').eq('id', accountId).single();
  if (error) {
    console.error(`Error fetching account data for ${accountId}:`, error.message);
    // Log más detallado para ayudar a diagnosticar
    if (error.code === 'PGRST116') {
      console.warn(`Account with ID ${accountId} not found`);
    } else {
      console.error(`Database error (${error.code}): ${error.message}`, error);
    }
    return null;
  }
  if (!data) {
    console.warn(`No data returned for account ID ${accountId}`);
    return null;
  }
  // Si el account tiene location, obtener su dirección para uso en el PDF
  if (data.location) {
    try {
      const { data: locationData, error: locationError } = await supabaseClient.from('locations').select('address').eq('id', data.location).single();
      if (!locationError && locationData) {
        data.address = locationData.address;
      }
    } catch (e) {
      console.warn(`Could not fetch location for account ${accountId}:`, e);
    }
  }
  // Descargar y convertir el logo a base64 si existe
  let logo_image_base64 = null;
  if (data.logo_image) {
    try {
      const response = await fetch(data.logo_image);
      if (response.ok) {
        const contentType = response.headers.get('content-type') || 'image/png';
        const arrayBuffer = await response.arrayBuffer();
        const base64 = btoa(String.fromCharCode(...new Uint8Array(arrayBuffer)));
        logo_image_base64 = `data:${contentType};base64,${base64}`;
      } else {
        console.warn(`No se pudo descargar el logo (${data.logo_image}): status ${response.status}`);
      }
    } catch (e) {
      console.warn(`Error al descargar o convertir el logo a base64:`, e);
    }
  }
  console.log(`Successfully fetched account: ${data.name}, Logo: ${data.logo_image ? 'YES' : 'NO'}`);
  return {
    ...data,
    logo_image_base64
  };
}
export async function fetchGalleryImages(hotelId, mainImageUrl, supabaseClient) {
  console.log(`Fetching gallery images for hotel ID: ${hotelId}`);
  const { data, error } = await supabaseClient.from('images').select('url').eq('entity_id', hotelId).order('created_at', {
    ascending: false
  }) // Más recientes primero
  .limit(4); // Limitar a 4 imágenes
  if (error) {
    console.error(`[${hotelId}] Error fetching images:`, error.message);
    return [];
  }
  if (!data || data.length === 0) {
    console.warn(`No gallery images found for hotel ID ${hotelId}`);
    // Si no hay imágenes pero hay una imagen principal, usarla como imagen de galería
    if (mainImageUrl) {
      return [
        {
          url: mainImageUrl
        }
      ];
    }
    return [];
  }
  // Filtrar la imagen principal si está en la galería para evitar duplicados
  const filteredImages = mainImageUrl ? data.filter((img)=>img.url !== mainImageUrl) : data;
  console.log(`Found ${filteredImages.length} gallery images for hotel ID ${hotelId}`);
  // Si después de filtrar no quedan imágenes pero hay imagen principal, usarla
  if (filteredImages.length === 0 && mainImageUrl) {
    return [
      {
        url: mainImageUrl
      }
    ];
  }
  return filteredImages;
}
export async function fetchLocationData(locationId, supabaseClient) {
  if (!locationId) {
    console.warn('No location ID provided for fetchLocationData');
    return null;
  }
  console.log(`Fetching location data for ID: ${locationId}`);
  const { data, error } = await supabaseClient.from('locations').select('id, city, country, address, state').eq('id', locationId).single();
  if (error) {
    console.error(`Error fetching location data for ${locationId}:`, error.message);
    if (error.code === 'PGRST116') {
      console.warn(`Location with ID ${locationId} not found`);
    }
    return null;
  }
  if (!data) {
    console.warn(`No data returned for location ID ${locationId}`);
    return null;
  }
  console.log(`Successfully fetched location: ${data.city}, ${data.country}`);
  return data;
}
// Función auxiliar para obtener información adicional del hotel
export async function fetchAdditionalHotelInfo(hotelId, supabaseClient) {
  console.log(`Fetching additional hotel information for ID: ${hotelId}`);
  try {
    // Ejemplo: obtener reseñas, servicios adicionales, etc.
    // Esta función se puede ampliar según necesidades
    return {};
  } catch (error) {
    console.warn(`Error fetching additional hotel info: ${error}`);
    return {};
  }
}
