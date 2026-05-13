import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import '../navigation/main_navigation.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService authService = AuthService();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
        borderSide: const BorderSide(color: Color(0xFFDAB8C8), width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: Column(
              children: [
                const SizedBox(height: 54),



                Text(
                  "Welcome Back",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    color: const Color(0xFF262323),
                  ),
                ),

                const SizedBox(height: 14),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    "Return to your calm space and continue your reflection journey.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      height: 1.6,
                      color: const Color(0xFF746C6A),
                    ),
                  ),
                ),

                const SizedBox(height: 42),

                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8FA).withOpacity(0.78),
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(
                      color: const Color(0xFFF1DDE5),
                    ),
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

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              final user = await authService.login(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );

                              if (user != null) {


                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MainNavigation(),
                                  ),
                                );
                              }
                            } catch (e) {
                              String message = "Something went wrong.";

                              final error = e.toString().toLowerCase();

                              if (error.contains("user-not-found")) {
                                message = "No account was found for this email.";
                              } else if (error.contains("wrong-password")) {
                                message = "The password you entered is incorrect.";
                              } else if (error.contains("invalid-email")) {
                                message = "Please enter a valid email address.";
                              } else if (error.contains("network")) {
                                message = "Please check your internet connection.";
                              }

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(message),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFFE8D7F1),
                            foregroundColor: const Color(0xFF2A2430),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: const Color(0xFFEBDCE4),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "or",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF8A7E80),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: const Color(0xFFEBDCE4),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            try {
                              await authService.signInWithGoogle();

                              if (!context.mounted) return;

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MainNavigation(),
                                ),
                                    (route) => false,
                              );
                            } catch (e) {
                              debugPrint("GOOGLE SIGN IN ERROR: $e");

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("Google sign in failed: $e"),
                                ),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            side: const BorderSide(
                              color: Color(0xFFDCC3E8),
                            ),
                            foregroundColor: const Color(0xFF7B6586),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: Text(
                            "Continue with Google",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
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
                      "Don’t have an account? ",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF6F6868),
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
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
      ),
    );
  }
}