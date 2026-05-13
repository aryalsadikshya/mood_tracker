import '../mood/mood_model.dart';
import 'memory_model.dart';

class MemoryService {
  MemoryCardData? getBestMemory(List<MoodModel> moods) {
    if (moods.isEmpty) return null;

    final positiveMoods = moods.where((mood) {
      final hasNote = mood.note.trim().isNotEmpty;
      final isPositiveMood =
          mood.moodLabel == "Happy" || mood.moodLabel == "Calm";

      return hasNote && isPositiveMood;
    }).toList();

    if (positiveMoods.isEmpty) return null;

    positiveMoods.sort(
          (a, b) => b.moodValue.compareTo(a.moodValue),
    );

    final best = positiveMoods.first;

    return MemoryCardData(
      mood: "${best.moodEmoji} ${best.moodLabel}",
      note: best.note,
      date: best.createdAt,
      moodValue: best.moodValue,
    );
  }
}