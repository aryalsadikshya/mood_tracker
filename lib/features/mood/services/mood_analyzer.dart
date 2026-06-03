import '../models/mood_model.dart';

class MoodAnalyzer {
  static String getInsight(List<MoodModel> moods) {
    if (moods.isEmpty) {
      return "Start by logging your first mood. Small reflections can become meaningful patterns over time.";
    }

    final recentMoods = moods.take(7).toList();

    final avgMood = recentMoods
        .map((mood) => mood.moodValue)
        .reduce((a, b) => a + b) /
        recentMoods.length;

    final stressedCount =
        recentMoods.where((mood) => mood.moodLabel == "Stressed").length;

    final lowCount =
        recentMoods.where((mood) => mood.moodLabel == "Low").length;

    final calmCount =
        recentMoods.where((mood) => mood.moodLabel == "Calm").length;

    final happyCount =
        recentMoods.where((mood) => mood.moodLabel == "Happy").length;

    if (stressedCount >= 3) {
      return "You have logged stress a few times recently. A short breathing pause or a slower routine may help you reset.";
    }

    if (lowCount >= 3) {
      return "You have had several low check-ins lately. Try writing one honest note about what has been weighing on you.";
    }

    if (happyCount >= 4) {
      return "Your recent mood pattern looks bright. Take a moment to notice what has been helping you feel this way.";
    }

    if (calmCount >= 4) {
      return "You seem to be finding calm lately. Keep protecting the habits and spaces that support that peace.";
    }

    if (avgMood >= 4) {
      return "Your recent mood trend looks positive. This may be a good time to reflect on what is working well.";
    }

    if (avgMood <= 2.3) {
      return "Your recent mood trend seems heavy. Keep things simple today and give yourself permission to slow down.";
    }

    return "Your mood pattern has been mixed recently. A quick check-in can help you understand what is changing day by day.";
  }

  static String getRecommendation(List<MoodModel> moods) {
    if (moods.isEmpty) {
      return "Log your first mood";
    }

    final latestMood = moods.first.moodLabel;

    switch (latestMood) {
      case "Stressed":
        return "Try 1-minute breathing";
      case "Low":
        return "Write a short journal note";
      case "Okay":
        return "Do a gentle reflection";
      case "Calm":
        return "Protect your quiet time";
      case "Happy":
        return "Save a gratitude note";
      default:
        return "Take a mindful pause";
    }
  }
}