import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ewasterecycling/welcome_screen.dart';
import 'package:ewasterecycling/registration_screen.dart';
import 'package:ewasterecycling/login_screen.dart';
import 'package:ewasterecycling/onboarding_screen.dart';
import 'package:ewasterecycling/home_screen.dart';
import 'package:ewasterecycling/search_screen.dart';
import 'package:ewasterecycling/geolocation_screen.dart';
import 'package:ewasterecycling/profile_screen.dart';
import 'package:ewasterecycling/rewards_screen.dart';
import 'package:ewasterecycling/education_screen.dart';
import 'package:ewasterecycling/admin_dashboard.dart';
import 'package:ewasterecycling/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
    // Continue without Firebase for development purposes
  }
  
  runApp(const EWasteRecyclingApp());
}

class EWasteRecyclingApp extends StatelessWidget {
  const EWasteRecyclingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eWaste Recycling',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/login': (context) => const LoginScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/geolocation': (context) => const GeoLocationScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/rewards': (context) => const RewardsScreen(),
        '/education': (context) => const EducationScreen(),
        '/admin': (context) => const AdminDashboard(),
      },
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        );
      },
    );
  }
}