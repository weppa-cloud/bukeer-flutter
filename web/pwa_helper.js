// PWA Helper JavaScript for Bukeer
// Handles PWA installation and update management

let deferredPrompt = null;
let isInstalling = false;

// PWA Install functionality
window.installPWA = function() {
  return new Promise((resolve, reject) => {
    if (!deferredPrompt) {
      console.warn('PWA: No install prompt available');
      resolve(false);
      return;
    }

    if (isInstalling) {
      console.warn('PWA: Install already in progress');
      resolve(false);
      return;
    }

    isInstalling = true;

    deferredPrompt.prompt().then(() => {
      return deferredPrompt.userChoice;
    }).then((choiceResult) => {
      console.log('PWA: User choice:', choiceResult.outcome);
      
      if (choiceResult.outcome === 'accepted') {
        console.log('✅ PWA installed successfully');
        resolve(true);
        
        // Track installation
        if (window.gtag) {
          window.gtag('event', 'pwa_install', {
            'event_category': 'PWA',
            'event_label': 'Install Accepted'
          });
        }
      } else {
        console.log('❌ PWA installation declined');
        resolve(false);
      }
      
      deferredPrompt = null;
    }).catch((error) => {
      console.error('PWA: Install error:', error);
      reject(error);
    }).finally(() => {
      isInstalling = false;
    });
  });
};

// Check if app is installed
window.isPWAInstalled = function() {
  // Check if running in standalone mode
  const isStandalone = window.matchMedia('(display-mode: standalone)').matches;
  const isIOSStandalone = window.navigator.standalone === true;
  const isTWA = document.referrer.startsWith('android-app://');
  
  return isStandalone || isIOSStandalone || isTWA;
};

// Get device capabilities
window.getPWACapabilities = function() {
  const capabilities = {
    serviceWorker: 'serviceWorker' in navigator,
    webShare: 'share' in navigator,
    clipboard: 'clipboard' in navigator,
    notifications: 'Notification' in window,
    backgroundSync: 'serviceWorker' in navigator && 'sync' in window.ServiceWorkerRegistration.prototype,
    pushNotifications: 'serviceWorker' in navigator && 'PushManager' in window,
    cacheAPI: 'caches' in window,
    indexedDB: 'indexedDB' in window,
    localStorage: 'localStorage' in window,
    geolocation: 'geolocation' in navigator,
    camera: 'mediaDevices' in navigator && 'getUserMedia' in navigator.mediaDevices,
    fullscreen: 'requestFullscreen' in document.documentElement,
    deviceMemory: 'deviceMemory' in navigator ? navigator.deviceMemory : null,
    connection: 'connection' in navigator ? {
      effectiveType: navigator.connection.effectiveType,
      downlink: navigator.connection.downlink,
      rtt: navigator.connection.rtt
    } : null
  };
  
  return capabilities;
};

// Network status monitoring
let isOnline = navigator.onLine;
window.addEventListener('online', () => {
  isOnline = true;
  console.log('📶 PWA: Back online');
  if (window.onNetworkChange) {
    window.onNetworkChange(true);
  }
});

window.addEventListener('offline', () => {
  isOnline = false;
  console.log('📵 PWA: Gone offline');
  if (window.onNetworkChange) {
    window.onNetworkChange(false);
  }
});

window.isOnline = function() {
  return isOnline;
};

// Enhanced clipboard functionality
window.copyToClipboard = function(text) {
  return new Promise((resolve) => {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(text).then(() => {
        console.log('✅ Text copied to clipboard via Clipboard API');
        resolve(true);
      }).catch((error) => {
        console.warn('⚠️ Clipboard API failed, trying fallback:', error);
        resolve(fallbackCopyTextToClipboard(text));
      });
    } else {
      resolve(fallbackCopyTextToClipboard(text));
    }
  });
};

function fallbackCopyTextToClipboard(text) {
  try {
    const textArea = document.createElement('textarea');
    textArea.value = text;
    textArea.style.top = '0';
    textArea.style.left = '0';
    textArea.style.position = 'fixed';
    textArea.style.opacity = '0';
    
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();
    
    const successful = document.execCommand('copy');
    document.body.removeChild(textArea);
    
    if (successful) {
      console.log('✅ Text copied to clipboard via fallback');
      return true;
    } else {
      console.error('❌ Fallback copy failed');
      return false;
    }
  } catch (error) {
    console.error('❌ Copy to clipboard error:', error);
    return false;
  }
}

// Enhanced Web Share API
window.shareContent = function(data) {
  return new Promise((resolve) => {
    if (navigator.share) {
      navigator.share(data).then(() => {
        console.log('✅ Content shared successfully');
        resolve(true);
        
        if (window.gtag) {
          window.gtag('event', 'share', {
            'event_category': 'PWA',
            'method': 'web_share_api',
            'content_type': data.title || 'unknown'
          });
        }
      }).catch((error) => {
        console.warn('⚠️ Web Share API failed:', error);
        resolve(false);
      });
    } else {
      console.warn('⚠️ Web Share API not supported');
      resolve(false);
    }
  });
};

