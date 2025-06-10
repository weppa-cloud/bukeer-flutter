import { escapeHtml, getOptimizedImageUrl } from './utils.ts';
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
            body {
                font-family: 'Poppins', sans-serif; /* Use Poppins font */
                margin: 0;
                padding: 0;
                background-color: #ffffff;
                color: #333;
                font-size: 11px; /* Adjusted base font size */
                line-height: 1.5;
                font-weight: 400; /* Lighter font weight */
            }
            h1, h2 {
                 font-weight: 600; /* Bolder headings */
            }
            .container {
                max-width: 840px;
                margin: 0 auto; /* Solo margen horizontal, sin margen arriba/abajo */
                background-color: #ffffff;
                /* border: 1px solid #eee; */
                /* box-shadow: 0 2px 8px rgba(0,0,0,0.1); */
                display: flex;
                flex-direction: column;
                min-height: 0; /* Eliminar min-height que empuja el footer */
            }
            .header { /* Header now only acts as a top bar */
                background-color: #001f3f;
                color: #ffffff;
                padding: 5px 20px; /* Reduced padding */
                height: 10px; /* Make it a thin bar */
                flex-shrink: 0;
                text-align: right; /* Keep alignment for potential future use */
            }
             .header .agency-name {
                 /* Removed */
                 display: none;
            }
            .footer {
                 background-color: #001f3f;
                 color: #ffffff;
                 padding: 15px 20px;
                 display: flex;
                 justify-content: space-between;
                 align-items: center;
                 flex-shrink: 0;
                 font-size: 0.85em;
            }
            .footer-left img.logo {
                 max-height: 45px; /* Adjust logo size */
                 max-width: 150px;
            }
            .footer-right {
                 text-align: right;
            }
            .footer-right .contact-line {
                display: block; /* Each line on its own */
                margin-bottom: 3px; /* Space between lines */
            }
             .footer a {
                color: #ADD8E6;
                text-decoration: none;
            }
             .footer a:hover {
                text-decoration: underline;
            }
             .footer div { /* Spacing for footer lines */
                 margin-bottom: 2px;
             }
            .content-wrapper {
                display: flex;
                flex-grow: 1;
                padding: 0 30px 20px 30px; /* Reducido a la mitad (de 60px a 30px) */
                gap: 15px;
            }
            .left-column {
                flex: 2;
                display: flex;
                flex-direction: column;
                padding-top: 15px; /* Add padding to top */
            }
            .right-column {
                flex: 1;
                display: flex;
                flex-direction: column;
                padding-top: 15px; /* Add padding to top */
            }
            /* Remove old hotel-header */

            .hero-image {
                 position: relative; /* Needed for absolute positioning of text */
                 width: 100%; /* Take full width of container */
                 height: 280px; /* Adjust hero height */
                 margin-bottom: 0; /* Remove bottom margin */
            }
            .hero-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                display: block; /* Remove extra space below image */
                border-radius: 0; /* No radius for hero */
                border: none;
            }
            .hero-text {
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
                background: linear-gradient(to top, rgba(0, 31, 63, 0.8), rgba(0, 31, 63, 0)); /* Dark blue gradient overlay */
                color: #ffffff;
                padding: 30px 20px 15px 20px; /* Adjust padding */
                box-sizing: border-box;
            }
            .hero-text h1 {
                color: #ffffff;
                margin: 0 0 5px 0;
                font-size: 2.5em; /* Larger hero title */
                font-weight: 600;
                line-height: 1.6;
            }
             .hero-text .stars {
                color: #FFD700;
                font-size: 1.1em;
                margin-bottom: 5px;
                display: block; /* Ensure stars are on their own line */
            }
             .hero-text .location {
                font-size: 1.2em; /* Larger location text */
                font-weight: 400;
            }
             .hero-text .location-icon {
                 display: inline-block;
                 margin-right: 5px;
                 /* Consider using an actual icon font/SVG later */
             }
             .design-bar {
                 height: 10px; /* Height of the bar */
                 background-color: #001f3f; /* Dark Blue */
                 width: 100%;
                 margin-bottom: 20px; /* Space below the bar */
             }

            /* Remove main-image styles */

            .section {
                margin-bottom: 15px;
                padding: 0;
                background-color: transparent;
                border-left: none;
            }
            .section h2 {
                color: #001f3f;
                margin-top: 0;
                margin-bottom: 8px;
                font-size: 1.3em; /* Slightly larger section titles */
                border-bottom: 1px solid #eee;
                padding-bottom: 4px;
                font-weight: 600;
            }
             .section p, .section ul, .section ol {
                margin-bottom: 10px;
                font-size: 1em; /* Use base font size */
            }
             .section ul, .section ol {
                padding-left: 18px;
            }
             .section li {
                margin-bottom: 4px;
                display: flex;
                align-items: flex-start;
            }
            .list-icon {
                display: inline-block;
                margin-right: 6px;
                min-width: 14px;
                text-align: center;
            }
            .icon-check:before {
                content: '';
                display: inline-block;
                width: 10px;
                height: 10px;
                border-radius: 50%;
                background-color: #4CAF50;
            }
            .icon-cross:before {
                content: '';
                display: inline-block;
                width: 10px;
                height: 10px;
                border-radius: 50%;
                background-color: #F44336;
            }
            .list-text {
                flex: 1;
            }
            ul.inclusions, ul.exclusions {
                list-style-type: none;
                padding-left: 5px;
            }
            .gallery {
                margin-top: 0;
            }
            .gallery h2 {
                 color: #001f3f;
                 text-align: left;
                 margin-bottom: 10px;
                 font-size: 1.3em;
                 border-bottom: 1px solid #eee;
                 padding-bottom: 4px;
                 font-weight: 600;
            }
            .gallery-images {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            .gallery-images img {
                width: 100%;
                height: 140px; /* Rectangular, más bajo */
                object-fit: cover;
                border-radius: 4px;
                border: 1px solid #ddd;
            }
             /* Responsive adjustments (less critical for PDF, but good practice) */
            @media (max-width: 768px) {
                .content-wrapper {
                    flex-direction: column;
                }
                .right-column {
                    order: -1; /* Move images to top on small screens */
                }
                 .main-image img {
                    max-height: 200px;
                }
                 .gallery-images {
                    grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
                }
            }

             @media print {
                 body {
                     font-size: 9pt; /* Adjust print font size */
                     background-color: #ffffff;
                     font-family: 'Poppins', sans-serif !important;
                 }
                 .container {
                     box-shadow: none;
                     border: none;
                     margin: 0;
                     max-width: 100%;
                     min-height: auto; /* Adjust min-height for print */
                 }
                 .header {
                     background-color: #001f3f !important;
                     color: #ffffff !important;
                     height: 10px !important; /* Ensure height in print */
                     padding: 0 !important; /* Remove padding for thin bar */
                     -webkit-print-color-adjust: exact;
                     print-color-adjust: exact;
                 }
                 .hero-text {
                     background: linear-gradient(to top, rgba(0, 31, 63, 0.8), rgba(0, 31, 63, 0)) !important;
                     color: #ffffff !important;
                     -webkit-print-color-adjust: exact;
                     print-color-adjust: exact;
                 }
                 .hero-text h1, .hero-text .location {
                      color: #ffffff !important;
                 }
                 .hero-text .stars {
                     color: #FFD700 !important;
                     -webkit-print-color-adjust: exact;
                     print-color-adjust: exact;
                 }
                 .design-bar {
                      background-color: #001f3f !important;
                     -webkit-print-color-adjust: exact;
                     print-color-adjust: exact;
                 }
                 .content-wrapper {
                     padding: 0 30px 20px 30px; /* Reducido a la mitad (de 60px a 30px) */
                     gap: 15px;
                 }
                 .section h2, .gallery h2 {
                      color: #001f3f !important;
                      -webkit-print-color-adjust: exact;
                      print-color-adjust: exact;
                 }
                 /* Avoid page breaks inside elements */
                 .section, .gallery-images img, .hero-image {
                     page-break-inside: avoid;
                 }
                 .gallery-images {
                      page-break-before: auto;
                 }
                 .footer {
                     page-break-before: auto; /* Try to keep footer from splitting */
                 }
             }
             .section-icon {
                color: #001f3f; /* Color azul del tema */
                font-size: 16px;
                font-weight: bold;
                display: inline-block;
                margin-right: 8px;
                vertical-align: middle;
             }
             .visual-bullets {
                list-style-type: none;
                padding-left: 0;
            }
            .visual-bullets li {
                padding-left: 20px;
                position: relative;
                margin-bottom: 6px;
            }
            .visual-bullets li:before {
                content: "•";
                color: #001f3f;
                font-size: 18px;
                position: absolute;
                left: 0;
                top: -2px;
            }
            .truncate-description {
                display: -webkit-box;
                -webkit-line-clamp: 7;
                -webkit-box-orient: vertical;
                overflow: hidden;
                text-overflow: ellipsis;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <!-- Agency name removed -->
            </div>

             ${hotel.main_image ? `
             <div class="hero-image">
                 <img src="${getOptimizedImageUrl(hotel.main_image, 1200, 75)}" alt="${hotel.name}">
                 <div class="hero-text">
                     <h1>${hotel.name}</h1>
                     ${generateStars(hotel.star_rating)}
                     ${location ? `<div class="location"><span class="location-icon">📍</span>${location.city ? location.city + ', ' : ''}${location.country ?? ''}</div>` : ''}
                 </div>
             </div>
             <div class="design-bar"></div>
             ` : `
             <div class="design-bar" style="margin-bottom: 20px;"></div>
             `}


            <div class="content-wrapper">
                <div class="left-column">
                    <!-- Hotel Header removed, info moved to hero -->

                    ${hotel.description ? `
                    <div class="section">
                        ${generateSectionTitle('Descripción', 'bi-info-circle')}
                        <p class="truncate-description">${hotel.description}</p>
                    </div>
                    ` : ''}

                    ${hotel.inclutions ? `
                    <div class="section">
                        ${generateSectionTitle('Incluido', 'bi-check-circle')}
                        ${generateList(hotel.inclutions, 'ul', true)}
                    </div>
                    ` : ''}

                    ${hotel.exclutions ? `
                    <div class="section">
                        ${generateSectionTitle('No Incluido', 'bi-x-circle')}
                        ${generateList(hotel.exclutions, 'ul', true)}
                    </div>
                    ` : ''}

                    ${hotel.recomendations ? `
                    <div class="section">
                        ${generateSectionTitle('Observaciones', 'bi-star')}
                        <p class="truncate-description">${hotel.recomendations}</p>
                    </div>
                    ` : ''}

                </div>

                <div class="right-column">
                    ${galleryImages && galleryImages.length > 0 ? `
                    <div class="gallery section">
                        ${generateSectionTitle('Galería', 'bi-images')}
                        <div class="gallery-images">
                            ${galleryImages.map((img)=>`<img src="${getOptimizedImageUrl(img.url, 400, 60)}" alt="Hotel image">`).join('')}
                        </div>
                    </div>
                    ` : ''}
                </div>
            </div>
            </div>
        </div>
    </body>
    </html>
  `;
}
