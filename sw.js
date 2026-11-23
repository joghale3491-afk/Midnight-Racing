const CACHE_NAME = 'midnight-racing-v39-1-time-attack-supabase-fix-1';
const APP_SHELL = [
  './', './index.html', './manifest.webmanifest',
  './favicon-v36.ico', './favicon.ico', './favicon-32-v36.png', './favicon-48-v36.png',
  './icon-192-v36.png', './icon-512-v36.png', './apple-touch-icon-v36.png',
  './audio/midnight-racing-loop.mp3', './audio/car-engine-loop.mp3'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(APP_SHELL))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', event => {
  const request = event.request;
  if (request.method !== 'GET' || new URL(request.url).origin !== self.location.origin) return;
  event.respondWith(
    fetch(request).then(response => {
      if (response && response.ok) {
        const copy = response.clone();
        caches.open(CACHE_NAME).then(cache => cache.put(request, copy));
      }
      return response;
    }).catch(() => caches.match(request).then(cached => cached || caches.match('./index.html')))
  );
});
