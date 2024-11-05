import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/advice_list_screen.dart';
import 'screens/culture_tracking_screen.dart';
import 'screens/market_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/user_management_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'providers/notifications_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialisation des notifications
  NotificationsProvider notificationsProvider = NotificationsProvider();
  notificationsProvider.initializeNotifications();
  notificationsProvider.handleFirebaseMessaging();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => notificationsProvider),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agri-Cameroun',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        'login': (context) => LoginScreen(),
        'register': (context) => RegisterScreen(),
        'home': (context) => ProfileScreen(),
        'advice_list_screem': (context) => AdviceListScreen(),
        'culture_tracking': (context) => CultureTrackingScreen(),
        'market_screen': (context) => MarketScreen(),
        'notifications': (context) => NotificationsScreen(),
        'weather': (context) => WeatherScreen(),
        'user_management': (context) => UserManagementScreen(),
      },
    );
  }
}
