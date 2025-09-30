const CACHE_NAME = 'suidhaga-cache-v1';
const urlsToCache = [
  '/',
  '/manifest.json',
  '/icons/icon-192x192.png',
  '/icons/icon-512x512.png'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        const cachePromises = urlsToCache.map(url => {
          return fetch(url)
            .then(response => {
              if (!response.ok) {
                throw new Error(`Failed to cache ${url}: ${response.status}`);
              }
              return cache.put(url, response);
            })
            .catch(error => {
              console.error(`Failed to cache ${url}: ${error.message}`);
              return Promise.resolve();
            });
        });

        return Promise.all(cachePromises);
      })
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        if (response) {
          return response;
        }
        return fetch(event.request).then(
          response => {
            if(!response || !response.ok) {
              return response;
            }
            const responseToCache = response.clone();

            caches.open(CACHE_NAME)
              .then(cache => {
                cache.put(event.request, responseToCache);
              });

            return response;
          }
        ).catch(error => {
          console.error('Fetch failed:', error);
        });
      })
  );
});
