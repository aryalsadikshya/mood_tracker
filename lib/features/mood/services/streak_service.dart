import '../models/mood_model.dart';

class StreakService {
  static int calculateStreak(List<MoodModel> moods) {
    if (moods.isEmpty) return 0;

    final uniqueDays = moods
        .map(
          (mood) => DateTime(
        mood.createdAt.year,
        mood.createdAt.month,
        mood.createdAt.day,
      ),
    )
        .toSet()
        .toList();

    uniqueDays.sort((a, b) => b.compareTo(a));

    int streak = 0;

    DateTime current = DateTime.now();

    current = DateTime(
      current.year,
      current.month,
      current.day,
    );

    for (final day in uniqueDays) {
      final difference = current.difference(day).inDays;

      if (difference == streak) {
        streak++;
      } else {
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