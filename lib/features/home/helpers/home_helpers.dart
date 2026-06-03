class HomeHelpers {
  static String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  static String getSubGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Begin gently. Your day does not need to be rushed.";
    }

    if (hour < 17) {
      return "Take a quiet pause and check in with yourself.";
    }

    return "Slow down. Let today settle softly.";
  }

  static String getReflectionPrompt() {
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

  static String formatTime(DateTime date) {
    final hour = date.hour > 12
        ? date.hour - 12
        : date.hour == 0
        ? 12
        : date.hour;

    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? "PM" : "AM";

    return "$hour:$minute $period";
  }
}