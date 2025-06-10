// supabase/functions/generate-activity-social-image-gotenberg/template.generator.ts
import { escapeHtml, getOptimizedImageUrl } from './utils.ts';
// Define dimensiones fijas para la imagen social
const width = 800;
const height = 800;
export function generateActivitySocialImageHtml(data) {
  const { activity, location, galleryImages = [] } = data;
  if (!activity) {
    console.error("Error: No se proporcionaron datos de actividad");
    throw new Error("Se requieren datos de actividad");
  }
  // Formatear nombre de ubicación
  let locationName = "";
  if (location) {
    const city = location.city?.trim() || "";
    const country = location.country?.trim() || "";
    if (city) {
      locationName = city;
      if (country) {
        locationName += `, ${country}`;
      }
    } else if (country && !(country.length === 2 && country === country.toUpperCase())) {
      locationName = country;
    }
  }
  // Obtener URL de imagen principal con respaldo
  const mainImageUrl = activity.main_image ? getOptimizedImageUrl(activity.main_image, 1200, 80) : "https://via.placeholder.com/800x600.png?text=Main+Image+Missing";
  // Filtrar imágenes de galería válidas y limitar a 3
  const filteredGalleryImages = Array.isArray(galleryImages) ? galleryImages.slice(0, 3).filter((img)=>img && img.url) : [];
  const hasGallery = filteredGalleryImages.length > 0;
  const activityName = escapeHtml(activity.name || "Nombre de Actividad Faltante");
  // Determinar tamaño de fuente según longitud del texto - AUMENTADO
  let fontSize = 58; // Aumentado de 50 a 58
  if (activityName.length > 35) {
    fontSize = 42; // Aumentado de 36 a 42
  } else if (activityName.length > 25) {
    fontSize = 48; // Aumentado de 42 a 48
  }
  // Color de fondo para la sección de galería
  const bgColor = "#10352B"; // Verde oscuro elegante
  // Construir galería de imágenes en HTML si existe
  let galleryHtml = '';
  if (hasGallery) {
    const galleryItems = filteredGalleryImages.map((image)=>`<div style="border-radius: 8px; overflow: hidden; border: 1px solid rgba(255,255,255,0.15); height: 200px; flex: 1; max-width: ${Math.floor((width - 40 - 20) / 3)}px;">
         <img src="${getOptimizedImageUrl(image.url, 400, 70)}" alt="Imagen de galería" 
              style="width: 100%; height: 100%; object-fit: cover;"
              onload="this.dataset.loaded='true'" 
              onerror="this.src='https://via.placeholder.com/400x300.png?text=Error'; this.dataset.loaded='true'">
       </div>`).join('');
    galleryHtml = `
      <div style="flex: 0.3; display: flex; justify-content: center; align-items: center; padding: 20px; background-color: ${bgColor};">
        <div style="display: flex; gap: 10px; justify-content: center; width: 100%;">
          ${galleryItems}
        </div>
      </div>
    `;
  }
  return `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>Imagen Social: ${escapeHtml(activity.name || "")}</title>
      <!-- Google Fonts: Lato (Light Italic) y Shadows Into Light -->
      <link rel="preconnect" href="https://fonts.googleapis.com">
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
      <link href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@1,300&family=Shadows+Into+Light&display=swap" rel="stylesheet">
      <style>
        body {
          margin: 0;
          padding: 0;
          width: ${width}px;
          height: ${height}px;
          overflow: hidden;
          color: #FFFFFF;
          font-family: Arial, sans-serif;
          background-color: ${bgColor};
        }
        
        /* Asegurarse de que las fuentes están disponibles */
        @font-face {
          font-family: 'Shadows Into Light';
          src: url('https://fonts.gstatic.com/s/shadowsintolight/v15/UqyNK9UOIntux_czAvDQx_ZcHqZXBNQDcsr4xq4.woff2') format('woff2');
          font-weight: normal;
          font-style: normal;
          font-display: swap;
        }
        
        @font-face {
          font-family: 'Lato';
          src: url('https://fonts.gstatic.com/s/lato/v24/S6u_w4BMUTPHjxsI9w2_Gwftx9897g.woff2') format('woff2');
          font-weight: 300;
          font-style: italic;
          font-display: swap;
        }
        
        .activity-title {
          font-family: 'Shadows Into Light', cursive;
          font-size: ${fontSize}px; 
          text-align: center;
          margin-bottom: 10px;
          max-width: 95%;
          overflow: hidden;
          text-overflow: ellipsis;
          font-weight: normal;
          text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
          letter-spacing: 0.5px;
        }
        
        .location-text {
          font-family: 'Lato', sans-serif;
          font-weight: 300;
          font-style: italic;
          font-size: 26px;
          opacity: 0.9;
          text-align: center;
          text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
        }
      </style>
    </head>
    <body>
      <div style="width: 100%; height: 100%; display: flex; flex-direction: column;">
        <div style="position: relative; flex: ${hasGallery ? '0.7' : '1'}; overflow: hidden;">
          <img src="${mainImageUrl}" alt="${escapeHtml(activity.name || '')}" 
               style="width: 100%; height: 100%; object-fit: cover;"
               onload="this.dataset.loaded='true'" 
               onerror="this.src='https://via.placeholder.com/800x600.png?text=Error+Loading+Image'; this.dataset.loaded='true'">
          <div style="position: absolute; bottom: 0; left: 0; width: 100%; padding: 30px 20px 25px 20px; 
                      background: linear-gradient(to bottom, rgba(16,53,43,0) 0%, rgba(16,53,43,0.1) 20%, rgba(16,53,43,0.7) 70%, rgba(16,53,43,0.85) 100%);
                      display: flex; flex-direction: column; align-items: center; justify-content: flex-end;">
            <div class="activity-title">${activityName}</div>
            ${locationName ? `<div class="location-text">${escapeHtml(locationName)}</div>` : ''}
          </div>
        </div>
        
        ${galleryHtml}
      </div>
      
      <script>
        // Marcar que la página está lista cuando todas las imágenes se han cargado
        window.addEventListener('load', function() {
          console.log('Página cargada completamente');
          window.pageFullyLoaded = true;
        });
        
        // Verificar periódicamente si todas las imágenes están cargadas
        const checkInterval = setInterval(function() {
          const images = document.querySelectorAll('img');
          let allLoaded = true;
          
          for (let img of images) {
            if (!img.dataset.loaded) {
              allLoaded = false;
              break;
            }
          }
          
          if (allLoaded) {
            clearInterval(checkInterval);
            console.log('Todas las imágenes cargadas');
            window.imagesLoaded = true;
          }
        }, 100);
        
        // Notificar a Gotenberg que la página está lista después de un tiempo
        setTimeout(function() {
          window.isPageReady = true;
          console.log('Indicador de página lista activado');
        }, 1000);
      </script>
    </body>
    </html>
  `;
}
