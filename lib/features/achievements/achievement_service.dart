import '../mood/mood_model.dart';
import '../mood/streak_service.dart';
import 'achievement_model.dart';

class AchievementService {
  static List<AchievementModel> getAchievements(
      List<MoodModel> moods,
      ) {
    final streak = StreakService.calculateStreak(moods);

    final calmCount =
        moods.where((m) => m.moodLabel == "Calm").length;

    return [
      AchievementModel(
        title: "First Reflection",
        description: "Log your first mood entry",
        emoji: "🌱",
        unlocked: moods.isNotEmpty,
      ),

      AchievementModel(
        title: "3 Day Streak",
        description: "Show up 3 days in a row",
        emoji: "🔥",
        unlocked: streak >= 3,
      ),

      AchievementModel(
        title: "7 Day Journey",
        description: "Maintain a 7 day streak",
        emoji: "🌙",
        unlocked: streak >= 7,
      ),

      AchievementModel(
        title: "30 Reflections",
        description: "Log 30 mood entries",
        emoji: "🌸",
        unlocked: moods.length >= 30,
      ),

      AchievementModel(
        title: "Calm Mind",
        description: "Log calm moods 10 times",
        emoji: "🧘",
        unlocked: calmCount >= 10,
      ),
    ];
  }
}