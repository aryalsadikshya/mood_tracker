class GeminiService {
  const GeminiService();

  Future<String> generateComfortReply({
    required String userMessage,
  }) async {
    final text = userMessage.toLowerCase().trim();

    await Future.delayed(
      const Duration(milliseconds: 850),
    );

    if (text.contains("exam") ||
        text.contains("study") ||
        text.contains("assignment") ||
        text.contains("college")) {
      return "Your mind is carrying a lot right now. You do not need to finish everything at once. Choose one small task and give it ten calm minutes.";
    }

    if (text.contains("sad") ||
        text.contains("low") ||
        text.contains("cry") ||
        text.contains("hurt")) {
      return "Today feels heavy, and that is okay. You do not have to force yourself to feel better immediately. Start with one soft breath and be gentle with yourself.";
    }

    if (text.contains("angry") ||
        text.contains("mad") ||
        text.contains("frustrated")) {
      return "That feeling is strong, but it does not have to control the whole moment. Give yourself a small pause before reacting.";
    }

    if (text.contains("alone") ||
        text.contains("lonely") ||
        text.contains("ignored")) {
      return "Lonely moments can feel very loud. You still matter. Reaching out to someone you trust with a simple message may make this moment feel less heavy.";
    }

    if (text.contains("stress") ||
        text.contains("anxious") ||
        text.contains("panic") ||
        text.contains("worried") ||
        text.contains("scared")) {
      return "Place both feet on the ground. Breathe in slowly and breathe out a little longer. This moment can become smaller one breath at a time.";
    }

    if (text.contains("tired") ||
        text.contains("sleep") ||
        text.contains("burnout") ||
        text.contains("exhausted")) {
      return "Your body may be asking for kindness, not more pressure. Drink some water, close your eyes for a moment, and let yourself slow down.";
    }

    if (text.contains("happy") ||
        text.contains("excited") ||
        text.contains("good")) {
      return "That is a meaningful moment. Let yourself enjoy it and remember what made today feel lighter.";
    }

    return "That sounds like something your mind has been holding quietly. You do not need a perfect answer right now. What would make the next five minutes feel gentler?";
  }
}