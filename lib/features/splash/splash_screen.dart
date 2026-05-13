import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/features/navigation/main_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../onboarding/onboarding_screen.dart';
import '../auth/auth_screen.dart';
import '../home/home_screen.dart';
import '../navigation/main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    navigateUser();
  }

  Future<void> navigateUser() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool("seenOnboarding") ?? false;
    final currentUser = FirebaseAuth.instance.currentUser;

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      if (!seenOnboarding) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const OnboardingScreen(),
          ),
        );
      } else if (currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainNavigation()
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AuthScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double opacity =
            (_controller.value - (index * 0.2)).clamp(0.0, 1.0);

            return Opacity(
              opacity: opacity,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFDAB8C8),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF0),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEAF1).withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -90,
            left: -70,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: const Color(0xFFE8D7F1).withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFF8FA),
                    border: Border.all(
                      color: const Color(0xFFF0DDE2),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFDAB8C8).withOpacity(0.25),
                        blurRadius: 35,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 78,
                    backgroundColor: Color(0xFFFDFCF0),
                    backgroundImage:
                    AssetImage('assets/images/logosplash.jpg'),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Pause. Reflect. Grow.",
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 0.8,
                    color: Color(0xFF7A6F73),
                  ),
                ),

                const SizedBox(height: 30),

                buildDots(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


