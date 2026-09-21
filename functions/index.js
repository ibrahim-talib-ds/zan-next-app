const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

/**
 * Fires when a new document is created in `notifications/{docId}`.
 * Sends a push to the target user's FCM token.
 */
exports.sendNotificationOnCreate = functions.firestore
  .document('notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    const data = snap.data() || {};
    const notificationId = context.params.notificationId;

    const title = data.title || 'ZanNext';
    const body = data.notification_text || '';
    const userRef = data.user_ref;
    const productId = data.product_id || '';

    if (!userRef) {
      console.log('⚠️ No user_ref on notification ' + notificationId);
      return null;
    }

    const userSnap = await userRef.get();
    if (!userSnap.exists) {
      console.log('⚠️ Missing user doc: ' + userRef.path);
      return null;
    }
    const fcmToken = userSnap.get('fcm_token');
    if (!fcmToken) {
      console.log('⚠️ No fcm_token for ' + userRef.path);
      return null;
    }

    // ── Decide deep-link route based on content ──
    let route = '/notification';
    if (productId) {
      route = '/productDetails';
    } else if (title.toLowerCase().includes('message')) {
      route = '/messagelist';
    } else if (title.toLowerCase().includes('order')) {
      route = '/order_details';
    }

    const message = {
      token: fcmToken,
      notification: {
        title: title,
        body: body,
      },
      data: {
        notificationId: notificationId,
        route: route,
        productId: String(productId || ''),
      },
      android: {
        priority: 'high',
        notification: {
          channelId: 'zannext_default',
          sound: 'default',
        },
      },
      webpush: {
        notification: {
          icon: '/icons/Icon-192.png',
          badge: '/icons/Icon-192.png',
        },
        fcmOptions: {
          link: '/#' + route,
        },
      },
    };

    try {
      const response = await admin.messaging().send(message);
      console.log('✅ Push sent → ' + route + ' (' + response + ')');
      return response;
    } catch (e) {
      console.error('❌ Push error for ' + userRef.path + ':', e);
      return null;
    }
  });
