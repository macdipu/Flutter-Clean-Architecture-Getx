import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture_getx/services/push_notification/firebase_notification_service.dart';
import 'package:flutter_clean_architecture_getx/services/push_notification/local_notification_service.dart';


class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  late final LocalNotificationService _local = LocalNotificationService();
  late final FirebaseNotificationService _firebase = FirebaseNotificationService();

  bool didNotificationLaunchApp = false;
  late String _appLaunchedPayload;
  late Map<String, dynamic> _appLaunchedData;

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  String get appLaunchedPayload => _appLaunchedPayload;

  Map<String, dynamic> get appLaunchedData => _appLaunchedData;

  Map<String, dynamic>? getLaunchedData() {
    if (!didNotificationLaunchApp) return null;
    return _appLaunchedData;
  }

  Future<void> init({
    Function(Map<String, dynamic>)? onNotificationTap,
    Function(Map<String, dynamic>)? onForegroundMessage,
  }) async {
    if (_isInitialized) {
      debugPrint('NotificationService already initialized');
      return;
    }

    try {
      await _local.init(onNotificationTap: onNotificationTap);
      await _firebase.init(
        _local,
        onNotificationTap: onNotificationTap,
        onForegroundMessage: onForegroundMessage,
      );
      await _determineIfAppLaunchedByNotification();

      _isInitialized = true;
      debugPrint('NotificationService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing NotificationService: $e');
      rethrow;
    }
  }

  FirebaseNotificationService getFirebaseService() {
    return _firebase;
  }

  LocalNotificationService getLocalService() {
    return _local;
  }

  Future<void> _determineIfAppLaunchedByNotification() async {
    await _firebase.getAppLaunchPayload().then(_processAppLaunchPayload);
    if (didNotificationLaunchApp) return;

    await _local.getAppLaunchPayload().then(_processAppLaunchPayload);
  }

  FutureOr<String?> _processAppLaunchPayload(String? payload) async {
    if (payload == null) return null;

    didNotificationLaunchApp = true;
    _appLaunchedPayload = payload;

    try {
      _appLaunchedData = jsonDecode(payload);
      debugPrint('App launched from notification with data: $_appLaunchedData');
    } catch (e) {
      _appLaunchedData = {};
      debugPrint('Failed to parse notification payload: $e');
    }

    return null;
  }

  Future<String?> getFCMToken() => _firebase.getFCMToken();

  Future<void> deleteFCMToken() => _firebase.deleteFCMToken();

  Future<void> subscribeToTopic(String topic) => _firebase.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) => _firebase.unsubscribeFromTopic(topic);

  Future<void> showLocalNotification({
    required String title,
    String? body,
    Map<String, dynamic>? data,
  }) =>
      _local.show(title: title, body: body, data: data);

  Future<void> cancelNotification(int id) => _local.cancelNotification(id);

  Future<void> cancelAllNotifications() => _local.cancelAllNotifications();

  void reset() {
    _isInitialized = false;
    didNotificationLaunchApp = false;
  }
}

