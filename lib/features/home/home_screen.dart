import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_tracker/features/home/widget/history_shortcut_card.dart';
import 'package:mood_tracker/features/home/widget/home_header.dart';
import 'package:mood_tracker/features/home/widget/insight_card.dart';
import 'package:mood_tracker/features/home/widget/latest_mood_card.dart';
import 'package:mood_tracker/features/home/widget/quick_action_card.dart';
import 'package:mood_tracker/features/home/widget/reflection_card.dart';
import 'package:mood_tracker/features/home/widget/streak_card.dart';
import '../mood/mood_analyzer.dart';
import '../../core/theme/app_colours.dart';
import '../mood/mood_model.dart';
import '../mood/mood_service.dart';
import '../mood/streak_service.dart';
import '../memory/memory_service.dart';
import '../memory/widgets/best_memory_card.dart';




class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  String getSubGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Begin gently. Your day does not need to be rushed.";
    if (hour < 17) return "Take a quiet pause and check in with yourself.";
    return "Slow down. Let today settle softly.";
  }

  String getReflectionPrompt() {
    final prompts = [
      "What emotion is asking for your attention today?",
      "What small moment made today feel lighter?",
      "What are you ready to let go of?",
      "What would your mind thank you for right now?",
      "What helped you feel safe or calm today?",
    ];
    prompts.shuffle();
    return prompts.first;
  }

  String formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour == 0 ? 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    final MoodService moodService = MoodService();
    final memoryService = MemoryService();

    return Scaffold(
      backgroundColor: AppColors.cream,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                greeting: getGreeting(),
                subGreeting: getSubGreeting(),
              ),
              const SizedBox(height: 28),
              ReflectionCard(prompt: getReflectionPrompt()),
              const SizedBox(height: 24),
              StreamBuilder<List<MoodModel>>(
                stream: moodService.getMoods(),
                builder: (context, snapshot) {
                  final moods = snapshot.data ?? [];
                  final bestMemory =
                  memoryService.getBestMemory(moods);

                  return Column(
                    children: [
                      moods.isEmpty
                          ? const EmptyLastMoodCard()
                          : LatestMoodCard(
                        mood: moods.first,
                        time: formatTime(moods.first.createdAt),
                      ),

                      const SizedBox(height: 20),

                      StreakCard(
                        streak: StreakService.calculateStreak(moods),
                      ),

                      const SizedBox(height: 24),

                      InsightCard(
                        insight: MoodAnalyzer.getInsight(moods),
                        recommendation: MoodAnalyzer.getRecommendation(moods),
                      ),
                      if (bestMemory != null) ...[
                        const SizedBox(height: 24),

                        BestMemoryCard(
                          memory: bestMemory,
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              Text(
                "Quick Wellness Actions",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 122,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    QuickActionCard(
                      title: "Breath",
                      subtitle: "1 min",
                      icon: Icons.air_rounded,
                      color: AppColors.paleBlue,
                    ),
                    QuickActionCard(
                      title: "Journal",
                      subtitle: "Reflect",
                      icon: Icons.edit_note_rounded,
                      color: AppColors.softPink,
                    ),
                    QuickActionCard(
                      title: "Calm",
                      subtitle: "Reset",
                      icon: Icons.spa_rounded,
                      color: AppColors.mint,
                    ),
                    QuickActionCard(
                      title: "Rest",
                      subtitle: "Pause",
                      icon: Icons.nightlight_round,
                      color: AppColors.lavender,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const HistoryShortcutCard(),
            ],
          ),
        ),
      ),

    );
  }
}




