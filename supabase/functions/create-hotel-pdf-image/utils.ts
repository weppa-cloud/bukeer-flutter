// supabase/functions/generate-hotel-pdf/utils.ts
export const escapeHtml = (unsafe)=>{
  if (!unsafe) return '';
  return unsafe.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;');
};
export const createList = (text)=>{
  if (!text) return '<li class="na-item">N/A</li>';
  return text.split('\n').map((item)=>item.trim()).filter((item)=>item).map((item)=>`<li>${escapeHtml(item)}</li>`).join('');
};
// Helper para optimizar imágenes de Supabase Storage
export function getOptimizedImageUrl(url, maxWidth, quality = 90) {
  // Solo transforma si es una imagen de Supabase Storage
  const match = url.match(/(\/storage\/v1\/object\/public\/)([^?]+)/);
  if (!match) return url;
  const baseUrl = url.replace('/storage/v1/object/public/', '/storage/v1/render/image/public/');
  // Si se especifica un ancho máximo, usar resize=contain para preservar aspecto
  if (maxWidth) {
    return baseUrl + `?width=${maxWidth}&resize=contain&quality=${quality}`;
  } else {
    // Solo optimizar calidad, dejar que CSS maneje el tamaño
    return baseUrl + `?quality=${quality}`;
  }
}
