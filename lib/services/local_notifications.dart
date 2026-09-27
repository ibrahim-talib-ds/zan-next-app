import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Central place for Android/iOS local notification setup.
/// Used to render FOREGROUND FCM messages as real OS banners.
class LocalNotifications {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'zannext_high_importance';
  static const String channelName = 'ZanNext Notifications';
  static const String channelDesc =
      'Orders, messages, and important updates from ZanNext';

  static bool _initialized = false;

  /// Call once at app startup.
  static Future<void> init({
    void Function(NotificationResponse)? onTap,
  }) async {
    if (_initialized) return;

    // Android
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS / macOS
    const darwinInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );

    // v22: all params are named
    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (resp) {
        if (onTap != null) onTap(resp);
      },
    );

    // Create the high-importance channel (Android 8+)
    const androidChannel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDesc,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      showBadge: true,
    );

    final androidImpl =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImpl != null) {
      await androidImpl.createNotificationChannel(androidChannel);
      // Ask for runtime permission (Android 13+)
      await androidImpl.requestNotificationsPermission();
      debugPrint('🔔 Channel created: $channelId');
    }

    _initialized = true;
  }

  /// Show a notification in the OS tray (used for foreground FCM).
  static Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) {
      debugPrint('🔔 LocalNotifications.show called before init()');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    // v22: all params are named
    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  /// Cancel all visible notifications.
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
