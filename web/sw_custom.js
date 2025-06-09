// Custom Service Worker for Bukeer PWA
// Extends Flutter's default service worker with additional PWA features

const CACHE_NAME = 'bukeer-pwa-v2.0.0';
const APP_SHELL_CACHE = 'bukeer-app-shell-v2.0.0';
const API_CACHE = 'bukeer-api-cache-v2.0.0';
const STATIC_CACHE = 'bukeer-static-v2.0.0';

// App shell files that should always be cached
const APP_SHELL_FILES = [
  '/',
  '/index.html',
  '/manifest.json',
  '/config.js',
  '/pwa_helper.js',
  '/icons/Icon-192.png',
  '/icons/Icon-512.png',
  '/favicon.png'
];

// Static resources to cache
const STATIC_FILES = [
  '/assets/fonts/Outfit-SemiBold.ttf',
  '/assets/images/Logo-Bukeer-02.png',
  '/assets/images/Logo-Bukeer-FullBlanco-03.png'
];

// API endpoints to cache with specific strategies
const API_PATTERNS = [
  /^https:\/\/wzlxbpicdcdvxvdcvgas\.supabase\.co\/rest\/v1\/.*$/,
  /^https:\/\/maps\.googleapis\.com\/maps\/api\/.*$/
];

// Install event - cache app shell and static files
self.addEventListener('install', (event) => {
  console.log('🔧 Service Worker: Installing...');
  
  event.waitUntil(
    Promise.all([
      // Cache app shell
      caches.open(APP_SHELL_CACHE).then((cache) => {
        console.log('📦 Service Worker: Caching app shell');
        return cache.addAll(APP_SHELL_FILES);
      }),
      
      // Cache static files
      caches.open(STATIC_CACHE).then((cache) => {
        console.log('📦 Service Worker: Caching static files');
        return cache.addAll(STATIC_FILES.filter(file => file)); // Filter out empty files
      })
    ]).then(() => {
      console.log('✅ Service Worker: Installation complete');
      return self.skipWaiting(); // Activate immediately
    }).catch((error) => {
      console.error('❌ Service Worker: Installation failed:', error);
    })
  );
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
  console.log('🚀 Service Worker: Activating...');
  
  const cacheWhitelist = [CACHE_NAME, APP_SHELL_CACHE, API_CACHE, STATIC_CACHE];
  
  event.waitUntil(
    Promise.all([
      // Clean up old caches
      caches.keys().then((cacheNames) => {
        return Promise.all(
          cacheNames.map((cacheName) => {
            if (!cacheWhitelist.includes(cacheName)) {
              console.log('🗑️ Service Worker: Deleting old cache:', cacheName);
              return caches.delete(cacheName);
            }
          })
        );
      }),
      
      // Take control of all clients immediately
      self.clients.claim()
    ]).then(() => {
      console.log('✅ Service Worker: Activation complete');
    })
  );
});

// Fetch event - implement caching strategies
self.addEventListener('fetch', (event) => {
  const request = event.request;
  const url = new URL(request.url);
  
  // Skip non-GET requests
  if (request.method !== 'GET') {
    return;
  }
  
  // Skip Chrome extensions and other non-http requests
  if (!request.url.startsWith('http')) {
    return;
  }
  
  event.respondWith(handleFetch(request, url));
});

async function handleFetch(request, url) {
  try {
    // Strategy 1: App Shell - Cache First
    if (isAppShellRequest(url)) {
      return await cacheFirst(request, APP_SHELL_CACHE);
    }
    
    // Strategy 2: Static Assets - Cache First
    if (isStaticAsset(url)) {
      return await cacheFirst(request, STATIC_CACHE);
    }
    
    // Strategy 3: API Calls - Network First with Cache Fallback
    if (isApiRequest(url)) {
      return await networkFirstWithCache(request, API_CACHE);
    }
    
    // Strategy 4: Navigation - Cache with Network Fallback
    if (request.mode === 'navigate') {
      return await cacheWithNetworkFallback(request, APP_SHELL_CACHE);
    }
    
    // Strategy 5: Everything else - Network First
    return await networkFirst(request);
    
  } catch (error) {
    console.error('❌ Service Worker: Fetch error:', error);
    return await handleFetchError(request, error);
  }
}

// Check if request is for app shell
function isAppShellRequest(url) {
  return APP_SHELL_FILES.some(file => url.pathname.endsWith(file) || url.pathname === file);
}

// Check if request is for static assets
function isStaticAsset(url) {
  const pathname = url.pathname;
  return pathname.includes('/assets/') || 
         pathname.includes('/icons/') ||
         pathname.endsWith('.png') ||
         pathname.endsWith('.jpg') ||
         pathname.endsWith('.jpeg') ||
         pathname.endsWith('.gif') ||
         pathname.endsWith('.svg') ||
         pathname.endsWith('.ttf') ||
         pathname.endsWith('.woff') ||
         pathname.endsWith('.woff2');
}

