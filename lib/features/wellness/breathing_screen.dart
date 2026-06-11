import 'dart:async';

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
  late Animation<double> pulseAnimation;

  Timer? timer;

  int seconds = 4;
  int totalSeconds = 4;

  String phase = "Ready";
  String instruction = "Press start when you are ready.";
  bool isRunning = false;
  bool completed = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    pulseAnimation = Tween<double>(
      begin: 0.88,
      end: 1.14,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void startBreathing() {
    timer?.cancel();

    setState(() {
      isRunning = true;
      completed = false;
      phase = "Inhale";
      instruction = "Breathe in softly.";
      seconds = 4;
      totalSeconds = 4;
    });

    controller.duration = const Duration(seconds: 4);
    controller.forward(from: 0);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        seconds--;
      });

      if (phase == "Inhale" && seconds == 0) {
        setState(() {
          phase = "Exhale";
          instruction = "Let it go slowly.";
          seconds = 6;
          totalSeconds = 6;
        });

        controller.duration = const Duration(seconds: 6);
        controller.reverse(from: 1);
      } else if (phase == "Exhale" && seconds == 0) {
        timer.cancel();

        setState(() {
          isRunning = false;
          completed = true;
          phase = "Completed";
          instruction = "Your mind may feel a little softer now.";
        });

        controller.stop();
      }
    });
  }

  void stopBreathing() {
    timer?.cancel();
    controller.stop();

    setState(() {
      isRunning = false;
      completed = false;
      phase = "Paused";
      instruction = "You paused your breathing reset.";
      seconds = 4;
      totalSeconds = 4;
    });
  }

  double progressValue() {
    if (!isRunning && !completed) return 0;
    if (completed) return 1;

    return 1 - (seconds / totalSeconds);
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = progressValue();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          const _BreathingBackground(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 32),
              child: Column(
                children: [
                  Row(
                    children: [
                      _CircleIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      _SmallPill(
                        text: completed
                            ? "Done"
                            : isRunning
                            ? "Breathing"
                            : "Ready",
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Text(
                    "Soft Breath",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "A tiny calm reset for your body and mind.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.6,
                      color: AppColors.textSoft,
                    ),
                  ),

                  const SizedBox(height: 34),

                  _BreathingCard(
                    phase: phase,
                    seconds: seconds,
                    completed: completed,
                    isRunning: isRunning,
                    progress: progress,
                    animation: pulseAnimation,
                  ),

                  const SizedBox(height: 26),

                  _InstructionCard(
                    instruction: instruction,
                    phase: phase,
                  ),

                  const SizedBox(height: 24),

                  _BreathingSteps(
                    phase: phase,
                    completed: completed,
                  ),

                  const SizedBox(height: 28),

                  if (!isRunning && !completed)
                    _MainButton(
                      text: "Start Breathing",
                      icon: Icons.play_arrow_rounded,
                      onTap: startBreathing,
                    ),

                  if (isRunning)
                    Row(
                      children: [
                        Expanded(
                          child: _SecondaryButton(
                            text: "Stop",
                            icon: Icons.stop_rounded,
                            onTap: stopBreathing,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _MainButton(
                            text: "Restart",
                            icon: Icons.refresh_rounded,
                            onTap: startBreathing,
                          ),
                        ),
                      ],
                    ),

                  if (completed)
                    Column(
                      children: [
                        _MainButton(
                          text: "Try Again",
                          icon: Icons.replay_rounded,
                          onTap: startBreathing,
                        ),
                        const SizedBox(height: 14),
                        _SecondaryButton(
                          text: "Back to Wellness",
                          icon: Icons.spa_rounded,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
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

class _BreathingCard extends StatelessWidget {
  final String phase;
  final int seconds;
  final bool completed;
  final bool isRunning;
  final double progress;
  final Animation<double> animation;

  const _BreathingCard({
    required this.phase,
    required this.seconds,
    required this.completed,
    required this.isRunning,
    required this.progress,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 30, 22, 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.blush,
            AppColors.lavender,
            AppColors.paleBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(42),
        border: Border.all(
          color: Colors.white.withOpacity(0.95),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withOpacity(0.22),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            completed
                ? "Beautifully done"
                : isRunning
                ? "Follow the circle"
                : "Ready to begin?",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.deepBlue,
            ),
          ),

          const SizedBox(height: 28),

          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.scale(
                scale: isRunning ? animation.value : 1.0,
                child: _BreathingOrb(
                  phase: phase,
                  seconds: seconds,
                  completed: completed,
                  isRunning: isRunning,
                  progress: progress,
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          _ClockProgress(
            progress: progress,
            completed: completed,
            isRunning: isRunning,
          ),
        ],
      ),
    );
  }
}

class _BreathingOrb extends StatelessWidget {
  final String phase;
  final int seconds;
  final bool completed;
  final bool isRunning;
  final double progress;

  const _BreathingOrb({
    required this.phase,
    required this.seconds,
    required this.completed,
    required this.isRunning,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 260,
          width: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.28),
          ),
        ),

        Container(
          height: 220,
          width: 220,
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
                color: AppColors.lakeBlue.withOpacity(0.22),
                blurRadius: 38,
                offset: const Offset(0, 16),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 238,
          width: 238,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 7,
            backgroundColor: Colors.white.withOpacity(0.45),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.deepBlue,
            ),
          ),
        ),

        Container(
          height: 174,
          width: 174,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.55),
            border: Border.all(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                completed
                    ? "🌸"
                    : isRunning
                    ? "🫧"
                    : "☁️",
                style: const TextStyle(fontSize: 44),
              ),

              const SizedBox(height: 12),

              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  phase,
                  maxLines: 1,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: completed ? 28 : 34,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                completed
                    ? "Complete"
                    : isRunning
                    ? "$seconds sec"
                    : "4 + 6",
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.deepBlue,
                ),
              ),
            ],
          ),
        ),

        const Positioned(
          top: 20,
          left: 34,
          child: _TinySticker(
            emoji: "✦",
            color: AppColors.warmYellow,
          ),
        ),

        const Positioned(
          bottom: 28,
          right: 32,
          child: _TinySticker(
            emoji: "♡",
            color: AppColors.blush,
          ),
        ),
      ],
    );
  }
}

