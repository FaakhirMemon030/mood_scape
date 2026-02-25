import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/auth/login_screen.dart' hide darkTheme;
import 'screens/admin/admin_home_screen.dart';
import 'utils/constants.dart';
import 'utils/themes.dart' hide lightTheme;
import 'services/notification_service.dart';
import 'services/auth_serivce.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Initialize Firebase
  await Firebase.initializeApp();

  // 🔹 Initialize Notifications
  await NotificationService().init();

  runApp(const MoodScopeApp());
}

class MoodScopeApp extends StatelessWidget {
  const MoodScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Auto light/dark
      home: const SplashScreen(),
    );
  }
}
