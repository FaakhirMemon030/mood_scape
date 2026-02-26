import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // 👈 Ye hona lazmi hai
import 'screens/splash_screen.dart';
import 'utils/constants.dart';
import 'utils/themes.dart';

void main() async {
  // 🔹 Ensure bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Initialize Firebase with Options (Web compatibility ke liye zaroori hai)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔹 Initialize Notifications (Yahan aap apna notification code baad mein add kar sakte hain)

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
      themeMode: ThemeMode.system, // System ke mutabiq light ya dark mode
      home: const SplashScreen(),
    );
  }
}
