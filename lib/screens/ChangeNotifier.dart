import 'package:flutter/material.dart';

class NotificationsProvider extends ChangeNotifier {
  List<String> _notifications = [];

  List<String> get notifications => _notifications;

  void addNotification(String notification) {
    _notifications.add(notification);
    notifyListeners(); // Notifie les widgets qui utilisent ce provider
  }
}
