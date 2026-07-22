import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  late AnimationController controller;
  late Animation<double> floatAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    floatAnimation = Tween<double>(
      begin: -5,
      end: 5,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  String greetingMessage() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Start softly. Check in with yourself.";
    }

    if (hour < 17) {
      return "A small pause can reset your whole day.";
    }

    return "Let today settle gently.";
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

  List<Color> moodBackground(MoodModel? mood, bool isDark) {
    if (isDark) {
      switch (mood?.moodLabel) {
        case "Happy":
          return [
            AppColors.nightBlush,
            AppColors.nightCardSoft,
            AppColors.nightBackground,
          ];
        case "Calm":
          return [
            AppColors.nightMint,
            AppColors.nightBlue,
            AppColors.nightBackground,
          ];
        case "Okay":
          return [
            AppColors.nightLavender,
            AppColors.nightCardSoft,
            AppColors.nightBackground,
          ];
        case "Low":
          return [
            AppColors.nightBlue,
            AppColors.nightCard,
            AppColors.nightBackground,
          ];
        case "Stressed":
          return [
            AppColors.nightLavender,
            AppColors.nightCardSoft,
            AppColors.nightBackground,
          ];
        default:
          return [
            AppColors.nightLavender,
            AppColors.nightBlue,
            AppColors.nightBackground,
          ];
      }
    }

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

  List<_WeeklyMoodData> buildWeeklyOverview(
      List<MoodModel> moods,
      bool isDark,
      ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final monday = today.subtract(
      Duration(days: today.weekday - DateTime.monday),
    );

    final dayNames = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ];

    return List.generate(7, (index) {
      final date = monday.add(Duration(days: index));

      MoodModel? moodForDay;

      for (final mood in moods) {
        final moodDate = DateTime(
          mood.createdAt.year,
          mood.createdAt.month,
          mood.createdAt.day,
        );

        if (moodDate.year == date.year &&
            moodDate.month == date.month &&
            moodDate.day == date.day) {
          moodForDay = mood;
          break;
        }
      }

      return _WeeklyMoodData(
        day: dayNames[index],
        emoji: moodForDay?.moodEmoji ?? "♡",
        label: moodForDay?.moodLabel ?? "No check-in",
        color: moodForDay == null
            ? isDark
            ? AppColors.nightCardSoft
            : Colors.white.withOpacity(0.60)
            : moodColor(moodForDay.moodLabel),
        isToday: date.year == today.year &&
            date.month == today.month &&
            date.day == today.day,
        hasMood: moodForDay != null,
      );
    });
  }

  int weeklyEntries(List<MoodModel> moods) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final monday = today.subtract(
      Duration(days: today.weekday - DateTime.monday),
    );

    int count = 0;

    for (final mood in moods) {
      final moodDate = DateTime(
        mood.createdAt.year,
        mood.createdAt.month,
        mood.createdAt.day,
      );

      if (!moodDate.isBefore(monday) && !moodDate.isAfter(today)) {
        count++;
      }
    }

    return count;
  }

  double averageMood(List<MoodModel> moods) {
    if (moods.isEmpty) return 0;

    final recent = moods.take(7).toList();

    final total = recent.fold<int>(
      0,
          (sum, mood) => sum + mood.moodValue,
    );

    return total / recent.length;
  }

  String averageMoodText(double average) {
    if (average == 0) return "Not enough data yet";
    if (average >= 4.3) return "Bright week";
    if (average >= 3.5) return "Gentle week";
    if (average >= 2.5) return "Mixed week";
    return "Soft recovery week";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder<List<MoodModel>>(
        stream: moodService.getMoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoading(
              message: "Opening your soft space...",
            );
          }

          final moods = snapshot.data ?? [];
          final latestMood = moods.isEmpty ? null : moods.first;

          final color = latestMood == null
              ? isDark
              ? AppColors.nightLavender
              : AppColors.lavender
              : moodColor(latestMood.moodLabel);

          final weeklyData = buildWeeklyOverview(moods, isDark);
          final streak = StreakService.calculateStreak(moods);
          final entriesThisWeek = weeklyEntries(moods);
          final moodAverage = averageMood(moods);

          return Stack(
            children: [
              _AnimatedPastelBackground(
                colors: moodBackground(latestMood, isDark),
                animation: controller,
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 125),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _GreetingHeader(
                        greeting: greeting(),
                        message: greetingMessage(),
                      ),
                      const SizedBox(height: 24),
                      AnimatedBuilder(
                        animation: floatAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, floatAnimation.value),
                            child: _MoodAndWeeklyCard(
                              mood: latestMood,
                              color: color,
                              weeklyData: weeklyData,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: _SoftStatCard(
                              emoji: "🌷",
                              title: "$streak Day",
                              subtitle: "Reflection streak",
                              color: isDark
                                  ? AppColors.nightBlush
                                  : AppColors.blush,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _SoftStatCard(
                              emoji: "🫧",
                              title: "$entriesThisWeek Logs",
                              subtitle: "This week",
                              color: isDark
                                  ? AppColors.nightBlue
                                  : AppColors.paleBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _InsightCard(
                        insight: MoodAnalyzer.getInsight(moods),
                        weeklyTone: averageMoodText(moodAverage),
                      ),
                      const SizedBox(height: 18),
                      const _TinyResetCard(),
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

class _AnimatedPastelBackground extends StatelessWidget {
  final List<Color> colors;
  final Animation<double> animation;

  const _AnimatedPastelBackground({
    required this.colors,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors[0].withOpacity(isDark ? 0.26 : 0.72),
                    colors[1].withOpacity(isDark ? 0.22 : 0.60),
                    colors[2].withOpacity(isDark ? 1 : 0.84),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _CuteFloatingPainter(
                  animation.value,
                  isDark: isDark,
                ),
              ),
            ),
            Positioned(
              top: -80 + animation.value * 24,
              right: -70,
              child: _SoftBlob(
                color: colors[0].withOpacity(isDark ? 0.18 : 0.46),
                size: 260,
              ),
            ),
            Positioned(
              bottom: 110 - animation.value * 24,
              left: -90,
              child: _SoftBlob(
                color: colors[1].withOpacity(isDark ? 0.16 : 0.44),
                size: 270,
              ),
            ),
            Positioned(
              top: 310 + animation.value * 16,
              right: -90,
              child: _SoftBlob(
                color: colors[2].withOpacity(isDark ? 0.18 : 0.40),
                size: 230,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CuteFloatingPainter extends CustomPainter {
  final double value;
  final bool isDark;

  _CuteFloatingPainter(
      this.value, {
        required this.isDark,
      });

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(21);

    final icons = [
      "♡",
      "✦",
      "✧",
      "˚",
      "•",
    ];

    final colors = isDark
        ? [
      Colors.white.withOpacity(0.18),
      AppColors.nightLavender.withOpacity(0.20),
      AppColors.nightBlue.withOpacity(0.18),
      AppColors.nightBlush.withOpacity(0.16),
      AppColors.nightMint.withOpacity(0.14),
    ]
        : [
      Colors.white.withOpacity(0.50),
      AppColors.blush.withOpacity(0.34),
      AppColors.lavender.withOpacity(0.34),
      AppColors.paleBlue.withOpacity(0.34),
      AppColors.mint.withOpacity(0.30),
    ];

    for (int i = 0; i < 42; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: icons[i % icons.length],
          style: TextStyle(
            color: colors[i % colors.length],
            fontSize: 10 + random.nextDouble() * 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      final dx = random.nextDouble() * size.width;
      final dy =
          random.nextDouble() * size.height + sin(value * pi * 2 + i) * 12;

      textPainter.paint(
        canvas,
        Offset(dx, dy),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CuteFloatingPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.isDark != isDark;
  }
}
class _GreetingHeader extends StatelessWidget {
  final String greeting;
  final String message;

  const _GreetingHeader({
    required this.greeting,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor =
        Theme.of(context).textTheme.headlineMedium?.color ?? AppColors.textDark;

    final softTextColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSoft;

    return Row(
      children: [
        Container(
          height: 62,
          width: 62,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.nightCardSoft.withOpacity(0.92)
                : Colors.white.withOpacity(0.58),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? AppColors.nightBorder
                  : Colors.white.withOpacity(0.94),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.22)
                    : AppColors.softPurple.withOpacity(0.16),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            "🌸",
            style: TextStyle(fontSize: 34),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.nightCard.withOpacity(0.92)
                  : Colors.white.withOpacity(0.52),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark
                    ? AppColors.nightBorder
                    : Colors.white.withOpacity(0.88),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.18)
                      : AppColors.softPurple.withOpacity(0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 31,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: softTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MoodAndWeeklyCard extends StatelessWidget {
  final MoodModel? mood;
  final Color color;
  final List<_WeeklyMoodData> weeklyData;

  const _MoodAndWeeklyCard({
    required this.mood,
    required this.color,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final displayEmoji = mood?.moodEmoji ?? "🌱";
    final displayMood = mood?.moodLabel ?? "Blooming";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
            AppColors.nightCardSoft.withOpacity(0.96),
            AppColors.nightCard.withOpacity(0.98),
            AppColors.nightBackground.withOpacity(0.96),
          ]
              : [
            color.withOpacity(0.76),
            Colors.white.withOpacity(0.66),
            AppColors.cream.withOpacity(0.80),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(42),
        border: Border.all(
          color: isDark ? AppColors.nightBorder : Colors.white.withOpacity(0.94),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.28)
                : color.withOpacity(0.34),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            right: 6,
            child: _StickerBubble(
              emoji: "✦",
              color: isDark ? AppColors.nightLavender : AppColors.warmYellow,
            ),
          ),
          Positioned(
            top: 72,
            right: 36,
            child: _StickerBubble(
              emoji: "♡",
              color: isDark ? AppColors.nightBlue : AppColors.paleBlue,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TodayMoodSection(
                emoji: displayEmoji,
                mood: displayMood,
                color: color,
                hasMood: mood != null,
              ),
              const SizedBox(height: 22),
              Container(
                height: 1,
                width: double.infinity,
                color: isDark
                    ? AppColors.nightBorder
                    : Colors.white.withOpacity(0.62),
              ),
              const SizedBox(height: 20),
              _WeeklyOverviewSection(
                weeklyData: weeklyData,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TodayMoodSection extends StatelessWidget {
  final String emoji;
  final String mood;
  final Color color;
  final bool hasMood;

  const _TodayMoodSection({
    required this.emoji,
    required this.mood,
    required this.color,
    required this.hasMood,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor =
        Theme.of(context).textTheme.headlineMedium?.color ?? AppColors.textDark;

    final softTextColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSoft;

    return Row(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(
            begin: 0.94,
            end: 1.0,
          ),
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                height: 98,
                width: 98,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.nightCardSoft.withOpacity(0.88)
                      : Colors.white.withOpacity(0.60),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: isDark
                        ? AppColors.nightBorder
                        : Colors.white.withOpacity(0.94),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.20)
                          : color.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 55),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mood,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hasMood
                    ? "Your latest check-in is shaping today’s space."
                    : "Tap the plus button to save your first feeling.",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  height: 1.45,
                  color: softTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeeklyOverviewSection extends StatelessWidget {
  final List<_WeeklyMoodData> weeklyData;

  const _WeeklyOverviewSection({
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Weekly At-A-Glance",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.nightCardSoft
                    : Colors.white.withValues(alpha: 0.50),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "7 days",
                maxLines: 1,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.nightBlue
                      : AppColors.deepBlue,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          children: weeklyData.map((item) {
            return Expanded(
              child: Center(
                child: _WeeklyMoodBubble(
                  data: item,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _WeeklyMoodBubble extends StatelessWidget {
  final _WeeklyMoodData data;

  const _WeeklyMoodBubble({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          height: data.isToday ? 48 : 42,
          width: data.isToday ? 48 : 42,
          decoration: BoxDecoration(
            color: data.color.withOpacity(data.hasMood ? 0.86 : 0.58),
            shape: BoxShape.circle,
            border: Border.all(
              color: data.isToday
                  ? isDark
                  ? AppColors.nightBlue
                  : AppColors.deepBlue
                  : isDark
                  ? AppColors.nightBorder
                  : Colors.white.withOpacity(0.92),
              width: data.isToday ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: data.color.withOpacity(isDark ? 0.10 : 0.24),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            data.emoji,
            style: TextStyle(
              fontSize: data.hasMood ? 22 : 18,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.nightText : AppColors.deepBlue,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.day,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: data.isToday ? FontWeight.w800 : FontWeight.w500,
            color: data.isToday
                ? isDark
                ? AppColors.nightBlue
                : AppColors.deepBlue
                : Theme.of(context).textTheme.bodyMedium?.color ??
                AppColors.textSoft,
          ),
        ),
      ],
    );
  }
}

class _SoftStatCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;

  const _SoftStatCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textDark;

    final softTextColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSoft;

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0.96,
        end: 1,
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            height: 132,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                  AppColors.nightCardSoft,
                  AppColors.nightCard,
                ]
                    : [
                  color.withOpacity(0.86),
                  Colors.white.withOpacity(0.66),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: isDark
                    ? AppColors.nightBorder
                    : Colors.white.withOpacity(0.94),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.24)
                      : color.withOpacity(0.28),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 30),
                ),
                const Spacer(),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: softTextColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String insight;
  final String weeklyTone;

  const _InsightCard({
    required this.insight,
    required this.weeklyTone,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textDark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
            AppColors.nightCard,
            AppColors.nightCardSoft,
            AppColors.nightBackground,
          ]
              : const [
            AppColors.mint,
            AppColors.paleBlue,
            AppColors.blush,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: isDark ? AppColors.nightBorder : Colors.white.withOpacity(0.94),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.24)
                : AppColors.lakeBlue.withOpacity(0.16),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.nightCardSoft
                  : Colors.white.withOpacity(0.54),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              "🧸",
              style: TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weeklyTone,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  insight,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 1.6,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyResetCard extends StatelessWidget {
  const _TinyResetCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textDark;

    final softTextColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSoft;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.nightCard : Colors.white.withOpacity(0.60),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: isDark ? AppColors.nightBorder : Colors.white.withOpacity(0.94),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.22)
                : AppColors.softPurple.withOpacity(0.12),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: isDark ? AppColors.nightCardSoft : AppColors.lavender,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              "🫧",
              style: TextStyle(fontSize: 29),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tiny Reset",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Need a softer moment? Visit Wellness for breathing, music, and comfort.",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    height: 1.5,
                    color: softTextColor,
                  ),
                ),
              ],
            ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 43,
      width: 43,
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.28 : 0.72),
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? AppColors.nightBorder : Colors.white.withOpacity(0.96),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.16)
                : color.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        emoji,
        style: GoogleFonts.poppins(
          fontSize: 19,
          fontWeight: FontWeight.w900,
          color: isDark ? AppColors.nightText : AppColors.deepBlue,
        ),
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

class _WeeklyMoodData {
  final String day;
  final String emoji;
  final String label;
  final Color color;
  final bool isToday;
  final bool hasMood;

  _WeeklyMoodData({
    required this.day,
    required this.emoji,
    required this.label,
    required this.color,
    required this.isToday,
    required this.hasMood,
  });
}


