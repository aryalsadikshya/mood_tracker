
import '../mood/models/mood_model.dart';
import 'memory_model.dart';

class MemoryService {
  MemoryCardData? getBestMemory(List<MoodModel> moods) {
    if (moods.isEmpty) return null;

    final positiveMoods = moods.where((mood) {
      return mood.hasNote && mood.isPositiveMood;
    }).toList();

    if (positiveMoods.isEmpty) return null;

    positiveMoods.sort(
          (a, b) {
        final scoreA = _memoryScore(a);
        final scoreB = _memoryScore(b);

        return scoreB.compareTo(scoreA);
      },
    );

    final best = positiveMoods.first;

    return MemoryCardData(
      mood: "${best.moodEmoji} ${best.moodLabel}",
      note: best.note,
      date: best.createdAt,
      moodValue: best.moodValue,
    );
  }

  int _memoryScore(MoodModel mood) {
    int score = 0;

    score += mood.moodValue * 10;

    if (mood.note.length > 80) {
      score += 20;
    }

    if (mood.activities.isNotEmpty) {
      score += 10;
    }

    return score;
  }
}