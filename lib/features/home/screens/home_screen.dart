import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../memory/memory_service.dart';
import '../../../core/theme/app_colours.dart';
import '../../../core/widgets/app_loading.dart';
import '../../mood/models/mood_model.dart';
import '../../mood/services/mood_analyzer.dart';
import '../../mood/services/mood_service.dart';
import '../../mood/services/streak_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final MoodService moodService = MoodService();

  late AnimationController _controller;
  late Animation<double> _float;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _float = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  Color moodColor(String label) {
    switch (label) {
      case "Happy":
        return AppColors.softPink;
      case "Calm":
        return AppColors.mint;
      case "Okay":
        return AppColors.warmYellow;
      case "Low":
        return AppColors.paleBlue;
      case "Stressed":
        return AppColors.softPurple;
      default:
        return AppColors.lavender;
    }
  }

  List<Color> moodBackground(MoodModel? mood) {
    switch (mood?.moodLabel) {
      case "Happy":
        return [
          AppColors.warmYellow,
          AppColors.blush,
          AppColors.peach,
        ];
      case "Calm":
        return [
          AppColors.mint,
          AppColors.paleBlue,
          AppColors.cream,
        ];
      case "Okay":
        return [
          AppColors.warmYellow,
          AppColors.cream,
          AppColors.lavender,
        ];
      case "Low":
        return [
          AppColors.paleBlue,
          AppColors.lavender,
          AppColors.cream,
        ];
      case "Stressed":
        return [
          AppColors.softPurple,
          AppColors.lavender,
          AppColors.paleBlue,
        ];
      default:
        return [
          AppColors.blush,
          AppColors.lavender,
          AppColors.paleBlue,
        ];
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<MoodModel>>(
        stream: moodService.getMoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoading(
              message: "Opening your space...",
            );
          }

          final moods = snapshot.data ?? [];
          final latestMood = moods.isEmpty ? null : moods.first;

          final color = latestMood == null
              ? AppColors.lavender
              : moodColor(latestMood.moodLabel);

          final streak = StreakService.calculateStreak(moods);

          return Stack(
            children: [
              _MoodAdaptiveBackground(
                colors: moodBackground(latestMood),
                animation: _controller,
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _GreetingHeader(
                        greeting: greeting(),
                      ),

                      const SizedBox(height: 30),

                      AnimatedBuilder(
                        animation: _float,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _float.value),
                            child: _TodayMoodBox(
                              mood: latestMood,
                              color: color,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),



                      _CuteInsightCard(
                        insight: MoodAnalyzer.getInsight(moods),
                      ),

                      const SizedBox(height: 22),

                      Row(
                        children: [
                          Expanded(
                            child: _CuteMiniCard(
                              emoji: "🌷",
                              title: "$streak Day",
                              subtitle: "Streak",
                              color: AppColors.blush,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _CuteMiniCard(
                              emoji: latestMood?.moodEmoji ?? "🫧",
                              title: latestMood?.moodLabel ?? "Not yet",
                              subtitle: "Latest mood",
                              color: AppColors.paleBlue,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      const _CuteWellnessShortcut(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MoodAdaptiveBackground extends StatelessWidget {
  final List<Color> colors;
  final Animation<double> animation;

  const _MoodAdaptiveBackground({
    required this.colors,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors[0].withOpacity(0.78),
                    colors[1].withOpacity(0.62),
                    colors[2].withOpacity(0.86),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            Positioned.fill(
              child: CustomPaint(
                painter: _FloatingPastelPatternPainter(animation.value),
              ),
            ),

            Positioned(
              top: -70 + animation.value * 20,
              right: -60,
              child: _SoftBlob(
                color: colors[0].withOpacity(0.46),
                size: 240,
              ),
            ),

            Positioned(
              bottom: 120 - animation.value * 20,
              left: -80,
              child: _SoftBlob(
                color: colors[1].withOpacity(0.45),
                size: 260,
              ),
            ),

            Positioned(
              top: 300 + animation.value * 12,
              right: -90,
              child: _SoftBlob(
                color: colors[2].withOpacity(0.42),
                size: 220,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FloatingPastelPatternPainter extends CustomPainter {
  final double value;

  _FloatingPastelPatternPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(18);

    final icons = ["♡", "✦", "✧", "•", "˚"];

    final colors = [
      Colors.white.withOpacity(0.45),
      AppColors.blush.withOpacity(0.35),
      AppColors.lavender.withOpacity(0.35),
      AppColors.paleBlue.withOpacity(0.35),
      AppColors.mint.withOpacity(0.28),
    ];

    for (int i = 0; i < 32; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: icons[i % icons.length],
          style: TextStyle(
            color: colors[i % colors.length],
            fontSize: 12 + random.nextDouble() * 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      final dx = random.nextDouble() * size.width;
      final dy =
          (random.nextDouble() * size.height) + (sin(value * pi * 2 + i) * 10);

      textPainter.paint(
        canvas,
        Offset(dx, dy),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingPastelPatternPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}

class _GreetingHeader extends StatelessWidget {
  final String greeting;

  const _GreetingHeader({
    required this.greeting,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 58,
          width: 58,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.56),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.92),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.softPurple.withOpacity(0.14),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            "🌸",
            style: TextStyle(fontSize: 31),
          ),
        ),

        const SizedBox(width: 14),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.48),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Colors.white.withOpacity(0.85),
            ),
          ),
          child: Text(
            greeting,
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }
}

class _TodayMoodBox extends StatelessWidget {
  final MoodModel? mood;
  final Color color;

  const _TodayMoodBox({
    required this.mood,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final displayEmoji = mood?.moodEmoji ?? "🌱";
    final displayMood = mood?.moodLabel ?? "Blooming";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.80),
            Colors.white.withOpacity(0.62),
            AppColors.cream.withOpacity(0.72),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: Colors.white.withOpacity(0.92),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.34),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 4,
            right: 8,
            child: _StickerBubble(
              emoji: "✨",
              color: AppColors.warmYellow,
            ),
          ),

          const Positioned(
            bottom: 0,
            right: 58,
            child: _StickerBubble(
              emoji: "🫧",
              color: AppColors.paleBlue,
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today’s Mood",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepBlue,
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Container(
                    height: 106,
                    width: 106,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(34),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.92),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.22),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      displayEmoji,
                      style: const TextStyle(
                        fontSize: 58,
                      ),
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayMood,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 42,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                            height: 1.05,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          mood == null
                              ? "Tap the floating plus button to save your first feeling."
                              : "This is your latest emotional check-in.",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            height: 1.55,
                            color: AppColors.textSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StickerBubble extends StatelessWidget {
  final String emoji;
  final Color color;

  const _StickerBubble({
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.76),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.96),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.26),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 22),
      ),
    );
  }
}

class _CuteInsightCard extends StatelessWidget {
  final String insight;

  const _CuteInsightCard({
    required this.insight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.mint,
            AppColors.paleBlue,
            AppColors.blush,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: Colors.white.withOpacity(0.92),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.lakeBlue.withOpacity(0.16),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🧸",
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              insight,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.65,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CuteMiniCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;

  const _CuteMiniCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 134,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.74),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withOpacity(0.92),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 28),
          ),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textSoft,
            ),
          ),
        ],
      ),
    );
  }
}

class _CuteWellnessShortcut extends StatelessWidget {
  const _CuteWellnessShortcut();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.lavender,
            AppColors.paleBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: Colors.white.withOpacity(0.92),
        ),
      ),
      child: Row(
        children: [
          const Text(
            "🧘",
            style: TextStyle(fontSize: 36),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "Need a tiny reset? Visit Wellness for music, movement, and comfort.",
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _SoftBlob({
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




