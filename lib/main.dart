import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'artisan_dashboard.dart';
import 'login_screen.dart';
import 'buyer_dashboard.dart';
import 'upload_screen.dart';

void main() async {
  // Ensure Flutter engine is fully initialized before checking storage
  WidgetsFlutterBinding.ensureInitialized();

  // Check local storage for an active session
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final String userRole = prefs.getString('userRole') ?? 'Commercial Buyer';

  // Determine which screen to show first
  Widget initialScreen = const LoginScreen();
  if (isLoggedIn) {
    if (userRole == 'Commercial Buyer') {
      initialScreen = const BuyerDashboard();
    } else {
      initialScreen = const ArtisanDashboard();
    }
  }

  runApp(CrafLensApp(initialScreen: initialScreen));
}

class CrafLensApp extends StatelessWidget {
  final Widget initialScreen;

  const CrafLensApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CrafLens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: initialScreen,
    );
  }
}