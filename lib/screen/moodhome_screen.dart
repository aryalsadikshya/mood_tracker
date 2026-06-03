import 'package:flutter/material.dart';
import '../models/mood.dart';
import '../services/mood_storage.dart';

class MoodHomeScreen extends StatefulWidget {
  const MoodHomeScreen({super.key});

  @override
  State<MoodHomeScreen> createState() => _MoodHomeScreenState();
}

class _MoodHomeScreenState extends State<MoodHomeScreen> {
  String selectedMood = "";

  List<Mood> history = [];

  final List<Map<String, dynamic>> moods = [
    {"emoji": "😄", "label": "Great", "color": Color(0xFFFFE0AC)},
    {"emoji": "🙂", "label": "Good", "color": Color(0xFFB5EAD7)},
    {"emoji": "😐", "label": "Okay", "color": Color(0xFFC7CEEA)},
    {"emoji": "😔", "label": "Low", "color": Color(0xFFFFB7B2)},
    {"emoji": "😩", "label": "Stressed", "color": Color(0xFFD5AAFF)},
  ];

  @override
  void initState() {
    super.initState();
    loadMoods();
  }

  void loadMoods() async {
    final data = await MoodStorage.loadMoods();
    setState(() {
      history = data;
    });
  }
  void addMoodWithNote() {
    if (selectedMood.isEmpty) return;

    String note = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add Note"),
              TextField(
                onChanged: (value) => note = value,
                decoration: const InputDecoration(
                  hintText: "Write something about your day...",
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final newMood = Mood(
                    mood: selectedMood,
                    date: DateTime.now().toIso8601String(),
                    note: note,
                  );

                  setState(() {
                    history.insert(0, newMood);
                    selectedMood = "";
                  });

                  await MoodStorage.saveMoods(history);

                  Navigator.pop(context);
                },
                child: const Text("Save"),
              )
            ],
          ),
        );
      },
    );
  }


  /// 📊 Analytics
  Map<String, int> getStats() {
    Map<String, int> stats = {};
    for (var m in history) {
      stats[m.mood] = (stats[m.mood] ?? 0) + 1;
    }
    return stats;
  }

  /// 🔥 Streak
  int getStreak() {
    if (history.isEmpty) return 0;

    int streak = 1;

    for (int i = 1; i < history.length; i++) {
      DateTime prev = DateTime.parse(history[i - 1].date);
      DateTime curr = DateTime.parse(history[i].date);

      if (prev.difference(curr).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  @override
  Widget build(BuildContext context) {
    final stats = getStats();

    return Scaffold(
      appBar: AppBar(title: const Text("Mood Tracker")),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8F7FC),
                Color(0xFFEDE7F6),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView( // ✅ FULL PAGE SCROLL
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Track your mood today",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 18),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    ),
                    child: Text(
                      selectedMood.isEmpty
                          ? "How are you feeling today?"
                          : "You're feeling $selectedMood today",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Mood Cards
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: moods.map((mood) {
                      final isSelected = selectedMood == mood["label"];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMood = mood["label"];
                          });
                        },
                        child: AnimatedScale(
                          scale: isSelected ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 14),
                            decoration: BoxDecoration(
                              color: mood["color"].withOpacity(0.6),
                              borderRadius: BorderRadius.circular(24),
                              border: isSelected
                                  ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.5)
                                  : null,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(mood["emoji"],
                                    style: const TextStyle(fontSize: 26)),
                                const SizedBox(height: 6),
                                Text(
                                  mood["label"],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  /// Save Button
                  Center(
                    child: ElevatedButton(
                      onPressed: addMoodWithNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Log Mood"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔥 Streak
                  Text(
                    "🔥 Streak: ${getStreak()} days",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 10),

                  /// 📊 Stats
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: stats.entries.map((e) {
                      return Text(
                        "${e.key} - ${e.value} times",
                        style:
                        Theme.of(context).textTheme.bodySmall,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "History",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 10),

                  /// ✅ HISTORY LIST FIXED
                  history.isEmpty
                      ? Column(
                    children: const [
                      Icon(Icons.mood_bad,
                          size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("No moods logged yet"),
                      Text("Start tracking your feelings today"),
                    ],
                  )
                      : ListView.builder(
                    shrinkWrap: true, // ✅ IMPORTANT
                    physics:
                    const NeverScrollableScrollPhysics(), // ✅ IMPORTANT
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];

                      return Dismissible(
                        key: Key(item.date),
                        onDismissed: (direction) async {
                          setState(() {
                            history.removeAt(index);
                          });

                          await MoodStorage.saveMoods(history);
                        },
                        background:
                        Container(color: Colors.red),
                        child: Container(
                          margin:
                          const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color:
                            Theme
                                .of(context)
                                .cardColor,
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.mood,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleMedium,
                              ),
                              if (item.note != null &&
                                  item.note!.isNotEmpty)
                                Text(
                                  item.note!,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              Text(
                                item.date.substring(0, 10),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodySmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  } }