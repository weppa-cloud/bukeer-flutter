// supabase/functions/generate-itinerary-pdf/template.generator.ts
import { escapeHtml, formatDate, formatCurrency, createList, getOptimizedImageUrl, formatItineraryDate, groupItemsByDate } from './utils.ts';
export function generateItineraryPdfTemplate(data) {
  const { itinerary, contact, agent, items, account } = data;
  // Group items by date
  const itemsByDate = groupItemsByDate(items);
  // Sort dates
  const sortedDates = Object.keys(itemsByDate).sort();
  // Generate day sections
  const daySections = sortedDates.map((date, dayIndex)=>{
    const dayItems = itemsByDate[date];
    return generateDaySection(date, dayIndex + 1, dayItems);
  }).join('');
  return `
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Itinerario: ${escapeHtml(itinerary.name)}</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <style>
            :root {
                --primary-color: rgb(32, 76, 167);
                --light-primary: rgba(32, 76, 167, 0.1);
                --secondary-color: #f8f9fa;
                --text-color: #333;
                --light-gray: #eee;
                --success-color: #28a745;
                --danger-color: #dc3545;
                --warning-color: #ffc107;
            }
            
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            
            body {
                font-family: 'Poppins', sans-serif;
                color: var(--text-color);
                line-height: 1.6;
                background-color: white;
                font-size: 13px; /* Incrementado de 11px a 13px */
                margin: 0;
                padding: 0;
                padding-bottom: 50px; /* Espacio adicional para el footer */
            }
            
            .container {
                max-width: 100%;
                margin: 0;
                padding: 0;
                position: relative;
            }
            
            /* Hero Header Styles */
            .hero-header {
                position: relative;
                height: 350px;
                overflow: hidden;
                margin: 0;
                padding: 0;
                width: 100vw;
            }
            
            .hero-image {
                width: 100%;
                height: 100%;
                object-fit: cover; /* Cambiado de cover a contain para mantener la proporción */
                display: block;
            }
            
            .hero-overlay {
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                background: linear-gradient(to top, rgba(0, 0, 0, 0.8), transparent);
                padding: 30px;
                display: flex;
                justify-content: space-between;
                align-items: flex-end;
            }
            
            .hero-title {
                color: white;
                font-size: 32px; /* Incrementado de 28px a 32px */
                font-weight: 700;
                text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
                flex: 1;
                margin: 0;
            }
            
            .agency-logo {
                max-width: 120px;
                max-height: 80px;
                object-fit: contain;
                margin-left: 15px;
            }
            
            /* Main Content */
            .content {
                padding: 0px 30px 60px; /* Incrementado padding inferior para evitar solapamiento con footer */
            }
            
            /* Client and Itinerary Info */
            .info-row {
                display: flex;
                flex-wrap: wrap;
                margin: 15px 0;
                gap: 10px;
                background-color: var(--secondary-color);
                padding: 12px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            }
            
            .info-item {
                display: flex;
                align-items: center;
                margin-right: 15px;
                font-size: 12px; /* Incrementado de 10px a 12px */
            }
            
            .info-item i {
                color: var(--primary-color);
                margin-right: 5px;
                font-size: 16px; /* Incrementado de 14px a 16px */
            }
            
            /* Agent Card */
            .agent-card {
                display: flex;
                background-color: var(--light-primary);
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 20px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            }
            
            .agent-photo {
                width: 70px; /* Incrementado de 60px a 70px */
                height: 70px; /* Incrementado de 60px a 70px */
                border-radius: 50%;
                object-fit: cover;
                border: 2px solid var(--primary-color);
                margin-right: 15px;
            }
            
            .agent-info {
                flex: 1;
            }
            
            .agent-info h3 {
                font-size: 16px; /* Incrementado de 14px a 16px */
                margin-bottom: 3px;
                color: var(--primary-color);
            }
            
            .agent-info p {
                font-size: 12px; /* Incrementado de 10px a 12px */
                margin-bottom: 5px;
            }
            
            .agent-message {
                font-style: italic;
                margin-top: 8px;
                font-size: 12px; /* Incrementado de 10px a 12px */
                color: #555;
            }
            
            /* Day Section */
            .day-header {
                background-color: var(--primary-color);
                color: white;
                padding: 8px 15px;
                border-radius: 20px;
                margin: 20px 0 15px;
                display: inline-block;
                font-size: 14px; /* Incrementado de 12px a 14px */
                font-weight: 500;
            }
            
            /* Items */
            .item {
                margin-bottom: 25px; /* Incrementado margen */
                position: relative;
            }
            
            .item-header {
                display: flex;
                margin-bottom: 12px; /* Incrementado */
            }
            
            .item-icon-wrapper {
                width: 40px; /* Incrementado */
                min-width: 40px;
                display: flex;
                justify-content: center;
                margin-right: 10px;
            }
            
            .item-icon {
                width: 32px; /* Incrementado de 28px a 32px */
                height: 32px; /* Incrementado de 28px a 32px */
                border-radius: 50%;
                background-color: var(--primary-color);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 16px; /* Incrementado de 14px a 16px */
            }
            
            .item-title {
                flex: 1;
            }
            
            .item-title h3 {
                font-size: 18px; /* Incrementado de 16px a 18px */
                font-weight: 600;
                margin-bottom: 5px;
                color: var (--text-color);
            }
            
            .item-info {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                margin-bottom: 5px;
                font-size: 12px; /* Incrementado de 10px a 12px */
            }
            
            .item-info-detail {
                display: flex;
                align-items: center;
            }
            
            .item-info-detail i {
                color: var(--primary-color);
                margin-right: 5px;
                font-size: 14px; /* Incrementado de 12px a 14px */
            }
            
            .item-content {
                margin-left: 50px; /* Incrementado de 45px a 50px */
            }
            
            .item-images {
                display: flex;
                gap: 10px;
                margin-bottom: 15px;
            }
            
            .item-image {
                width: calc(33.333% - 7px);
                height: 120px; /* Ajustado a 120px para mejor proporción 16:9 */
                object-fit: cover;
                border-radius: 6px;
                border: 1px solid var(--light-gray);
            }
            
            /* Imagen principal más grande (ocupa primera fila completa) */
            .item-image.main-image {
                grid-column: span 2;
                height: 180px;
            }
            
            .item-description {
                margin-bottom: 12px; /* Incrementado de 10px a 12px */
                font-size: 12px; /* Incrementado de 10px a 12px */
            }
            
            /* Inclusions/Exclusions */
            .inclusions-exclusions {
                display: flex;
                gap: 18px; /* Incrementado de 15px a 18px */
                margin-bottom: 12px; /* Incrementado de 10px a 12px */
            }
            
            .inclusions, .exclusions, .recommendations {
                flex: 1;
            }
            
            .section-title {
                font-size: 13px; /* Incrementado de 11px a 13px */
                font-weight: 600;
                margin-bottom: 5px;
                color: var(--primary-color);
                display: flex;
                align-items: center;
            }
            
            .section-title i {
                margin-right: 5px;
            }
            
            .inclusions-list, .exclusions-list {
                list-style-type: none;
                padding-left: 0;
                font-size: 11px; /* Incrementado de 9px a 11px */
            }
            
            .inclusions-list li, .exclusions-list li {
                margin-bottom: 4px; /* Incrementado de 3px a 4px */
                position: relative;
                padding-left: 15px;
            }
            
            .inclusions-list li:before {
                content: "✓";
                color: var(--success-color);
                position: absolute;
                left: 0;
            }
            
            .exclusions-list li:before {
                content: "✕";
                color: var(--danger-color);
                position: absolute;
                left: 0;
            }
            
            /* Flight Item */
            .flight-item-content {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-left: 50px; /* Incrementado de 45px a 50px */
            }
            
            .flight-details {
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
                width: 100%;
            }
            
            .flight-route {
                display: flex;
                justify-content: space-between;
                width: 100%;
                margin: 15px 0;
            }
            
            .flight-point {
                text-align: center;
                width: 30%;
            }
            
            .flight-middle {
                flex: 1;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 0 10px;
            }
            
            .flight-line {
                height: 2px;
                background-color: var(--primary-color);
                width: 100%;
                position: relative;
                margin: 10px 0;
            }
            
            .flight-line:after {
                content: "✈";
                position: absolute;
                top: -10px;
                left: 50%;
                transform: translateX(-50%);
                color: var(--primary-color);
                font-size: 18px; /* Incrementado de 16px a 18px */
            }
            
            .flight-iata {
                font-size: 18px; /* Incrementado de 16px a 18px */
                font-weight: 600;
                margin-bottom: 3px;
            }
            
            .flight-city {
                font-size: 12px; /* Incrementado de 10px a 12px */
                margin-bottom: 5px;
            }
            
            .flight-time {
                font-size: 16px; /* Incrementado de 14px a 16px */
                font-weight: 600;
                color: var(--primary-color);
            }
            
            .flight-label {
                font-size: 11px; /* Incrementado de 9px a 11px */
                color: #666;
            }
            
            .airline-logo {
                height: 45px; /* Incrementado de 40px a 45px */
                margin: 10px auto;
                display: block;
            }
            
            /* Transport Item */
            .transport-image {
                width: 70px; /* Incrementado de 60px a 70px */
                height: 70px; /* Incrementado de 60px a 70px */
                object-fit: cover;
                border-radius: 4px;
                margin-right: 12px; /* Incrementado de 10px a 12px */
            }
            
            /* Schedule Section */
            .schedule-section {
                margin-bottom: 12px; /* Incrementado de 10px a 12px */
            }
            
            .schedule-item {
                display: flex;
                margin-bottom: 10px; /* Incrementado de 8px a 10px */
                gap: 12px; /* Incrementado de 10px a 12px */
            }
            
            .schedule-image {
                width: 70px; /* Incrementado de 60px a 70px */
                height: 70px; /* Incrementado de 60px a 70px */
                object-fit: cover;
                border-radius: 4px;
                flex-shrink: 0;
            }
            
            .schedule-content {
                flex: 1;
            }
            
            .schedule-title {
                font-size: 14px; /* Incrementado de 12px a 14px */
                font-weight: 600;
                margin-bottom: 3px;
            }
            
            .schedule-description {
                font-size: 11px; /* Incrementado de 9px a 11px */
            }
            
            /* Personalized Message */
            .personalized-message {
                background-color: #f8f9fa;
                padding: 10px 12px; /* Incrementado */
                border-left: 3px solid var(--primary-color);
                font-style: italic;
                margin-bottom: 12px; /* Incrementado de 10px a 12px */
                font-size: 11px; /* Incrementado de 9px a 11px */
            }
            
            /* Price Section */
            .price-section {
                margin-top: 35px; /* Incrementado de 30px a 35px */
                padding-top: 25px; /* Incrementado de 20px a 25px */
                border-top: 1px solid var(--light-gray);
            }
            
            .price-header {
                background-color: var(--primary-color);
                color: white;
                padding: 10px 18px; /* Incrementado */
                border-radius: 6px;
                display: inline-block;
                margin-bottom: 15px;
                font-size: 16px; /* Incrementado de 14px a 16px */
                font-weight: 500;
            }
            
            .price-header span {
                font-size: 12px; /* Incrementado de 10px a 12px */
                display: block;
            }
            
            .price-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 25px; /* Incrementado de 20px a 25px */
                background-color: var(--secondary-color);
                border-radius: 6px;
                overflow: hidden;
            }
            
            .price-table th {
                background-color: var(--primary-color);
                color: white;
                font-size: 14px; /* Incrementado de 12px a 14px */
                font-weight: 500;
                text-align: center;
                padding: 10px; /* Incrementado de 8px a 10px */
            }
            
            .price-table td {
                text-align: center;
                padding: 14px 10px; /* Incrementado */
                font-size: 16px; /* Incrementado de 15px a 16px */
                font-weight: 600;
            }
            
            /* Terms and Conditions */
            .terms {
                border-top: 1px solid var(--primary-color);
                margin-top: 35px; /* Incrementado de 30px a 35px */
                padding-top: 12px; /* Incrementado de 10px a 12px */
                font-size: 10px; /* Incrementado de 9px a 10px */
                color: var(--primary-color);
            }
            
            .terms p {
                margin-bottom: 4px; /* Incrementado de 3px a 4px */
            }
            
            @media print {
                body {
                    -webkit-print-color-adjust: exact !important;
                    print-color-adjust: exact !important;
                    margin: 0 !important;
                    padding: 0 !important;
                    padding-bottom: 50px !important; /* Espacio para el footer */
                }
                
                .container {
                    width: 100% !important;
                    margin: 0 !important;
                    padding: 0 !important;
                }
                
                .hero-header {
                    width: 100% !important;
                    margin: 0 !important;
                }
                
                .hero-header, .hero-overlay, .day-header, .item-icon, .price-header, .price-table th {
                    print-color-adjust: exact !important;
                    -webkit-print-color-adjust: exact !important;
                }
                
                .content {
                    padding-bottom: 100px !important; /* Mayor margen inferior para el footer */
                }
                
                /* Agregamos margen superior para nuevas páginas */
                .day-section {
                    page-break-before: auto;
                    page-break-after: auto;
                    margin-top: 20px;
                }
                
                /* Evitar cortes en elementos importantes */
                .item {
                    page-break-inside: avoid;
                    margin-bottom: 30px;
                }
                
                /* Controlar saltos de página */
                .item-content, .inclusions-exclusions, .flight-item-content {
                    page-break-inside: avoid;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <!-- Hero Header -->
            <div class="hero-header">
                <img src="${getOptimizedImageUrl(itinerary.main_image_itinerary || 'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/photo-1533699224246-6dc3b3ed3304%20(1).jpg', 1200, 90)}" alt="Hero Image" class="hero-image">
                <div class="hero-overlay">
                    <h1 class="hero-title">${escapeHtml(itinerary.name)}</h1>
                    ${account.logo_account ? `
                    <img src="${getOptimizedImageUrl(account.logo_account, 300, 90)}" alt="${escapeHtml(account.name)}" class="agency-logo">
                    ` : ''}
                </div>
            </div>
            
            <div class="content">
                <!-- Client and Itinerary Info -->
                <div class="info-row">
                    <div class="info-item">
                        <i class="bi bi-person"></i>
                        <span>${escapeHtml(contact.name + ' ' + contact.lastname)}</span>
                    </div>
                    
                    <div class="info-item">
                        <i class="bi bi-hash"></i>
                        <span>ID ${escapeHtml(itinerary.id_fm)}</span>
                    </div>
                    
                    <div class="info-item">
                        <i class="bi bi-calendar-range"></i>
                        <span>${formatDate(itinerary.start_date)} - ${formatDate(itinerary.end_date)}</span>
                    </div>
                    
                    <div class="info-item">
                        <i class="bi bi-people"></i>
                        <span>${itinerary.passengers} ${itinerary.passengers === 1 ? 'persona' : 'personas'}</span>
                    </div>
                </div>
                
                <!-- Agent Card -->
                <div class="agent-card">
                    <img src="${getOptimizedImageUrl(agent.image, 150, 80)}" alt="${escapeHtml(agent.name)}" class="agent-photo">
                    
                    <div class="agent-info">
                        <h3>${escapeHtml(agent.name + ' ' + agent.lastname)}</h3>
                        <p>Travel Planner</p>
                        <p><i class="bi bi-envelope"></i> ${escapeHtml(agent.email)}</p>
                        
                        ${itinerary.personalized_message ? `
                        <div class="agent-message">
                            "${escapeHtml(itinerary.personalized_message)}"
                        </div>
                        ` : ''}
                    </div>
                </div>
                
                <!-- Itinerary Items -->
                ${daySections}
                
                <!-- Price Section -->
                <div class="price-section">
                    <div class="price-header">
                        Oferta
                        <span>Válida hasta el ${formatDate(itinerary.valid_until)}</span>
                    </div>
                    
                    <table class="price-table">
                        <thead>
                            <tr>
                                <th>Gran Total</th>
                                <th>Por Persona</th>
                                <th>Por Persona/Día</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>$${formatCurrency(itinerary.total_amount)} ${itinerary.moneda || ''}</td>
                                <td>$${formatCurrency(itinerary.total_amount / itinerary.passengers)} ${itinerary.moneda || ''}</td>
                                <td>$${formatCurrency(itinerary.total_amount / itinerary.passengers / calculateDaysBetweenDates(itinerary.start_date, itinerary.end_date))} ${itinerary.moneda || ''}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                
                <!-- Terms and Conditions -->
                <div class="terms">
                    <p>Términos y Condiciones: Al pagar confirmas los servicios y aceptas estar de acuerdo con los términos y condiciones del servicio especificados en ${account.terms_conditions || '[Términos y Condiciones]'}</p>
                    <p>Política de Privacidad: Tus datos están seguros al contactar a través de nuestros canales oficiales de acuerdo a lo señalado en la política especificada en ${account.privacy_policy || '[Política de Privacidad]'}</p>
                </div>
            </div>
        </div>
    </body>
    </html>
  `;
}
// Helper to generate day section
function generateDaySection(date, dayNumber, items) {
  return `
    <div class="day-section">
        <div class="day-header">
            Día ${dayNumber}: ${formatItineraryDate(date)}
        </div>
        
        ${items.map((item)=>generateItemSection(item)).join('')}
    </div>
  `;
}
// Helper to generate item section based on type
function generateItemSection(item) {
  switch(item.product_type){
    case 'Hoteles':
    case 'Servicios':
    case 'Actividades':
      return generateAccommodationOrServiceSection(item);
    case 'Vuelos':
      return generateFlightSection(item);
    case 'Transporte':
      return generateTransportSection(item);
    default:
      // Optionally handle unknown types or return a default template
      console.warn(`Unknown item product_type: ${item.product_type}`);
      return generateAccommodationOrServiceSection(item); // Fallback to default view
  }
}
// Helper to generate accommodation, service, or activity section
function generateAccommodationOrServiceSection(item) {
  // Determine icon based on product type
  let iconType = 'bi-building'; // Default to hotel
  if (item.product_type === 'Servicios') {
    iconType = 'bi-briefcase';
  } else if (item.product_type === 'Actividades') {
    iconType = 'bi-compass'; // Use compass icon for activities
  }
  const scheduleSection = item.schedule && item.schedule.length > 0 ? `
    <div class="schedule-section">
        <div class="section-title">
            <i class="bi bi-calendar-check"></i>
            Itinerario detallado
        </div>
        
        ${item.schedule.map((scheduleItem)=>`
            <div class="schedule-item">
                ${scheduleItem.image ? `
                <img src="${getOptimizedImageUrl(scheduleItem.image, 150, 60)}" alt="" class="schedule-image">
                ` : ''}
                
                <div class="schedule-content">
                    <div class="schedule-title">${escapeHtml(scheduleItem.title || '')}</div>
                    <div class="schedule-description">${escapeHtml(scheduleItem.description || '')}</div>
                </div>
            </div>
        `).join('')}
    </div>
  ` : '';
  return `
    <div class="item">
        <div class="item-header">
            <div class="item-icon-wrapper">
                <div class="item-icon">
                    <i class="${iconType}"></i>
                </div>
            </div>
            
            <div class="item-title">
                <h3>${escapeHtml(item.product_name || '')}</h3>
                
                <div class="item-info">
                    <div class="item-info-detail">
                        <i class="bi bi-geo-alt"></i>
                        <span>${escapeHtml(item.destination || '')}</span>
                    </div>
                    
                    ${item.hotel_nights ? `
                    <div class="item-info-detail">
                        <i class="bi bi-moon"></i>
                        <span>${item.hotel_nights} ${item.hotel_nights === 1 ? 'noche' : 'noches'}</span>
                    </div>
                    ` : ''}
                    
                    <div class="item-info-detail">
                        <i class="bi bi-people"></i>
                        <span>${item.quantity || 1} ${item.quantity === 1 ? 'pasajero' : 'pasajeros'}</span>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="item-content">
            ${item.images && item.images.length > 0 ? `
            <div class="item-images">
                ${item.images.map((image, index)=>`
                <img src="${getOptimizedImageUrl(image, 300, 70)}" alt="Imagen ${index + 1}" class="item-image" onerror="this.style.display='none'">
                `).join('')}
            </div>
            ` : ''}
            
            ${item.description ? `
            <div class="item-description">
                ${escapeHtml(item.description).replace(/\\n/g, '<br>')}
            </div>
            ` : ''}
            
            <div class="inclusions-exclusions">
                ${item.inclutions ? `
                <div class="inclusions">
                    <div class="section-title">
                        <i class="bi bi-check-circle"></i>
                        Incluye
                    </div>
                    <ul class="inclusions-list">
                        ${createList(item.inclutions.replace(/\\n/g, '\n'))}
                    </ul>
                </div>
                ` : ''}
                
                <div class="exclusions-recommendations">
                    ${item.exclutions ? `
                    <div class="exclusions">
                        <div class="section-title">
                            <i class="bi bi-x-circle"></i>
                            No incluye
                        </div>
                        <ul class="exclusions-list">
                            ${createList(item.exclutions.replace(/\\n/g, '\n'))}
                        </ul>
                    </div>
                    ` : ''}
                    
                    ${item.recomendations ? `
                    <div class="recommendations" style="margin-top: 15px;">
                        <div class="section-title">
                            <i class="bi bi-star"></i>
                            Recomendaciones
                        </div>
                        <p>${escapeHtml(item.recomendations).replace(/\\n/g, '<br>')}</p>
                    </div>
                    ` : ''}
                </div>
            </div>
            
            ${scheduleSection}
            
            ${item.personalized_message ? `
            <div class="personalized-message">
                <i class="bi bi-envelope"></i> Mensaje personalizado: ${escapeHtml(item.personalized_message).replace(/\\n/g, '<br>')}
            </div>
            ` : ''}
        </div>
    </div>
  `;
}
// Helper to generate flight section
function generateFlightSection(item) {
  return `
    <div class="item">
        <div class="item-header">
            <div class="item-icon-wrapper">
                <div class="item-icon">
                    <i class="bi bi-airplane"></i>
                </div>
            </div>
            
            <div class="item-title">
                <h3>${escapeHtml(item.product_name)}</h3>
            </div>
        </div>
        
        <div class="flight-item-content">
            <div class="flight-details">
                ${item.main_image ? `
                <img src="${getOptimizedImageUrl(item.main_image, 150, 70)}" alt="Airline Logo" class="airline-logo">
                ` : ''}
                
                <div class="flight-route">
                    <div class="flight-point">
                        <div class="flight-iata">${escapeHtml(item.iata_departure || '')}</div>
                        <div class="flight-city">${escapeHtml(item.flight_departure?.split('-')[1] || '')}</div>
                        <div class="flight-time">${escapeHtml(item.departure_time || '')}</div>
                        <div class="flight-label">Salida</div>
                    </div>
                    
                    <div class="flight-middle">
                        <div class="flight-line"></div>
                    </div>
                    
                    <div class="flight-point">
                        <div class="flight-iata">${escapeHtml(item.iata_destination || '')}</div>
                        <div class="flight-city">${escapeHtml(item.flight_arrival?.split('-')[1] || '')}</div>
                        <div class="flight-time">${escapeHtml(item.arrival_time || '')}</div>
                        <div class="flight-label">Llegada</div>
                    </div>
                </div>
            </div>
        </div>
        
        ${item.personalized_message ? `
        <div class="item-content">
            <div class="personalized-message">
                <i class="bi bi-envelope"></i> Mensaje personalizado: ${escapeHtml(item.personalized_message).replace(/\\n/g, '<br>')}
            </div>
        </div>
        ` : ''}
    </div>
  `;
}
// Helper to generate transport section
function generateTransportSection(item) {
  return `
    <div class="item">
        <div class="item-header">
            <div class="item-icon-wrapper">
                <div class="item-icon">
                    <i class="bi bi-car-front"></i>
                </div>
            </div>
            
            <div class="item-title">
                <h3>${escapeHtml(item.product_name)}</h3>
                
                <div class="item-info">
                    <div class="item-info-detail">
                        <i class="bi bi-geo-alt"></i>
                        <span>${escapeHtml(item.destination)}</span>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="item-content" style="display: flex; align-items: flex-start;">
            ${item.main_image ? `
            <img src="${getOptimizedImageUrl(item.main_image, 120, 60)}" alt="" class="transport-image">
            ` : ''}
            
            <div style="flex: 1;">
                <div class="item-description">
                    <strong>${escapeHtml(item.rate_name || '')}</strong>
                </div>
                
                ${item.personalized_message ? `
                <div class="personalized-message">
                    <i class="bi bi-envelope"></i> Mensaje personalizado: ${escapeHtml(item.personalized_message).replace(/\\n/g, '<br>')}
                </div>
                ` : ''}
            </div>
        </div>
    </div>
  `;
}
// Helper function to calculate days between dates
function calculateDaysBetweenDates(startDate, endDate) {
  try {
    const start = new Date(startDate);
    const end = new Date(endDate);
    const diffTime = Math.abs(end.getTime() - start.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays + 1; // Include both start and end day
  } catch (e) {
    console.error('Error calculating days between dates:', e);
    return 1; // Default to 1 day to avoid division by zero
  }
}
