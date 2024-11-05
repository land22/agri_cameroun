import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationsProvider extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Liste pour stocker les notifications
  final List<String> _notifications = [];

  List<String> get notifications => _notifications;

  void initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        print(
            'Notification sélectionnée avec payload : ${notificationResponse.payload}');
        addNotification(
            notificationResponse.payload ?? 'Notification sans titre');
      },
    );
  }

  void handleFirebaseMessaging() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        String title = message.notification!.title ?? 'Notification';
        String body =
            message.notification!.body ?? 'Vous avez reçu un nouveau message.';
        _showLocalNotification(title, body);
        addNotification('$title - $body');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification ouverte : ${message.notification?.title}');
      addNotification(message.notification?.title ?? 'Notification ouverte');
    });
  }

  void _showLocalNotification(String title, String body) {
    flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription: 'channel_description',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  // Méthode pour ajouter une notification et notifier les listeners
  void addNotification(String notification) {
    _notifications.add(notification);
    notifyListeners();
  }
}
