import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:experta/core/app_export.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:device_info_plus/device_info_plus.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  PrefUtils prefUtils = PrefUtils();
  Future<void> init() async {
    log("Initializing NotificationManager...");

    try {
      log("Requesting notification permissions...");
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      log("Notification permissions granted.");

      // Call getAPNSToken for iOS devices
      if (Platform.isIOS) {
        String? apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken != null) {
          log("APNS Token successfully retrieved: $apnsToken");
        } else {
          log("Failed to retrieve APNS Token.");
        }
      }

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
      if (Platform.isAndroid) {
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          enableVibration: true,
          showBadge: true,
          playSound: true,
        );

        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
      }
      if (initialized == true) {
        log("Local notifications initialized successfully.");
      } else {
        log("Failed to initialize local notifications.");
      }
      log("Setting up background message handler...");
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      log("Setting up foreground message handler...");
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      log("Setting up notification tap handler...");
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
      log("Fetching FCM token...");
      await getFCMToken();
      String deviceInfo = await _getDeviceInfo();
      log("Device info: $deviceInfo");
      await prefUtils.setDeviceInfo(deviceInfo);
    } catch (e) {
      log("Error during NotificationManager initialization: $e", error: e);
    }
  }

  Future<String?> getFCMToken() async {
  try {
    String? token;
    if (Platform.isIOS) {
      // For iOS, ensure the APNS token is retrieved
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        log("APNS Token successfully retrieved: $apnsToken");
        // Optionally, you can use the APNS token directly or log it
      } else {
        log("Failed to retrieve APNS Token.");
      }
    }

    // Retrieve the FCM token
    token = await _firebaseMessaging.getToken();
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

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();

    try {
      log('Handling a background message: ${message.messageId}');
      if (message.notification != null) {
        final flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        const androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          ticker: 'ticker',
          visibility: NotificationVisibility.public,
        );
        const platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
        );

        await flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecond,
          message.notification?.title ?? '',
          message.notification?.body ?? '',
          platformChannelSpecifics,
        );
      }
    } catch (e) {
      log("Error handling background message: $e", error: e);
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    try {
      log('Received a message while in the foreground!');
      log('Message data: ${message.data}');

      // Log notification received event
      await _analytics.logEvent(
        name: 'notification_received',
        parameters: {
          'type': message.data['type'] ?? 'unknown',
          'notification_id': message.data['notificationId'] ?? '',
          'booking_id': message.data['bookingId'] ?? '',
        },
      );

      if (message.notification != null) {
        String payload = jsonEncode(message.data);
        await _showNotification(
          title: message.notification?.title ?? 'No title',
          body: message.notification?.body ?? 'No body',
          payload: payload,
        );
      }
    } catch (e) {
      log("Error handling foreground message: $e", error: e);
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    try {
      log('Notification tapped: ${message.data}');
    } catch (e) {
      log("Error handling notification tap: $e", error: e);
    }
  }

  Future<void> _showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        ticker: 'ticker',
        visibility: NotificationVisibility.public,
        // icon: '@mipmap/ic_launcher',
        // sound: RawResourceAndroidNotificationSound('notification_sound'),
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      log("Error displaying local notification: $e", error: e);
    }
  }

  void _onSelectNotification(NotificationResponse response) {
    try {
      log('Notification selected: ${response.payload}');
      if (response.payload != null) {
        Map<String, dynamic> data = jsonDecode(response.payload!);
        _analytics.logEvent(
          name: 'notification_clicked',
          parameters: {
            'type': data['type'] ?? 'unknown',
            'notification_id': data['notificationId'] ?? '',
            'booking_id': data['bookingId'] ?? '',
          },
        );
        String? bookingId = data['bookingId'];
        String? type = data['type'];
        String? currentStatus = data['currentStatus'];
        if (bookingId != null &&
            type == 'video' &&
            currentStatus == 'accepted') {
          // Navigator.pushNamed(context, '/booking-details',
          //     arguments: bookingId);
          Get.toNamed(
            AppRoutes.mybook,
            // arguments: {
            //   'initialTab': 'upcoming',
            //   'bookingId': bookingId,
            //   'type': type,
            //   'currentStatus': currentStatus
            // },
          );
        }
      }
    } catch (e) {
      log("Error handling notification selection: $e", error: e);
    }
  }
}
