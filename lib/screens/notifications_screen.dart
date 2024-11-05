import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agri_cameroun/providers/notifications_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_drawer.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications et alertes'),
      ),
      drawer: user != null ? CustomDrawer() : null,
      body: Consumer<NotificationsProvider>(
        builder: (context, notificationsProvider, child) {
          if (notificationsProvider.notifications.isEmpty) {
            return Center(
              child: Text(
                'Aucune notification pour le moment.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            itemCount: notificationsProvider.notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(notificationsProvider.notifications[index]),
              );
            },
          );
        },
      ),
    );
  }
}
