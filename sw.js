/* Midnight Racing v40.2 - resilient service worker
   Optional files (such as audio) must never prevent the game page from opening. */
const CACHE_NAME = 'midnight-racing-v40-2-resilient';
const CORE_ASSETS = [
  './',
  './index.html',
  './manifest.webmanifest',
  './favicon-v36.ico',
  './favicon-32-v36.png',
  './favicon-48-v36.png',
  './icon-192-v36.png',
  './icon-512-v36.png',
  './apple-touch-icon-v36.png'
];
const OPTIONAL_ASSETS = [
  './audio/midnight-racing-loop.mp3',
  './audio/car-engine-loop.mp3'
];

async function cacheIfAvailable(cache, path) {
  try {
    const response = await fetch(path, { cache: 'reload' });
    if (response && response.ok) {
      await cache.put(path, response.clone());
    } else {
      console.info('[Midnight Racing] Optional cache item unavailable:', path, response && response.status);
    }
  } catch (error) {
    console.info('[Midnight Racing] Could not cache item:', path, error && error.message);
  }
}

self.addEventListener('install', event => {
  event.waitUntil((async () => {
    const cache = await caches.open(CACHE_NAME);
    // Each item is cached independently. A missing asset no longer aborts SW install.
    await Promise.all([...CORE_ASSETS, ...OPTIONAL_ASSETS].map(path => cacheIfAvailable(cache, path)));
    await self.skipWaiting();
  })());
});

self.addEventListener('activate', event => {
  event.waitUntil((async () => {
    const keys = await caches.keys();
    await Promise.all(keys
      .filter(key => key.startsWith('midnight-racing-') && key !== CACHE_NAME)
      .map(key => caches.delete(key)));
    await self.clients.claim();
  })());
});

self.addEventListener('fetch', event => {
  const request = event.request;
  if (request.method !== 'GET') return;
  const url = new URL(request.url);
  if (url.origin !== self.location.origin) return;

  event.respondWith((async () => {
    try {
      const response = await fetch(request);
      if (response && response.ok) {
        const cache = await caches.open(CACHE_NAME);
        cache.put(request, response.clone()).catch(() => {});
      }
      return response;
    } catch (error) {
      const cached = await caches.match(request);
      if (cached) return cached;
      if (request.mode === 'navigate') {
        const appShell = await caches.match('./index.html');
        if (appShell) return appShell;
      }
      return new Response('Midnight Racing could not load this file. Check your connection and refresh.', {
        status: 503,
        headers: { 'Content-Type': 'text/plain; charset=utf-8' }
      });
    }
  })());
});