// Check if request is for API
function isApiRequest(url) {
  return API_PATTERNS.some(pattern => pattern.test(url.href));
}

// Caching Strategy: Cache First
async function cacheFirst(request, cacheName) {
  const cache = await caches.open(cacheName);
  const cachedResponse = await cache.match(request);
  
  if (cachedResponse) {
    // Return from cache
    return cachedResponse;
  }
  
  // Fetch from network and cache
  try {
    const networkResponse = await fetch(request);
    if (networkResponse.ok) {
      cache.put(request, networkResponse.clone());
    }
    return networkResponse;
  } catch (error) {
    console.warn('⚠️ Cache First: Network failed:', error);
    throw error;
  }
}

// Caching Strategy: Network First with Cache Fallback
async function networkFirstWithCache(request, cacheName) {
  const cache = await caches.open(cacheName);
  
  try {
    const networkResponse = await fetch(request);
    
    // Cache successful responses
    if (networkResponse.ok) {
      // Only cache GET requests
      if (request.method === 'GET') {
        cache.put(request, networkResponse.clone());
      }
    }
    
    return networkResponse;
  } catch (error) {
    console.warn('⚠️ Network First: Network failed, trying cache:', error);
    
    // Try cache fallback
    const cachedResponse = await cache.match(request);
    if (cachedResponse) {
      return cachedResponse;
    }
    
    throw error;
  }
}

// Caching Strategy: Cache with Network Fallback (for navigation)
async function cacheWithNetworkFallback(request, cacheName) {
  const cache = await caches.open(cacheName);
  
  // First try cache
  const cachedResponse = await cache.match('/index.html');
  if (cachedResponse) {
    return cachedResponse;
  }
  
  // Fallback to network
  try {
    const networkResponse = await fetch(request);
    if (networkResponse.ok) {
      cache.put('/index.html', networkResponse.clone());
    }
    return networkResponse;
  } catch (error) {
    console.error('❌ Cache with Network Fallback: Both failed:', error);
    throw error;
  }
}

// Caching Strategy: Network First (no cache)
async function networkFirst(request) {
  return await fetch(request);
}

// Handle fetch errors
async function handleFetchError(request, error) {
  // For navigation requests, return the cached app shell
  if (request.mode === 'navigate') {
    const cache = await caches.open(APP_SHELL_CACHE);
    const cachedResponse = await cache.match('/index.html');
    if (cachedResponse) {
      return cachedResponse;
    }
  }
  
  // For other requests, return a generic error response
  return new Response(
    JSON.stringify({
      error: 'Network error',
      message: 'Unable to fetch resource',
      offline: true
    }),
    {
      status: 503,
      statusText: 'Service Unavailable',
      headers: {
        'Content-Type': 'application/json'
      }
    }
  );
}

// Handle background sync
self.addEventListener('sync', (event) => {
  console.log('🔄 Service Worker: Background sync:', event.tag);
  
  if (event.tag === 'bukeer-sync') {
    event.waitUntil(handleBackgroundSync());
  }
});

async function handleBackgroundSync() {
  try {
    // Implement background sync logic here
    // For example, sync offline data when back online
    console.log('🔄 Service Worker: Performing background sync');
    
    // Get pending sync data from IndexedDB or localStorage
    // Sync with Supabase when online
    
  } catch (error) {
    console.error('❌ Service Worker: Background sync failed:', error);
  }
}

// Handle push notifications
self.addEventListener('push', (event) => {
  console.log('📨 Service Worker: Push notification received');
  
  const options = {
    body: event.data ? event.data.text() : 'Nueva notificación de Bukeer',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    data: {
      url: '/' // URL to open when notification is clicked
    }
  };
  
  event.waitUntil(
    self.registration.showNotification('Bukeer', options)
  );
});

// Handle notification clicks
self.addEventListener('notificationclick', (event) => {
  console.log('🔔 Service Worker: Notification clicked');
  
  event.notification.close();
  
  const url = event.notification.data?.url || '/';
  
  event.waitUntil(
    clients.openWindow(url)
  );
});

// Handle messages from the app
self.addEventListener('message', (event) => {
  console.log('💬 Service Worker: Message received:', event.data);
  
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
  
  if (event.data && event.data.type === 'GET_CACHE_NAMES') {
    event.ports[0].postMessage({
      cacheNames: [CACHE_NAME, APP_SHELL_CACHE, API_CACHE, STATIC_CACHE]
    });
  }
  
  if (event.data && event.data.type === 'CLEAR_CACHE') {
    event.waitUntil(
      caches.keys().then((cacheNames) => {
        return Promise.all(
          cacheNames.map((cacheName) => caches.delete(cacheName))
        );
      }).then(() => {
        event.ports[0].postMessage({ success: true });
      })
    );
  }
});

console.log('🚀 Bukeer Service Worker loaded successfully');