// Service Worker Registration for Bukeer PWA
// Handles registration of both Flutter's service worker and custom PWA features

(function() {
  'use strict';

  if (!('serviceWorker' in navigator)) {
    console.warn('⚠️ Service Worker not supported');
    return;
  }

  let swRegistration = null;
  let isUpdateAvailable = false;

  // Register service worker after Flutter is ready
  window.addEventListener('flutter-first-frame', function() {
    registerServiceWorker();
  });

  async function registerServiceWorker() {
    try {
      console.log('🔧 Registering service worker...');
      
      // Register Flutter's service worker with custom scope
      swRegistration = await navigator.serviceWorker.register('/flutter_service_worker.js', {
        scope: '/'
      });

      console.log('✅ Service Worker registered:', swRegistration.scope);

      // Set up update detection
      swRegistration.addEventListener('updatefound', handleUpdateFound);
      
      // Check for updates periodically
      setInterval(checkForUpdates, 30 * 60 * 1000); // Check every 30 minutes
      
      // Handle service worker state changes
      if (swRegistration.installing) {
        trackServiceWorkerState(swRegistration.installing);
      }
      
      if (swRegistration.waiting) {
        isUpdateAvailable = true;
        notifyUpdateAvailable();
      }
      
      if (swRegistration.active) {
        console.log('✅ Service Worker is active');
      }

    } catch (error) {
      console.error('❌ Service Worker registration failed:', error);
    }
  }

  function handleUpdateFound() {
    console.log('🔄 Service Worker update found');
    const newWorker = swRegistration.installing;
    
    if (newWorker) {
      trackServiceWorkerState(newWorker);
    }
  }

  function trackServiceWorkerState(worker) {
    worker.addEventListener('statechange', function() {
      console.log('🔄 Service Worker state changed:', worker.state);
      
      if (worker.state === 'installed') {
        if (navigator.serviceWorker.controller) {
          // New worker is installed, update available
          isUpdateAvailable = true;
          notifyUpdateAvailable();
        } else {
          // First install
          console.log('✅ Service Worker installed for the first time');
          notifyInstallSuccess();
        }
      }
      
      if (worker.state === 'activated') {
        console.log('✅ Service Worker activated');
      }
    });
  }

  function notifyUpdateAvailable() {
    console.log('🔄 New version available');
    
    // Notify Flutter app about update
    if (window.showUpdateNotification) {
      window.showUpdateNotification();
    }
    
    // Show browser notification if permission granted
    if (Notification.permission === 'granted') {
      new Notification('Bukeer - Actualización disponible', {
        body: 'Una nueva versión está lista. Recarga para actualizar.',
        icon: '/icons/Icon-192.png',
        tag: 'app-update'
      });
    }
  }

  function notifyInstallSuccess() {
    console.log('🎉 PWA installed successfully');
    
    // Track installation
    if (window.gtag) {
      window.gtag('event', 'pwa_first_install', {
        'event_category': 'PWA',
        'event_label': 'First Time Install'
      });
    }
  }

  async function checkForUpdates() {
    if (!swRegistration) return;
    
    try {
      console.log('🔍 Checking for updates...');
      await swRegistration.update();
    } catch (error) {
      console.warn('⚠️ Update check failed:', error);
    }
  }

  // Expose update functionality globally
  window.updateServiceWorker = function() {
    if (!swRegistration || !swRegistration.waiting) {
      console.warn('⚠️ No service worker update available');
      return Promise.resolve(false);
    }

    return new Promise((resolve) => {
      const messageChannel = new MessageChannel();
      
      messageChannel.port1.onmessage = function(event) {
        if (event.data.error) {
          console.error('❌ Service Worker update failed:', event.data.error);
          resolve(false);
        } else {
          console.log('✅ Service Worker updated successfully');
          resolve(true);
        }
      };

      // Tell the waiting service worker to skip waiting and become active
      swRegistration.waiting.postMessage({type: 'SKIP_WAITING'}, [messageChannel.port2]);
    });
  };

  // Expose service worker info
  window.getServiceWorkerInfo = function() {
    if (!swRegistration) return null;
    
    return {
      scope: swRegistration.scope,
      updateViaCache: swRegistration.updateViaCache,
      installing: !!swRegistration.installing,
      waiting: !!swRegistration.waiting,
      active: !!swRegistration.active,
      isUpdateAvailable: isUpdateAvailable
    };
  };

  // Handle messages from service worker
  navigator.serviceWorker.addEventListener('message', function(event) {
    console.log('💬 Message from Service Worker:', event.data);
    
    if (event.data.type === 'CACHE_UPDATED') {
      console.log('📦 Cache updated:', event.data.cacheName);
    }
    
    if (event.data.type === 'OFFLINE_FALLBACK') {
      console.log('📵 Serving offline fallback');
      // Notify app about offline state
      if (window.onNetworkChange) {
        window.onNetworkChange(false);
      }
    }
  });

  // Handle page visibility changes to check for updates
  document.addEventListener('visibilitychange', function() {
    if (!document.hidden && swRegistration) {
      checkForUpdates();
    }
  });

  // Handle online/offline events
  window.addEventListener('online', function() {
    console.log('📶 Back online - checking for updates');
    if (swRegistration) {
      checkForUpdates();
    }
  });

  console.log('🚀 Service Worker registration script loaded');

})();