// supabase/functions/generate-itinerary-pdf/utils.ts
export const escapeHtml = (unsafe)=>{
  if (!unsafe) return '';
  return unsafe.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;');
};
export const formatDate = (dateStr, locale = 'es')=>{
  if (!dateStr) return '';
  try {
    const date = new Date(dateStr);
    return date.toLocaleDateString(locale, {
      day: 'numeric',
      month: 'short',
      year: 'numeric'
    });
  } catch (e) {
    console.error('Error formatting date:', e);
    return dateStr;
  }
};
export const formatCurrency = (value, currency = 'USD')=>{
  if (value === null || value === undefined) return '';
  try {
    // Replace , with . as decimal separator for proper formatting
    const roundedValue = Math.round(value * 10) / 10;
    // Format the number with . for thousands and , for decimals as per Colombian format
    const formatted = roundedValue.toLocaleString('es-CO', {
      minimumFractionDigits: 1,
      maximumFractionDigits: 1
    });
    return formatted;
  } catch (e) {
    console.error('Error formatting currency:', e);
    return value.toString();
  }
};
export const createList = (text)=>{
  if (!text) return '';
  // Split by newlines or by commas
  const items = text.includes('\n') ? text.split('\n') : text.split(',');
  return items.map((item)=>item.trim()).filter((item)=>item) // Remove empty items
  .map((item)=>`<li>${escapeHtml(item)}</li>`).join('');
};
// Helper to optimize images from Supabase Storage
export function getOptimizedImageUrl(url, width = 800, quality = 80) {
  if (!url) return '';
  // Asegurar que la URL sea segura para usar
  try {
    // Si la URL comienza con http, asumimos que es válida
    if (url.startsWith('http')) {
      // Solo optimizar URLs de Supabase Storage
      const match = url.match(/(\/storage\/v1\/object\/public\/)([^?]+)/);
      if (!match) return url;
      // Si es una URL de Supabase Storage, cambiar para usar renderización optimizada
      return url.replace('/storage/v1/object/public/', '/storage/v1/render/image/public/') + `?width=${width}&quality=${quality}`;
    } else {
      // No es una URL completa, podría ser una ruta relativa
      console.log(`URL no optimizable: ${url}`);
      return url;
    }
  } catch (e) {
    console.warn('Error al optimizar URL de imagen:', e);
    return url || '';
  }
}
// Parse a date range to get number of days
export function calculateDays(startDate, endDate) {
  try {
    const start = new Date(startDate);
    const end = new Date(endDate);
    const diffTime = Math.abs(end.getTime() - start.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays + 1; // Include both start and end day
  } catch (e) {
    console.error('Error calculating days:', e);
    return 0;
  }
}
// Format itinerary date for display in date header
export function formatItineraryDate(date) {
  if (!date) return '';
  try {
    const dateObj = new Date(date);
    // List of abbreviated months in Spanish
    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    // Format: DD Mes YYYY (ej: 27 Feb 2025)
    return `${dateObj.getDate()} ${months[dateObj.getMonth()]} ${dateObj.getFullYear()}`;
  } catch (e) {
    console.error('Error formatting itinerary date:', e);
    return date;
  }
}
// Group itinerary items by date
export function groupItemsByDate(items) {
  const groups = {};
  items.forEach((item)=>{
    const date = item.date || 'Sin fecha';
    if (!groups[date]) {
      groups[date] = [];
    }
    groups[date].push(item);
  });
  return groups;
}
