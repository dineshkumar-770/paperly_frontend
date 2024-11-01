// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:paperly/firebase_options.dart';
import 'package:paperly/main.dart';
import 'package:paperly/src/home_screen/views/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationController {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> initializeApp() async {
    await Permission.notification.request();
    await messaging.setAutoInitEnabled(true);
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    _flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ));

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          '0',
          'general',
        ));

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        final notificationData = message.data;
        log(notificationData.toString());
        if (notificationData["image_url"].toString() != null && notificationData["image_url"].toString().isNotEmpty) {
          _showImageNotification(
              message: notificationData["body"].toString(),
              imageURL: notificationData["image_url"].toString(),
              title: notificationData["title"].toString());
        } else {
          log('Message data: ${message.data}');
          _showNotification(message: notificationData["body"].toString(), title: notificationData["title"].toString());
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final notificationData = message.data;
      log(notificationData.toString());
      if (notificationData["image_url"].toString() != null && notificationData["image_url"].toString().isNotEmpty) {
        _showImageNotification(
            message: notificationData["body"].toString(),
            imageURL: notificationData["image_url"].toString(),
            title: notificationData["title"].toString());
      } else {
        log('Message data: ${message.data}');
        _showNotification(message: notificationData["body"].toString(), title: notificationData["title"].toString());
      }
    });

    FirebaseMessaging.onBackgroundMessage(
      (RemoteMessage message) async {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        final notificationData = message.data;
        log(notificationData.toString());
        if (notificationData["image_url"].toString() != null && notificationData["image_url"].toString().isNotEmpty) {
          _showImageNotification(
              message: notificationData["body"].toString(),
              imageURL: notificationData["image_url"].toString(),
              title: notificationData["title"].toString());
        } else {
          log('Message data: ${message.data}');
          _showNotification(message: notificationData["body"].toString(), title: notificationData["title"].toString());
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log(message.data.toString());
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    });
  }

  void _showNotification({required String message, required String title}) {
    AndroidNotificationDetails androidNotificationDetail = const AndroidNotificationDetails(
      '0',
      'general',
      enableLights: true,
      enableVibration: true,
      importance: Importance.max,
    );
    if (Platform.isAndroid) {
      _flutterLocalNotificationsPlugin.show(
          0,
          title,
          message.toString(),
          NotificationDetails(
            android: androidNotificationDetail,
          ));
    }
  }

  void _showImageNotification({required String message, required String imageURL, required String title}) async {
    final response = await HttpClient().getUrl(Uri.parse(imageURL));
    final bytes =
        await response.close().then((response) => response.fold<List<int>>([], (buffer, data) => buffer..addAll(data)));
    final image = Uint8List.fromList(bytes);
    BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      ByteArrayAndroidBitmap.fromBase64String(base64Encode(image)),
      largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Encode(image)),
    );
    AndroidNotificationDetails androidNotificationDetail = AndroidNotificationDetails(
      '0',
      'general',
      enableLights: true,
      enableVibration: true,
      importance: Importance.max,
      styleInformation: bigPictureStyleInformation,
    );
    if (Platform.isAndroid) {
      _flutterLocalNotificationsPlugin.show(
          0,
          title,
          message.toString(),
          NotificationDetails(
            android: androidNotificationDetail,
          ));
    }
  }
}
