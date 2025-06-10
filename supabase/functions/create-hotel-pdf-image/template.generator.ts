import { escapeHtml } from './utils.ts';
export function generateHotelPdfTemplate(data) {
  const { hotel, account, galleryImages, location } = data;
  // Helper to generate star ratings
  const generateStars = (rating)=>{
    if (rating === null || rating <= 0) return '';
    let stars = '';
    for(let i = 0; i < Math.floor(rating); i++){
      stars += '⭐'; // Using emoji for simplicity, could be replaced with icons
    }
    return `<span class="stars">${stars}</span>`;
  };
  // Helper to generate section titles with Bootstrap icons
  const generateSectionTitle = (title, iconClass)=>{
    return `<h2><i class="bi ${iconClass}" style="color: #001f3f; margin-right: 8px;"></i>${title}</h2>`;
  };
  // Helper to generate list items with bullets or as paragraph
  const generateList = (items, listType = 'ul', useVisualbullets = false)=>{
    if (!items) return '';
    const listItems = items.split(',').map((item)=>item.trim()).filter((item)=>item.length > 0);
    if (listItems.length === 0) return '';
    if (useVisualbullets) {
      // Use visual bullets for certain lists
      return `<${listType} class="visual-bullets">${listItems.map((item)=>`<li>${escapeHtml(item)}</li>`).join('')}</${listType}>`;
    } else {
      // Use standard list or paragraph
      return `<${listType}>${listItems.map((item)=>`<li>${escapeHtml(item)}</li>`).join('')}</${listType}>`;
    }
  };
  return `
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hotel Information: ${hotel.name}</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <style>
            html, body {
                font-family: 'Poppins', sans-serif;
                margin: 0;
                padding: 0;
                background-color: #ffffff;
                color: #222;
                font-size: 14px;
                line-height: 1.6;
                font-weight: 400;
                min-height: 100vh;
                width: 100%;
                -webkit-font-smoothing: antialiased;
                -moz-osx-font-smoothing: grayscale;
                text-rendering: optimizeLegibility;
                -webkit-text-size-adjust: 100%;
                -webkit-tap-highlight-color: transparent;
                font-feature-settings: "kern" 1;
                font-kerning: normal;
                image-rendering: -webkit-optimize-contrast;
                image-rendering: crisp-edges;
            }
            h1, h2 {
                font-weight: 600;
            }
            .page-container {
                width: 816px;
                margin: 0 auto;
                background-color: #ffffff;
                position: relative;
                height: 1056px; /* Letter size: 8.5 x 11 inches at 96 DPI */
                overflow: hidden; /* Ensure content doesn't overflow */
            }
            .header-bar {
                background-color: #001f3f;
                height: 10px;
                width: 100%;
            }
            .content-container {
                display: flex;
                flex-direction: column;
                /* Explicitly subtract footer height (50px) to make sure content doesn't overlap footer */
                height: calc(100% - 60px); /* Subtract header (10px) and footer (50px) height */
                padding-bottom: 0; /* Remove bottom padding */
            }
            .hero-section {
                position: relative;
                width: 100%;
                height: 260px; /* Reduced from 280px */
            }
            .hero-image {
                width: 100%;
                height: 100%;
                object-fit: cover;
                image-rendering: -webkit-optimize-contrast;
                image-rendering: crisp-edges;
                backface-visibility: hidden;
                transform: translateZ(0);
            }
            .hero-overlay {
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
                background: linear-gradient(to top, rgba(0, 31, 63, 0.8), rgba(0, 31, 63, 0));
                color: #ffffff;
                padding: 30px 20px 15px 20px;
                box-sizing: border-box;
            }
            .hero-title {
                color: #ffffff;
                margin: 0 0 5px 0;
                font-size: 2.5em;
                font-weight: 600;
                line-height: 1.6;
            }
            .stars {
                color: #FFD700;
                font-size: 1.1em;
                margin-bottom: 5px;
                display: block;
            }
            .location {
                font-size: 1.2em;
                font-weight: 400;
            }
            .design-bar {
                height: 10px;
                background-color: #001f3f;
                width: 100%;
                margin-bottom: 15px; /* Reduced margin for better space utilization */
            }
            .main-content {
                display: flex;
                padding: 0 30px 0 30px; /* Removed bottom padding */
                gap: 15px;
                flex: 1;
                overflow: hidden; /* Prevent content from overflowing the container */
            }
            .content-column-left {
                flex: 2;
                overflow: hidden; /* Prevent overflow in left column */
                max-height: 100%; /* Ensure column doesn't exceed container height */
            }
            .content-column-right {
                flex: 1;
                overflow: hidden; /* Prevent overflow in right column */
                max-height: 100%; /* Ensure column doesn't exceed container height */
            }
            .section {
                margin-bottom: 10px; /* Further reduced margin for better space utilization */
            }
            .section-title {
                color: #001f3f;
                margin-top: 0;
                margin-bottom: 6px; /* Reduced margin for more compact layout */
                font-size: 1.4em; /* Aumentado de 1.3em a 1.4em */
                border-bottom: 1px solid #eee;
                padding-bottom: 3px; /* Reduced padding for compactness */
                font-weight: 600;
            }
            .section-content {
                margin-bottom: 8px; /* Reduced margin for compactness */
                font-size: 1.05em; /* Aumentado de 1em a 1.05em */
                line-height: 1.3; /* Further reduced from 1.5 to 1.3 for more compact text */
                text-align: justify; /* Justificar el texto para mejor presentación */
            }
            .section-content.description {
                display: -webkit-box;
                -webkit-line-clamp: 10; /* Aumentado de 6 a 10 líneas para mostrar más texto */
                -webkit-box-orient: vertical;
                overflow: hidden;
                text-overflow: ellipsis;
                line-height: 1.4; /* Slightly higher line height for better readability */
            }
            .section-content.recommendations {
                display: -webkit-box;
                -webkit-line-clamp: 3;
                -webkit-box-orient: vertical;
                overflow: hidden;
                text-overflow: ellipsis;
                line-height: 1.2; /* Slightly higher line height for better readability */
            }
            .section-list {
                padding-left: 18px;
                margin: 0; /* Remove default margins for tighter spacing */
            }
            .section-list-item {
                margin-bottom: 2px; /* Reduced margin for more compact lists */
                line-height: 1.2; /* Tighter line spacing for list items */
            }
            .gallery-grid {
                display: flex;
                flex-direction: column;
                gap: 6px; /* Reduced gap for more compact gallery */
                overflow: hidden; /* Prevent gallery overflow */
            }
            .gallery-image {
                width: 100%;
                height: 160px; /* Aumentado de 110px a 160px para aprovechar mejor el espacio */
                object-fit: cover;
                border-radius: 4px;
                border: 1px solid #ddd;
                image-rendering: -webkit-optimize-contrast;
                image-rendering: crisp-edges;
                backface-visibility: hidden;
                transform: translateZ(0);
            }
            .footer {
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
                height: 50px; /* Reducido de 60px a 50px para menos salto de línea */
            }
            .footer-content {
                width: 100%;
                font-family: 'Poppins', sans-serif;
                font-size: 11px; /* Reducido de 12px a 11px para mayor compactación */
                color: #6c757d;
                background-color: #f8f9fa;
                border-top: 1px solid #dee2e6;
                height: 42px; /* Reducido de 50px a 42px para menos espacio vertical */
                line-height: 1.1; /* Reducido el espaciado entre líneas */
            }
            .footer-bar {
                height: 8px; /* Reducido de 10px a 8px */
                background-color: #001f3f;
                width: 100%;
            }
        </style>
    </head>
    <body>
        <div class="page-container">
            <!-- Header Bar -->
            <div class="header-bar"></div>
            
            <div class="content-container">
                <!-- Hero Section -->
                ${hotel.main_image ? `
                <div class="hero-section">
                    <img class="hero-image" src="${hotel.main_image}" alt="${hotel.name}" onload="this.classList.add('loaded')">
                    <div class="hero-overlay">
                        <h1 class="hero-title">${hotel.name}</h1>
                        ${hotel.star_rating ? `<span class="stars">${'⭐'.repeat(Math.floor(hotel.star_rating))}</span>` : ''}
                        ${location ? `<div class="location"><span>📍</span>${location.city ? location.city + ', ' : ''}${location.country ?? ''}</div>` : ''}
                    </div>
                </div>
                <div class="design-bar"></div>
                ` : `
                <div class="design-bar"></div>
                `}
                
                <!-- Main Content -->
                <div class="main-content">
                    <div class="content-column-left">
                        <!-- Descripción -->
                        ${hotel.description ? `
                        <div class="section">
                            <h2 class="section-title">
                                <i class="bi bi-info-circle" style="color: #001f3f; margin-right: 8px;"></i>Descripción
                            </h2>
                            <p class="section-content description">${hotel.description}</p>
                        </div>
                        ` : ''}

                        <!-- Incluido -->
                        ${hotel.inclutions ? `
                        <div class="section">
                            <h2 class="section-title">
                                <i class="bi bi-check-circle" style="color: #001f3f; margin-right: 8px;"></i>Incluido
                            </h2>
                            <ul class="section-list">
                                ${hotel.inclutions.split(',').map((item)=>`<li class="section-list-item">${item.trim()}</li>`).join('')}
                            </ul>
                        </div>
                        ` : ''}

                        <!-- No Incluido -->
                        ${hotel.exclutions ? `
                        <div class="section">
                            <h2 class="section-title">
                                <i class="bi bi-x-circle" style="color: #001f3f; margin-right: 8px;"></i>No Incluido
                            </h2>
                            <ul class="section-list">
                                ${hotel.exclutions.split(',').map((item)=>`<li class="section-list-item">${item.trim()}</li>`).join('')}
                            </ul>
                        </div>
                        ` : ''}

                        <!-- Observaciones -->
                        ${hotel.recomendations ? `
                        <div class="section">
                            <h2 class="section-title">
                                <i class="bi bi-star" style="color: #001f3f; margin-right: 8px;"></i>Observaciones
                            </h2>
                            <p class="section-content recommendations">${hotel.recomendations}</p>
                        </div>
                        ` : ''}
                    </div>

                    <!-- Galería de imágenes -->
                    <div class="content-column-right">
                        ${galleryImages && galleryImages.length > 0 ? `
                        <div class="section">
                            <h2 class="section-title">
                                <i class="bi bi-images" style="color: #001f3f; margin-right: 8px;"></i>Galería
                            </h2>
                            <div class="gallery-grid">
                                ${galleryImages.slice(0, 3).map((img)=>`<img class="gallery-image" src="${img.url}" alt="Hotel image" onload="this.classList.add('loaded')">`).join('')}
                            </div>
                        </div>
                        ` : ''}
                    </div>
                </div>
            </div>
            
            <!-- Footer -->
            <div class="footer">
                <table class="footer-content">
                    <tr>
                        <td style="width: 30%; padding: 6px 8px; text-align: left; vertical-align: middle; line-height: 1.1;">
                            ${account?.logo_image_base64 ? `<img src="${account.logo_image_base64}" alt="Logo" style="height: 24px; max-width: 90px;" onload="this.classList.add('loaded')">` : ''}
                        </td>
                        <td style="width: 40%; padding: 6px 8px; text-align: center; vertical-align: middle; line-height: 1.1;">
                            ${account?.name ? `<div style="font-weight: bold; margin-bottom: 1px; font-size: 11px;">${account.name}</div>` : ''}
                            ${account?.website ? `<div><a href="${account.website}" style="color: #007bff; text-decoration: none; font-size: 10px;">${account.website}</a></div>` : ''}
                        </td>
                        <td style="width: 30%; padding: 6px 8px 8px 8px; text-align: right; vertical-align: middle; font-size: 10px; line-height: 1.1;">
                            ${account?.phone ? `<div style="margin-bottom: 1px;">Tel: ${account.phone}${account.phone2 ? ' / ' + account.phone2 : ''}</div>` : ''}
                            ${account?.mail ? `<div>Email: <a href="mailto:${account.mail}" style="color: #007bff; text-decoration: none;">${account.mail}</a></div>` : ''}
                        </td>
                    </tr>
                </table>
                <div class="footer-bar"></div>
            </div>
        </div>

        <script>
            // Script mejorado para asegurar la carga de imagenes
            window.imagesLoaded = false;
            window.imageLoadErrors = 0;
            
            function checkImagesLoaded() {
              var images = document.querySelectorAll('img');
              var loadedImages = 0;
              var totalImages = images.length;
              
              if (totalImages === 0) {
                // No hay imagenes, marcar como listo
                window.imagesLoaded = true;
                console.log("No hay imagenes para cargar, pagina lista");
                return;
              }
              
              // Verificar el estado de cada imagen
              images.forEach(function(img) {
                if (img.complete) {
                  loadedImages++;
                } else {
                  // Agregar event listeners a imagenes no cargadas
                  img.addEventListener('load', function() {
                    loadedImages++;
                    checkIfAllLoaded();
                  });
                  
                  img.addEventListener('error', function() {
                    window.imageLoadErrors++;
                    loadedImages++; // Contamos errores como "cargados" para continuar
                    console.error('Error cargando imagen:', img.src);
                    checkIfAllLoaded();
                  });
                }
              });
              
              function checkIfAllLoaded() {
                if (loadedImages >= totalImages) {
                  window.imagesLoaded = true;
                  console.log("Todas las imagenes procesadas, pagina lista para captura");
                  if (window.imageLoadErrors > 0) {
                    console.warn("Hubo " + window.imageLoadErrors + " errores al cargar imagenes");
                  }
                }
              }
              
              // Verificar imagenes ya cargadas
              checkIfAllLoaded();
            }
            
            // Ejecutar cuando el DOM este listo
            document.addEventListener('DOMContentLoaded', function() {
              setTimeout(checkImagesLoaded, 500);
            });
            
            // Ejecutar cuando todo el documento este cargado
            window.addEventListener('load', function() {
              setTimeout(checkImagesLoaded, 1000);
            });
            
            // Respaldo final para asegurar que no se quede esperando indefinidamente
            setTimeout(function() {
              window.imagesLoaded = true;
              console.log("Tiempo maximo alcanzado, marcando como listo");
            }, 3500);
        </script>
    </body>
    </html>
  `;
}
