import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../navigation/main_navigation.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() =>
      _VerifyEmailScreenState();
}

class _VerifyEmailScreenState
    extends State<VerifyEmailScreen> {
  bool isLoading = false;

  Future<void> checkVerification() async {
    setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.currentUser?.reload();

    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (user != null && user.emailVerified) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigation(),
        ),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Email is still not verified.",
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> resendEmail() async {
    await FirebaseAuth.instance.currentUser
        ?.sendEmailVerification();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Verification email sent again.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email =
        FirebaseAuth.instance.currentUser?.email ?? "";

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mark_email_read_rounded,
                size: 90,
              ),

              const SizedBox(height: 24),

              const Text(
                "Verify Your Email",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "We sent a verification email to:\n$email",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                  isLoading ? null : checkVerification,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                    "I Verified My Email",
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextButton(
                onPressed: resendEmail,
                child: const Text(
                  "Resend Email",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}