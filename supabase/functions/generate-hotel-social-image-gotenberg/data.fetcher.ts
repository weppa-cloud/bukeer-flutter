// data.fetcher.ts
/**
 * Obtiene los datos del hotel desde Supabase
 * @param hotelId ID del hotel
 * @param supabaseClient Cliente de Supabase
 * @returns Datos del hotel o null si no existe
 */ export async function fetchHotelData(hotelId, supabaseClient) {
  try {
    const { data, error } = await supabaseClient.from("hotels").select("*").eq("id", hotelId).single();
    if (error) {
      console.error("Error fetching hotel data:", error);
      return null;
    }
    return data;
  } catch (e) {
    console.error(`Error al consultar hotel ${hotelId}:`, e);
    return null;
  }
}
/**
 * Obtiene los datos de la cuenta asociada al hotel
 * @param accountId ID de la cuenta
 * @param supabaseClient Cliente de Supabase
 * @returns Datos de la cuenta o null si no existe
 */ export async function fetchAccountData(accountId, supabaseClient) {
  if (!accountId) return null;
  try {
    const { data, error } = await supabaseClient.from("accounts").select("*").eq("id", accountId).single();
    if (error) {
      console.error("Error fetching account data:", error);
      return null;
    }
    return data;
  } catch (e) {
    console.error(`Error al consultar cuenta ${accountId}:`, e);
    return null;
  }
}
/**
 * Obtiene los datos de ubicación del hotel
 * @param locationId ID de la ubicación
 * @param supabaseClient Cliente de Supabase
 * @returns Datos de la ubicación o null si no existe
 */ export async function fetchLocationData(locationId, supabaseClient) {
  if (!locationId) return null;
  try {
    const { data, error } = await supabaseClient.from("locations").select("*").eq("id", locationId).single();
    if (error) {
      console.error("Error fetching location data:", error);
      return null;
    }
    return data;
  } catch (e) {
    console.error(`Error al consultar ubicación ${locationId}:`, e);
    return null;
  }
}
/**
 * Obtiene las imágenes de la galería del hotel
 * @param hotelId ID del hotel
 * @param mainImageUrl URL de la imagen principal para filtrarla de la galería
 * @param supabaseClient Cliente de Supabase
 * @returns Array de imágenes de la galería
 */ export async function fetchGalleryImages(hotelId, mainImageUrl, supabaseClient) {
  try {
    const { data, error } = await supabaseClient.from("hotels_images").select("url").eq("hotel_id", hotelId).order("position", {
      ascending: true
    }).limit(3);
    if (error) {
      console.error("Error fetching hotel gallery images:", error);
      return [];
    }
    if (!data || data.length === 0) {
      console.log(`No gallery images found for hotel ID ${hotelId}`);
      return mainImageUrl ? [
        {
          url: mainImageUrl
        }
      ] : [];
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
  } catch (e) {
    console.error(`Error al consultar imágenes de galería para hotel ${hotelId}:`, e);
    return mainImageUrl ? [
      {
        url: mainImageUrl
      }
    ] : [];
  }
}