class _ClockProgress extends StatelessWidget {
  final double progress;
  final bool completed;
  final bool isRunning;

  const _ClockProgress({
    required this.progress,
    required this.completed,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.50),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withOpacity(0.85),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: const BoxDecoration(
              color: AppColors.mint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.timer_rounded,
              color: AppColors.deepBlue,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.white.withOpacity(0.65),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.deepBlue,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Text(
            completed
                ? "100%"
                : isRunning
                ? "$percent%"
                : "0%",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              color: AppColors.deepBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionCard extends StatelessWidget {
  final String instruction;
  final String phase;

  const _InstructionCard({
    required this.instruction,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.66),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withOpacity(0.10),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            phase == "Exhale"
                ? "🌬️"
                : phase == "Completed"
                ? "🌸"
                : "☁️",
            style: const TextStyle(fontSize: 36),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              instruction,
              style: GoogleFonts.poppins(
                fontSize: 15,
                height: 1.55,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreathingSteps extends StatelessWidget {
  final String phase;
  final bool completed;

  const _BreathingSteps({
    required this.phase,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StepPill(
            title: "Inhale",
            subtitle: "4 sec",
            active: phase == "Inhale",
            done: phase == "Exhale" || completed,
            color: AppColors.paleBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StepPill(
            title: "Exhale",
            subtitle: "6 sec",
            active: phase == "Exhale",
            done: completed,
            color: AppColors.lavender,
          ),
        ),
      ],
    );
  }
}

class _StepPill extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool active;
  final bool done;
  final Color color;

  const _StepPill({
    required this.title,
    required this.subtitle,
    required this.active,
    required this.done,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: active || done ? color.withOpacity(0.86) : Colors.white.withOpacity(0.50),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: active ? AppColors.deepBlue : Colors.white.withOpacity(0.9),
          width: active ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            done
                ? "✓"
                : active
                ? "•"
                : "○",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.deepBlue,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSoft,
            ),
          ),
        ],
      ),
    );
  }
}

class _MainButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _MainButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(
          text,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.deepBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.deepBlue,
        side: const BorderSide(
          color: AppColors.deepBlue,
        ),
        padding: const EdgeInsets.symmetric(vertical: 17),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  final String text;

  const _SmallPill({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.58),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.85),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppColors.deepBlue,
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.58),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 48,
          width: 48,
          child: Icon(
            icon,
            color: AppColors.deepBlue,
          ),
        ),
      ),
    );
  }
}

class _TinySticker extends StatelessWidget {
  final String emoji;
  final Color color;

  const _TinySticker({
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        color: color.withOpacity(0.76),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.94),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        emoji,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.deepBlue,
        ),
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
          top: -90,
          right: -80,
          child: _Blob(
            color: AppColors.lavender.withOpacity(0.58),
            size: 250,
          ),
        ),

        Positioned(
          bottom: 130,
          left: -90,
          child: _Blob(
            color: AppColors.paleBlue.withOpacity(0.56),
            size: 270,
          ),
        ),

        Positioned(
          top: 300,
          left: 46,
          child: _Blob(
            color: AppColors.blush.withOpacity(0.42),
            size: 140,
          ),
        ),

        Positioned(
          bottom: -50,
          right: 30,
          child: _Blob(
            color: AppColors.mint.withOpacity(0.36),
            size: 160,
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
    return IgnorePointer(
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}