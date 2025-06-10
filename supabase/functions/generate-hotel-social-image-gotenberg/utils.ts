// utils.ts
/**
 * Optimiza una URL de imagen a través del servicio de transformación de imágenes
 * @param originalUrl URL original de la imagen
 * @param width Ancho deseado para la imagen optimizada
 * @param quality Calidad deseada (1-100)
 * @returns URL optimizada
 */ export function getOptimizedImageUrl(originalUrl, width = 800, quality = 80) {
  // Si la URL no viene de WordPress o no tiene una estructura conocida, devolver la URL original
  if (!originalUrl || !originalUrl.includes('wp-content')) {
    return originalUrl;
  }
  try {
    // Verificar que la URL esté bien formada
    new URL(originalUrl);
    // Construir URL optimizada con WordPress transformaciones
    if (originalUrl.includes('.webp') || originalUrl.includes('.jpg') || originalUrl.includes('.jpeg') || originalUrl.includes('.png')) {
      // Extraer nombre de archivo
      const lastSlashIndex = originalUrl.lastIndexOf('/');
      const fileName = originalUrl.substring(lastSlashIndex + 1);
      // Separar nombre de archivo de extensión
      let baseFileName, extension;
      if (fileName.includes('.')) {
        const lastDotIndex = fileName.lastIndexOf('.');
        baseFileName = fileName.substring(0, lastDotIndex);
        extension = fileName.substring(lastDotIndex + 1);
      } else {
        // Si no hay extensión, usar la URL completa
        return originalUrl;
      }
      // Construir URL optimizada
      return `${originalUrl.substring(0, lastSlashIndex + 1)}${baseFileName}-${width}x0.${extension}`;
    }
  } catch (e) {
    console.warn('Error al procesar URL para optimización:', e);
  }
  // Si algo falla, devolver URL original
  return originalUrl;
}
/**
 * Escapa caracteres especiales de HTML
 * @param unsafe String posiblemente inseguro
 * @returns String escapado seguro para HTML
 */ export function escapeHtml(unsafe) {
  if (unsafe === null || unsafe === undefined) {
    return '';
  }
  return unsafe.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;");
}
