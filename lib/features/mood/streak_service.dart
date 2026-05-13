import 'mood_model.dart';

class StreakService {
  static int calculateStreak(List<MoodModel> moods) {
    if (moods.isEmpty) return 0;

    int streak = 0;

    DateTime current = DateTime.now();

    // Normalize to date only
    current = DateTime(current.year, current.month, current.day);

    for (int i = 0; i < moods.length; i++) {
      final moodDate = DateTime(
        moods[i].createdAt.year,
        moods[i].createdAt.month,
        moods[i].createdAt.day,
      );

      final difference = current.difference(moodDate).inDays;

      if (difference == streak) {
        streak++;
      } else if (difference > streak) {
        break;
      }
    }

    return streak;
  }

  static String streakMessage(int streak) {
    if (streak == 0) return "Start your journey today";
    if (streak == 1) return "A gentle beginning";
    if (streak < 5) return "$streak days of showing up";
    if (streak < 10) return "$streak days of consistency";
    if (streak < 20) return "$streak days of growth";
    return "$streak days of commitment";
  }
}