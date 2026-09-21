// ─── Firebase Cloud Messaging — web service worker ──────────────
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyBN9eBEJkmF4eQhONzkIAPRRTLfsGbOuT4",
  authDomain: "zannext-f6ff1.firebaseapp.com",
  projectId: "zannext-f6ff1",
  storageBucket: "zannext-f6ff1.firebasestorage.app",
  messagingSenderId: "129014154360",
  appId: "1:129014154360:web:8c1839a9595df16a2f598d",
  measurementId: "G-BW73Y9LKHM",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('[SW] Background push:', payload);
  const n = payload.notification || {};
  const d = payload.data || {};

  self.registration.showNotification(n.title || 'ZanNext', {
    body: n.body || 'New notification',
    icon: n.icon || '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    data: d,
    tag: d.notificationId || undefined,
  });
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const data = event.notification.data || {};
  const route = data.route || '/notification';
  const url = `${self.location.origin}/#${route}`;

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((list) => {
      for (const client of list) {
        if (client.url.includes(self.location.origin) && 'focus' in client) {
          client.focus();
          client.postMessage({ route, data });
          return;
        }
      }
      if (clients.openWindow) return clients.openWindow(url);
    })
  );
});
