import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture_getx/services/push_notification/local_notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

class FirebaseNotificationService {
  late LocalNotificationService _localNotification;
  late FirebaseMessaging _firebaseMessaging;

  Function(Map<String, dynamic>)? _onNotificationTap;
  Function(Map<String, dynamic>)? _onForegroundMessage;

  Future<void> init(
    LocalNotificationService localNotification, {
    Function(Map<String, dynamic>)? onNotificationTap,
    Function(Map<String, dynamic>)? onForegroundMessage,
  }) async {
    _localNotification = localNotification;
    _onNotificationTap = onNotificationTap;
    _onForegroundMessage = onForegroundMessage;

    _firebaseMessaging = FirebaseMessaging.instance;

    if (await _doesNotHavePermission()) {
      debugPrint('Notification permission denied');
      return;
    }

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _getAndLogFCMToken();

    _registerListeners();

    debugPrint('Firebase Notification Service initialized');
  }

  Future<String?> getAppLaunchPayload() async {
    RemoteMessage? message = await _firebaseMessaging.getInitialMessage();
    if (message == null) return null;

    return jsonEncode(message.data);
  }

  void _registerListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // debugPrint('Foreground message received: ${message.messageId}');
      // debugPrint('Payload: ${jsonEncode(message.data)}');

      _convertRemoteNotificationAndShowAsLocal(message);

      if (_onForegroundMessage != null && message.data.isNotEmpty) {
        _onForegroundMessage!(message.data);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification opened app from background: ${message.messageId}');

      if (_onNotificationTap != null && message.data.isNotEmpty) {
        _onNotificationTap!(message.data);
      }
    });

    _firebaseMessaging.onTokenRefresh.listen((token) {
      debugPrint('FCM Token refreshed: $token');
      // TODO: Send token to your backend server
    });
  }

  Future<void> _convertRemoteNotificationAndShowAsLocal(
      RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    await _localNotification.show(
      title: (notification != null && notification.title != null)
          ? notification.title!
          : "Notification",
      body: (notification != null && notification.body != null)
          ? notification.body!
          : "",
      data: message.data,
    );
  }

  Future<bool> _doesNotHavePermission() async {
    if (kIsWeb) return false;

    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('Notification permission: ${settings.authorizationStatus}');

      if (Platform.isAndroid) {
        final status = await Permission.notification.status;
        if (status.isDenied) {
          final result = await Permission.notification.request();
          return !result.isGranted;
        }
        return !status.isGranted;
      }

      return settings.authorizationStatus != AuthorizationStatus.authorized;
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return true;
    }
  }

  Future<String?> _getAndLogFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      debugPrint('FCM Token: $token');
      return token;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  Future<String?> getFCMToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  Future<void> deleteFCMToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      debugPrint('FCM token deleted');
    } catch (e) {
      debugPrint('Error deleting FCM token: $e');
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }
}
