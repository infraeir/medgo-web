'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"index.html": "a204ea366e05cbd412c46db0e5049829",
"/": "a204ea366e05cbd412c46db0e5049829",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"manifest.json": "d99dacd1b7eb12ea44165afffb84b2e2",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "131ff962ac8cea752506430192012df9",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor-Light.ttf": "f2dc1cd993671b155e3235044280ba47",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor-Bold.ttf": "8fedcf7067a22a2a320214168689b05c",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor-Duotone.ttf": "c48df336708c750389fa8d06ec830dab",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor-Thin.ttf": "f128e0009c7b98aba23cafe9c2a5eb06",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor.ttf": "003d691b53ee8fab57d5db497ddc54db",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor-Fill.ttf": "5d304fa130484129be6bf4b79a675638",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/FontManifest.json": "56ff5109d95d11bd538d380a7d3deb60",
"assets/AssetManifest.bin.json": "efb1abd2ff1ad1688ca9ef10be5b7a10",
"assets/assets/animations/looping.json": "a4fbdef7e30140ebc9235af6c9044003",
"assets/assets/icons/US-CDC.svg": "39928dd94ec27323ca5ae35409fe13ad",
"assets/assets/icons/similar.svg": "2f1e515dea316cf28041ed4c8dbba8d7",
"assets/assets/icons/reference.svg": "cd4a298ae13a2369428ed13ee45e3654",
"assets/assets/icons/WHO.svg": "4dc134bff2729dc63834d5c550276dca",
"assets/assets/icons/SBIM.svg": "98d78a447b485d9611df8ed79dcd5d05",
"assets/assets/icons/generic.svg": "42ed96a5a4fcdbe2116323787b8b26eb",
"assets/assets/icons/sus.svg": "1ea6477cfd108985db45beb79967b624",
"assets/assets/icons/popular.png": "b5fc1668bfadb0ed71d2f8640b13102e",
"assets/assets/icons/ref.svg": "cd4a298ae13a2369428ed13ee45e3654",
"assets/assets/icons/popularPharmacy.svg": "0412ab0e1ba9a74efb62a7c7b0ec98d6",
"assets/assets/icons/popular.svg": "b2323402ac139536fc7fb1ac30bdcf84",
"assets/assets/icons/sus_shadow.svg": "be5f8091727a72a16cfc8aca374b8ee7",
"assets/assets/icons/SBP.svg": "671b528889fb7ef128be3b155b1114e5",
"assets/assets/icons/MS.svg": "260601d16046e1be97b65090115b7c7b",
"assets/assets/icons/Logo.svg": "f81f8f9a1b668ac82f44665fccd10fca",
"assets/assets/images/Logo100.svg": "24bf71e28e0f007942f815c6dbdef760",
"assets/assets/images/info@3x.png": "ebec67babb3d1efc6e1358fc3abac595",
"assets/assets/images/image_empty.svg": "4c5a3f71bb51b298c541334708404024",
"assets/assets/images/info@1x.png": "1d4aa97ef05e0d6fa01fd6cddb028cb5",
"assets/assets/images/Logo@1x.png": "8115b87c1b540e10e568185c5e6c489b",
"assets/assets/images/check@1x.png": "3ad19b9e3a351ab1f147926d590e0327",
"assets/assets/images/check@2x.png": "838bc2a5858011b9b60541c50397c287",
"assets/assets/images/Logo_1.png": "57023f2b7407ebb620c83a01e8f90115",
"assets/assets/images/check@3x.png": "34725228cae86aef1425ce6c72621361",
"assets/assets/images/info@2x.png": "6318dc1a462702827d3de420127b3887",
"assets/assets/images/Logo@2x.png": "998661eb9f8fe7e1e21a0cd1652cdb24",
"assets/assets/images/empty.svg": "7f346de64b351b05e4200a0805dc6e16",
"assets/assets/images/Logo@3x.png": "7305684c1e281b5b07fe04a22a7f5b27",
"assets/assets/images/Logo_500.svg": "a2550e9814b5efb976d3b3e54a1305ec",
"assets/assets/images/logo_medgo.svg": "16b3d32594955a7eda9d15c627ffe3b3",
"assets/assets/images/Logo.png": "a79b172b31afa2d0ddd62ed0b58c1541",
"assets/assets/images/logo_svg_medgo.svg": "ea563df0cc8d64cf1e95d5cd97257633",
"assets/assets/fonts/AtkinsonHyperlegible-Regular.ttf": "28147924c6c58c46f245a75ebf336a53",
"assets/AssetManifest.bin": "10857a33950de5d8973ad8236c398a8c",
"assets/NOTICES": "0070a08c0de912ba42703b4705231ee2",
"assets/fonts/MaterialIcons-Regular.otf": "2dbc6be6bb1488a98312852d698f4c6d",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"main.dart.js": "069424e791b8fa3f2bfd81247444b601",
"version.json": "b07183ecc90befbf2627b2a6b09ae7f1",
"flutter_bootstrap.js": "684325956fd2145e88ef815a6ce853f7",
"Logo.png": "a79b172b31afa2d0ddd62ed0b58c1541"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
