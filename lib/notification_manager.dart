// notification_manager.dart
import 'dart:developer';
import 'package:experta/core/app_export.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  PrefUtils prefUtils = PrefUtils();

  // Initialize notifications
  Future<void> init() async {
    log("Initializing NotificationManager...");

    try {
      // Request permission for iOS devices
      log("Requesting notification permissions...");
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      log("Notification permissions granted.");

      // Initialize local notifications
      log("Initializing local notifications...");
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings();

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      bool? initialized = await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onSelectNotification,
      );

      if (initialized == true) {
        log("Local notifications initialized successfully.");
      } else {
        log("Failed to initialize local notifications.");
      }

      // Handle background messages
      log("Setting up background message handler...");
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      log("Setting up foreground message handler...");
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle when notification is clicked while app is in background
      log("Setting up notification tap handler...");
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Fetch and log FCM token
      log("Fetching FCM token...");
      await getFCMToken();

      // Get device information
      String deviceInfo = await _getDeviceInfo();
      log("Device info: $deviceInfo");
      await prefUtils.setDeviceInfo(deviceInfo);
    } catch (e) {
      log("Error during NotificationManager initialization: $e", error: e);
    }
  }

  // Get FCM token
  Future<String?> getFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await prefUtils.setFcmToken(token);
        log("FCM Token successfully retrieved: $token");
      } else {
        log("Failed to retrieve FCM Token.");
      }
      return token;
    } catch (e) {
      log("Error retrieving FCM Token: $e", error: e);
      return null;
    }
  }

  // Get device info for Android or iOS
  Future<String> _getDeviceInfo() async {
    try {
      final deviceInfo = await _deviceInfoPlugin.deviceInfo;
      if (deviceInfo is AndroidDeviceInfo) {
        return "${deviceInfo.brand} ${deviceInfo.model}, Android ${deviceInfo.version.release}";
      } else if (deviceInfo is IosDeviceInfo) {
        return "${deviceInfo.name}, iOS ${deviceInfo.systemVersion}";
      } else {
        return "Unknown device";
      }
    } catch (e) {
      log("Error getting device info: $e", error: e);
      return "Unknown device";
    }
  }

  // Handle background messages
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    try {
      log('Handling a background message: ${message.messageId}');
      log('Message data: ${message.data}');
      // Add your background message handling logic here
    } catch (e) {
      log("Error handling background message: $e", error: e);
    }
  }

  // Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    try {
      log('Received a message while in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message contains a notification: '
            'Title: ${message.notification?.title}, '
            'Body: ${message.notification?.body}');

        await _showNotification(
          title: message.notification?.title ?? 'No title',
          body: message.notification?.body ?? 'No body',
          payload: message.data.toString(),
        );
      }
    } catch (e) {
      log("Error handling foreground message: $e", error: e);
    }
  }

  // Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    try {
      log('Notification tapped: ${message.data}');
      // Add your notification tap handling logic here
    } catch (e) {
      log("Error handling notification tap: $e", error: e);
    }
  }

  // Show local notification
  Future<void> _showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      log('Showing local notification: Title: $title, Body: $body');
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'general_notifications',
        'General Notifications',
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
      log('Local notification displayed successfully.');
    } catch (e) {
      log("Error displaying local notification: $e", error: e);
    }
  }

  // Handle notification selection
  void _onSelectNotification(NotificationResponse response) {
    try {
      log('Notification selected: ${response.payload}');
      // Add your notification selection handling logic here
    } catch (e) {
      log("Error handling notification selection: $e", error: e);
    }
  }
}
