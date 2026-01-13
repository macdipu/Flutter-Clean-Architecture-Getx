import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotifications =
      FlutterLocalNotificationsPlugin();

  late AndroidNotificationChannel _androidChannel;
  Function(Map<String, dynamic>)? _onNotificationTap;

  Future<void> init({Function(Map<String, dynamic>)? onNotificationTap}) async {
    _onNotificationTap = onNotificationTap;

    _androidChannel = const AndroidNotificationChannel(
      'zaytoon_channel1',
      'zaytoon Notification',
      description: 'Notification For Ranks',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _flutterLocalNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_agami');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
    );

    debugPrint('Local Notification Service initialized');
  }

  Future<void> show({
    required String title,
    String? body,
    Map<String, dynamic>? data,
  }) async {
    final payload = data != null ? jsonEncode(data) : null;

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'zaytoon_channel1',
      'zaytoon Notification',
      channelDescription: 'Notification For Ranks',
      importance: Importance.high,
      priority: Priority.high,
      color: Colors.blue,
      playSound: true,
      enableVibration: true,
    );

    const iOSNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSNotificationDetails,
    );

    await _flutterLocalNotifications.show(
      title.hashCode,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<String?> getAppLaunchPayload() async {
    NotificationAppLaunchDetails? details =
        await _flutterLocalNotifications.getNotificationAppLaunchDetails();

    return (details?.didNotificationLaunchApp ?? false)
        ? details!.notificationResponse!.payload
        : null;
  }

  void _onSelectNotification(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        _onNotificationTap?.call(Map<String, dynamic>.from(data));
      } catch (e) {
        debugPrint('Error parsing notification payload: $e');
      }
    }
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotifications.cancelAll();
  }
}

