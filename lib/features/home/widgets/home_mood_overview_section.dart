import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_loading.dart';
import '../../memory/memory_service.dart';
import '../../memory/widgets/best_memory_card.dart';
import '../../mood/models/mood_model.dart';
import '../../mood/services/mood_analyzer.dart';
import '../../mood/services/mood_service.dart';
import '../../mood/services/streak_service.dart';
import '../helpers/home_helpers.dart';
import 'insight_card.dart';
import 'latest_mood_card.dart';
import 'streak_card.dart';

class HomeMoodOverviewSection extends StatelessWidget {
  const HomeMoodOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final MoodService moodService = MoodService();
    final MemoryService memoryService = MemoryService();

    return StreamBuilder<List<MoodModel>>(
      stream: moodService.getMoods(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppLoading(
            message: "Loading your reflection space...",
          );
        }

        if (snapshot.hasError) {
          return const Text(
            "Something went wrong while loading your mood data.",
          );
        }

        final moods = snapshot.data ?? [];
        final bestMemory = memoryService.getBestMemory(moods);

        return Column(
          children: [
            moods.isEmpty
                ? const EmptyLastMoodCard()
                : LatestMoodCard(
              mood: moods.first,
              time: HomeHelpers.formatTime(
                moods.first.createdAt,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            StreakCard(
              streak: StreakService.calculateStreak(moods),
            ),

            const SizedBox(height: AppSpacing.lg),

            InsightCard(
              insight: MoodAnalyzer.getInsight(moods),
              recommendation: MoodAnalyzer.getRecommendation(moods),
            ),

            if (bestMemory != null) ...[
              const SizedBox(height: AppSpacing.lg),
              BestMemoryCard(memory: bestMemory),
            ],
          ],
        );
      },
    );
  }
}