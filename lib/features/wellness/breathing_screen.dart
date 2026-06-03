import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colours.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  int seconds = 4;

  String phase = "Inhale";
  bool completed = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
      lowerBound: 0.85,
      upperBound: 1.15,
    );

    startBreathing();
  }

  void startBreathing() {
    timer?.cancel();

    setState(() {
      completed = false;
      phase = "Inhale";
      seconds = 4;
    });

    controller.forward();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds--;
        SystemSound.play(SystemSoundType.click);
      });

      if (phase == "Inhale" && seconds == 0) {
        setState(() {
          phase = "Exhale";
          seconds = 6;
        });

        controller.reverse();
      } else if (phase == "Exhale" && seconds == 0) {
        timer.cancel();
        SystemSound.play(SystemSoundType.alert);

        setState(() {
          completed = true;

          phase = "Completed";
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          const _BreathingBackground(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 34),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.deepBlue,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Soft Breath",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "A tiny breathing reset for your mind.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSoft,
                    ),
                  ),

                  const Spacer(),

                  ScaleTransition(
                    scale: controller,
                    child: Container(
                      height: 260,
                      width: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [
                            Colors.white,
                            AppColors.paleBlue,
                            AppColors.lavender,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lakeBlue.withOpacity(0.24),
                            blurRadius: 42,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.45),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              completed ? "🌸" : "🫧",
                              style: const TextStyle(fontSize: 52),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              phase,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              completed ? "You did it" : "$seconds sec",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  Text(
                    completed
                        ? "Your mind may feel a little softer now."
                        : phase == "Inhale"
                        ? "Breathe in slowly."
                        : "Let it go gently.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      height: 1.6,
                      color: AppColors.textSoft,
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: startBreathing,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        completed ? "Try Again" : "Restart",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreathingBackground extends StatelessWidget {
  const _BreathingBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.cream),
        Positioned(
          top: -80,
          right: -80,
          child: _Blob(
            color: AppColors.lavender.withOpacity(0.55),
            size: 240,
          ),
        ),
        Positioned(
          bottom: 120,
          left: -80,
          child: _Blob(
            color: AppColors.paleBlue.withOpacity(0.55),
            size: 260,
          ),
        ),
        Positioned(
          top: 260,
          left: 40,
          child: _Blob(
            color: AppColors.blush.withOpacity(0.40),
            size: 130,
          ),
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;

  const _Blob({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}