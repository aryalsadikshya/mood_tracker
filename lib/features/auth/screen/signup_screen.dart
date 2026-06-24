import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../navigation/main_navigation.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String selectedFocus = "Mood Tracking";

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  final List<String> focusOptions = [
    "Mood Tracking",
    "Journaling",
    "Stress Relief",
    "Healthy Habits",
    "Self Reflection",
  ];

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF9A817C)),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFFFFBF6),
      contentPadding: const EdgeInsets.symmetric(vertical: 20),
      hintStyle: GoogleFonts.poppins(
        color: const Color(0xFFA99B96),
        fontSize: 15,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(color: Color(0xFFF0DDE2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(
          color: Color(0xFFDAB8C8),
          width: 1.4,
        ),
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFFFF8FA),
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: const Color(0xFF746C6A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> signup() async {
    final name = nameController.text.trim();
    final ageText = ageController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        ageText.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage("Please fill all fields.");
      return;
    }

    final age = int.tryParse(ageText);

    if (age == null || age < 13 || age > 100) {
      showMessage("Please enter a valid age.");
      return;
    }

    if (password != confirmPassword) {
      showMessage("Passwords do not match.");
      return;
    }

    if (password.length < 6) {
      showMessage("Password should contain at least 6 characters.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "uid": uid,
        "name": name,
        "age": age,
        "email": email,
        "wellnessFocus": selectedFocus,
        "createdAt": Timestamp.fromDate(DateTime.now()),
      });

      await credential.user!.updateDisplayName(name);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigation(),
        ),
            (route) => false,
      );
    } catch (e) {
      final error = e.toString().toLowerCase();

      String message = "Something went wrong.";

      if (error.contains("email-already-in-use")) {
        message = "This email is already connected to an account.";
      } else if (error.contains("invalid-email")) {
        message = "Please enter a valid email address.";
      } else if (error.contains("weak-password")) {
        message = "Please use a stronger password.";
      } else if (error.contains("network")) {
        message = "Please check your internet connection.";
      }

      showMessage(message);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),

              Text(
                "Create Account",
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                  color: const Color(0xFF262323),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                "Begin your calm reflection journey and create your personal MindBloom space.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  height: 1.6,
                  color: const Color(0xFF746C6A),
                ),
              ),

              const SizedBox(height: 34),

              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8FA).withOpacity(0.78),
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(color: const Color(0xFFF1DDE5)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDAB8C8).withOpacity(0.22),
                      blurRadius: 32,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: inputDecoration(
                        hint: "Your name",
                        icon: Icons.person_outline_rounded,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: inputDecoration(
                        hint: "Age",
                        icon: Icons.cake_outlined,
                      ),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: selectedFocus,
                      decoration: inputDecoration(
                        hint: "Wellness focus",
                        icon: Icons.favorite_border_rounded,
                      ),
                      dropdownColor: const Color(0xFFFFFBF6),
                      items: focusOptions.map((focus) {
                        return DropdownMenuItem(
                          value: focus,
                          child: Text(
                            focus,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF263238),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedFocus = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: inputDecoration(
                        hint: "Email address",
                        icon: Icons.mail_outline_rounded,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: inputDecoration(
                        hint: "Password",
                        icon: Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF9A817C),
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword,
                      decoration: inputDecoration(
                        hint: "Confirm password",
                        icon: Icons.lock_reset_rounded,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF9A817C),
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword =
                              !obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : signup,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFFE8D7F1),
                          foregroundColor: const Color(0xFF2A2430),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF2A2430),
                          ),
                        )
                            : Text(
                          "Create Account",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF6F6868),
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB58AC8),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}