// Notification management
window.requestNotificationPermission = function() {
  return new Promise((resolve) => {
    if (!('Notification' in window)) {
      console.warn('⚠️ Notifications not supported');
      resolve('denied');
      return;
    }
    
    Notification.requestPermission().then((permission) => {
      console.log('🔔 Notification permission:', permission);
      resolve(permission);
    });
  });
};

window.showNotification = function(title, options = {}) {
  return new Promise((resolve) => {
    if (!('Notification' in window)) {
      console.warn('⚠️ Notifications not supported');
      resolve(false);
      return;
    }
    
    if (Notification.permission !== 'granted') {
      console.warn('⚠️ Notification permission not granted');
      resolve(false);
      return;
    }
    
    try {
      const notification = new Notification(title, {
        icon: '/icons/Icon-192.png',
        badge: '/icons/Icon-192.png',
        ...options
      });
      
      // Auto-close after 5 seconds
      setTimeout(() => {
        notification.close();
      }, 5000);
      
      resolve(true);
    } catch (error) {
      console.error('❌ Notification error:', error);
      resolve(false);
    }
  });
};

// Performance monitoring
window.getPWAPerformance = function() {
  const performance = window.performance;
  if (!performance) return null;
  
  const timing = performance.timing;
  const navigation = performance.navigation;
  
  return {
    loadTime: timing.loadEventEnd - timing.navigationStart,
    domContentLoaded: timing.domContentLoadedEventEnd - timing.navigationStart,
    firstPaint: performance.getEntriesByType('paint').find(entry => entry.name === 'first-paint')?.startTime || null,
    firstContentfulPaint: performance.getEntriesByType('paint').find(entry => entry.name === 'first-contentful-paint')?.startTime || null,
    navigationTiming: {
      redirectTime: timing.redirectEnd - timing.redirectStart,
      dnsTime: timing.domainLookupEnd - timing.domainLookupStart,
      connectTime: timing.connectEnd - timing.connectStart,
      requestTime: timing.responseEnd - timing.requestStart,
      responseTime: timing.responseEnd - timing.responseStart,
      domProcessingTime: timing.domContentLoadedEventStart - timing.domLoading,
      loadEventTime: timing.loadEventEnd - timing.loadEventStart
    },
    navigationType: navigation.type,
    redirectCount: navigation.redirectCount,
    memoryUsage: performance.memory ? {
      usedJSHeapSize: performance.memory.usedJSHeapSize,
      totalJSHeapSize: performance.memory.totalJSHeapSize,
      jsHeapSizeLimit: performance.memory.jsHeapSizeLimit
    } : null
  };
};

// Storage management
window.getStorageUsage = function() {
  return new Promise((resolve) => {
    if ('storage' in navigator && 'estimate' in navigator.storage) {
      navigator.storage.estimate().then((estimate) => {
        resolve({
          quota: estimate.quota,
          usage: estimate.usage,
          available: estimate.quota - estimate.usage,
          percentage: Math.round((estimate.usage / estimate.quota) * 100)
        });
      }).catch(() => {
        resolve(null);
      });
    } else {
      resolve(null);
    }
  });
};

// Clear app data
window.clearAppData = function() {
  return new Promise(async (resolve) => {
    try {
      // Clear cache storage
      if ('caches' in window) {
        const cacheNames = await caches.keys();
        await Promise.all(cacheNames.map(cacheName => caches.delete(cacheName)));
        console.log('✅ Cache storage cleared');
      }
      
      // Clear local storage
      if ('localStorage' in window) {
        localStorage.clear();
        console.log('✅ Local storage cleared');
      }
      
      // Clear session storage
      if ('sessionStorage' in window) {
        sessionStorage.clear();
        console.log('✅ Session storage cleared');
      }
      
      // Clear IndexedDB (if used)
      // This would need specific implementation based on usage
      
      console.log('✅ App data cleared successfully');
      resolve(true);
    } catch (error) {
      console.error('❌ Error clearing app data:', error);
      resolve(false);
    }
  });
};

// Initialize PWA helpers
console.log('🚀 PWA Helper initialized');
console.log('📊 PWA Capabilities:', window.getPWACapabilities());

// Export for debugging
window.PWAHelper = {
  installPWA: window.installPWA,
  isPWAInstalled: window.isPWAInstalled,
  getPWACapabilities: window.getPWACapabilities,
  isOnline: window.isOnline,
  copyToClipboard: window.copyToClipboard,
  shareContent: window.shareContent,
  requestNotificationPermission: window.requestNotificationPermission,
  showNotification: window.showNotification,
  getPWAPerformance: window.getPWAPerformance,
  getStorageUsage: window.getStorageUsage,
  clearAppData: window.clearAppData
};