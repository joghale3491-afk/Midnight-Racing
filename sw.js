const CACHE="midnight-racing-v19-race-start-fix";
const CORE=["./","./index.html","./manifest.webmanifest","./icon-192.svg","./icon-512.svg"];
self.addEventListener("install",e=>{self.skipWaiting();e.waitUntil(caches.open(CACHE).then(c=>c.addAll(CORE)));});
self.addEventListener("activate",e=>e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x!==CACHE).map(x=>caches.delete(x)))).then(()=>self.clients.claim())));
self.addEventListener("fetch",e=>{if(e.request.method!=="GET")return;e.respondWith(fetch(e.request).then(r=>{if(r.ok&&new URL(e.request.url).origin===location.origin){const c=r.clone();caches.open(CACHE).then(x=>x.put(e.request,c));}return r;}).catch(()=>caches.match(e.request).then(h=>h||caches.match("./index.html"))));});
