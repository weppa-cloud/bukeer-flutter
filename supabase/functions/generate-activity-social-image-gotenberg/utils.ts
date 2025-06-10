// supabase/functions/generate-activity-social-image-gotenberg/utils.ts
export const escapeHtml = (unsafe)=>{
  if (!unsafe) return '';
  return unsafe.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;');
};
export const createList = (text)=>{
  if (!text) return '<li class="na-item">N/A</li>';
  return text.split('\n').map((item)=>item.trim()).filter((item)=>item).map((item)=>`<li>${escapeHtml(item)}</li>`).join('');
};
// Helper para optimizar imágenes de Supabase Storage
export function getOptimizedImageUrl(url, width = 800, quality = 70) {
  if (!url) return `https://via.placeholder.com/${width}x${Math.floor(width * 0.75)}.png?text=No+Image`;
  try {
    // Si la URL ya contiene ?width o ?height, asumimos que ya está optimizada
    if (url.includes('?width=') || url.includes('?height=')) return url;
    // Solo aplicamos optimización a imágenes de Supabase Storage
    if (!url.includes('/storage/v1/object/public/')) return url;
    return url.replace('/storage/v1/object/public/', '/storage/v1/render/image/public/') + `?width=${width}&quality=${quality}`;
  } catch (error) {
    console.error("Error optimizing image URL:", error);
    return `https://via.placeholder.com/${width}x${Math.floor(width * 0.75)}.png?text=Error`;
  }
}
