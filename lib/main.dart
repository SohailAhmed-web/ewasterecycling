import 'package:flutter/material.dart';
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

void main() {
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
        '/register': (context) => RegistrationScreen(),
        '/login': (context) => LoginScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/geolocation': (context) => const GeoLocationScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/rewards': (context) => const RewardsScreen(),
        '/education': (context) => EducationScreen(),
        '/admin': (context) => const AdminDashboard(),
      },
      debugShowCheckedModeBanner: false,
      // Handle unknown routes
      onGenerateRoute: (settings) {
        // You can add custom route handling here if needed
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        );
      },
    );
  }
}