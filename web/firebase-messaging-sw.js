
// TODO: CONFIGURAÇÃO MANUAL NECESSÁRIA
// Este arquivo configura o service worker para Firebase Cloud Messaging
// Para configurar completamente:
// 1. Substitua os valores de configuração do Firebase pelos seus reais
// 2. Obtenha as configurações em: https://console.firebase.google.com/
// 3. Vá em Project Settings > General > Your apps > Web app

importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

// Configuração do Firebase - SUBSTITUA PELOS SEUS VALORES REAIS
const firebaseConfig = {
  apiKey: 'AIzaSyDYRiY8PFOZUXHMHHk1Qz8dGADec3VEeEs',
  appId: '1:144904912696:web:ca3a13aed2e8dc59e94bcd',
  messagingSenderId: '144904912696',
  projectId: 'mindfit-72a7c',
  authDomain: 'mindfit-72a7c.firebaseapp.com',
  storageBucket: 'mindfit-72a7c.firebasestorage.app',
};

// Inicializar Firebase
firebase.initializeApp(firebaseConfig);

// Recuperar uma instância do Firebase Messaging para que possa lidar com mensagens em segundo plano
const messaging = firebase.messaging();

// Manipular mensagens em segundo plano
messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  
  // Personalizar a notificação aqui
  const notificationTitle = payload.notification?.title || 'MindFit';
  const notificationOptions = {
    body: payload.notification?.body || 'Nova notificação do MindFit',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: 'mindfit-notification',
    requireInteraction: false,
    actions: [
      {
        action: 'open',
        title: 'Abrir App'
      },
      {
        action: 'close',
        title: 'Fechar'
      }
    ]
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});

// Manipular cliques nas notificações
self.addEventListener('notificationclick', function(event) {
  console.log('[firebase-messaging-sw.js] Notification click received.');

  event.notification.close();

  if (event.action === 'open') {
    // Abrir ou focar na janela do app
    event.waitUntil(
      clients.matchAll({ type: 'window', includeUncontrolled: true }).then(function(clientList) {
        for (var i = 0; i < clientList.length; i++) {
          var client = clientList[i];
          if (client.url.includes(self.location.origin) && 'focus' in client) {
            return client.focus();
          }
        }
        if (clients.openWindow) {
          return clients.openWindow('/');
        }
      })
    );
  }
});
