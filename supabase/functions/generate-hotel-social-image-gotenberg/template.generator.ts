// template.generator.ts
import { escapeHtml, getOptimizedImageUrl } from "./utils.ts";
// Define dimensions 
const width = 800;
const height = 800;
/**
 * Genera el HTML para la imagen social del hotel
 * @param templateData Datos para la plantilla
 * @returns String con el HTML generado
 */ export function generateHotelSocialImageHtml(templateData) {
  if (!templateData || !templateData.hotel) {
    console.error("Error: Missing hotel data in templateData");
    throw new Error("Missing required hotel data");
  }
  const { hotel, location, galleryImages = [] } = templateData;
  // Format location name
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
  // Get main image with fallback
  const mainImageUrl = hotel.main_image ? getOptimizedImageUrl(hotel.main_image, 1200, 80) : "https://via.placeholder.com/800x600.png?text=Main+Image+Missing";
  // Filter valid gallery images and limit to 3
  const filteredGalleryImages = Array.isArray(galleryImages) ? galleryImages.slice(0, 3).filter((img)=>img && img.url) : [];
  const hasGallery = filteredGalleryImages.length > 0;
  const hotelName = escapeHtml(hotel.name || "Hotel Name Missing");
  // Show hotel category if available
  const hotelCategory = hotel.category || "";
  // Determine font sizes based on text length
  let fontSize = 50;
  if (hotelName.length > 35) {
    fontSize = 36;
  } else if (hotelName.length > 25) {
    fontSize = 42;
  }
  // Background color for gallery section
  const bgColor = "#10352B"; // Verde oscuro elegante
  return `
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Hotel Social Image: ${escapeHtml(hotel.name || "")}</title>
      <link rel="preconnect" href="https://fonts.googleapis.com">
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
      <link href="https://fonts.googleapis.com/css2?family=Shadows+Into+Light&family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
      <style>
        body {
          margin: 0;
          padding: 0;
          width: ${width}px;
          height: ${height}px;
          overflow: hidden;
          color: #FFFFFF;
          font-family: 'Poppins', sans-serif;
        }
        
        .container {
          width: 100%;
          height: 100%;
          display: flex;
          flex-direction: column;
          background-color: ${bgColor};
        }
        
        .main-image-section {
          position: relative;
          flex: ${hasGallery ? '0.7' : '1'};
          overflow: hidden;
        }
        
        .main-image {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }
        
        .text-overlay {
          position: absolute;
          bottom: 0;
          left: 0;
          width: 100%;
          padding: 30px 20px 25px 20px;
          background: linear-gradient(to bottom, rgba(16,53,43,0) 0%, rgba(16,53,43,0.1) 20%, rgba(16,53,43,0.7) 70%, rgba(16,53,43,0.85) 100%);
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: flex-end;
        }
        
        .hotel-name {
          font-family: 'Shadows Into Light', cursive;
          font-size: ${fontSize}px;
          text-align: center;
          margin-bottom: 5px;
          max-width: 95%;
          overflow: hidden;
          text-overflow: ellipsis;
        }
        
        .hotel-category {
          font-size: 22px;
          opacity: 0.9;
          text-align: center;
          margin-bottom: 6px;
          font-weight: 300;
        }
        
        .location-name {
          font-size: 26px;
          opacity: 0.9;
          text-align: center;
        }
        
        .gallery-section {
          flex: ${hasGallery ? '0.3' : '0'};
          display: ${hasGallery ? 'flex' : 'none'};
          justify-content: center;
          align-items: center;
          padding: 20px;
          background-color: ${bgColor};
        }
        
        .gallery-container {
          display: flex;
          gap: 10px;
          justify-content: center;
          width: 100%;
        }
        
        .gallery-image-container {
          border-radius: 8px;
          overflow: hidden;
          border: 1px solid rgba(255,255,255,0.15);
          height: 200px;
          flex: 1;
          max-width: ${Math.floor((width - 40 - 20) / 3)}px;
        }
        
        .gallery-image {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="main-image-section">
          <img src="${mainImageUrl}" alt="${escapeHtml(hotel.name || '')}" class="main-image">
          <div class="text-overlay">
            <div class="hotel-name">${hotelName}</div>
            ${hotelCategory ? `<div class="hotel-category">${escapeHtml(hotelCategory)}</div>` : ''}
            ${locationName ? `<div class="location-name">${escapeHtml(locationName)}</div>` : ''}
          </div>
        </div>
        
        ${hasGallery ? `
        <div class="gallery-section">
          <div class="gallery-container">
            ${filteredGalleryImages.map((image)=>`
              <div class="gallery-image-container">
                <img src="${getOptimizedImageUrl(image.url, 400, 70)}" alt="Gallery image" class="gallery-image">
              </div>
            `).join('')}
          </div>
        </div>
        ` : ''}
      </div>
    </body>
    </html>
  `;
}
