import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/navigation/soft_page_route.dart';
import '../../core/theme/app_colours.dart';
import '../achievements/achievement_screen.dart';
import '../mood/models/mood_model.dart';
import '../mood/services/mood_service.dart';
import '../mood/services/streak_service.dart';
import 'mood_calendar_screen.dart';
import 'mood_trend_screen.dart';
import 'emotional_constellation_screen.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  double getAverageMood(List<MoodModel> moods) {
    if (moods.isEmpty) return 0;

    final total = moods.fold<int>(
      0,
          (sum, mood) => sum + mood.moodValue,
    );

    return total / moods.length;
  }

  String getAverageMoodText(double average) {
    if (average == 0) return "--";
    return average.toStringAsFixed(1);
  }

  String getInsightTitle(List<MoodModel> moods) {
    if (moods.isEmpty) {
      return "Your insights are waiting";
    }

    final average = getAverageMood(moods);

    if (average >= 4.2) return "Your recent mood looks bright";
    if (average >= 3.2) return "Your emotional rhythm looks balanced";
    if (average >= 2.3) return "Your mood has been shifting lately";
    return "Your recent days may need gentler attention";
  }

  String getInsightSubtitle(List<MoodModel> moods) {
    if (moods.isEmpty) {
      return "Start logging moods to unlock your emotional patterns.";
    }

    final latest = moods.first;

    return "Latest check-in: ${latest.moodEmoji} ${latest.moodLabel}";
  }

  @override
  Widget build(BuildContext context) {
    final MoodService moodService = MoodService();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: StreamBuilder<List<MoodModel>>(
          stream: moodService.getMoods(),
          builder: (context, snapshot) {
            final moods = snapshot.data ?? [];
            final averageMood = getAverageMood(moods);
            final streak = StreakService.calculateStreak(moods);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Insights",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                      height: 1.05,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Understand your emotional patterns through gentle, visual reflection.",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textSoft,
                    ),
                  ),

                  const SizedBox(height: 26),

                  _InsightHeroCard(
                    title: getInsightTitle(moods),
                    subtitle: getInsightSubtitle(moods),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _MiniStatCard(
                          title: "Entries",
                          value: moods.length.toString(),
                          color: AppColors.softPink,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MiniStatCard(
                          title: "Average",
                          value: getAverageMoodText(averageMood),
                          color: AppColors.mint,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MiniStatCard(
                          title: "Rhythm",
                          value: "$streak",
                          color: AppColors.paleBlue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Explore",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 16),
                  _InsightFeatureCard(
                    title: "Emotional Constellation",
                    subtitle: "Revisit your latest mood memories as a soft visual sky.",
                    icon: Icons.auto_awesome_rounded,
                    color: AppColors.paleBlue,
                    onTap: () {
                      openSoftPage(
                        context,
                        const EmotionalConstellationScreen(),
                      );
                    },
                  ),


                  _InsightFeatureCard(
                    title: "Mood Calendar",
                    subtitle: "View your emotional patterns across days.",
                    icon: Icons.calendar_month_rounded,
                    color: AppColors.lavender,
                    onTap: () {
                      openSoftPage(
                        context,
                        const MoodCalendarScreen(),
                      );
                    },
                  ),

                  _InsightFeatureCard(
                    title: "Mood Trends",
                    subtitle: "See how your mood direction changes over time.",
                    icon: Icons.insights_rounded,
                    color: AppColors.mint,
                    onTap: () {
                      openSoftPage(
                        context,
                        const MoodTrendScreen(),
                      );
                    },
                  ),

                  _InsightFeatureCard(
                    title: "Achievements",
                    subtitle: "Track milestones from your reflection journey.",
                    icon: Icons.workspace_premium_rounded,
                    color: AppColors.blush,
                    onTap: () {
                      openSoftPage(
                        context,
                        const AchievementScreen(),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InsightHeroCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _InsightHeroCard({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
        borderRadius: BorderRadius.circular(36),
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withOpacity(0.22),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            size: 30,
            color: AppColors.deepBlue,
          ),

          const SizedBox(height: 18),

          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1.15,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSoft,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MiniStatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.72),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.85),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
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

class _InsightFeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _InsightFeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.whiteGlass,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withOpacity(0.9),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.20),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.78),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.deepBlue,
                  size: 27,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        height: 1.45,
                        color: AppColors.textSoft,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.deepBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}