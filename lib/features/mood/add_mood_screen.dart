import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colours.dart';
import 'mood_model.dart';
import 'mood_service.dart';

class AddMoodScreen extends StatefulWidget {
  const AddMoodScreen({super.key});

  @override
  State<AddMoodScreen> createState() => _AddMoodScreenState();
}

class _AddMoodScreenState extends State<AddMoodScreen> {
  final MoodService moodService = MoodService();
  final TextEditingController noteController = TextEditingController();

  String selectedMoodEmoji = "";
  String selectedMoodLabel = "";
  int selectedMoodValue = 0;
  bool isSaving = false;

  final List<String> selectedActivities = [];

  final moods = [
    {"emoji": "😊", "label": "Happy", "value": 5, "color": AppColors.softPink},
    {"emoji": "😌", "label": "Calm", "value": 4, "color": AppColors.mint},
    {"emoji": "🙂", "label": "Okay", "value": 3, "color": AppColors.warmYellow},
    {"emoji": "😔", "label": "Low", "value": 2, "color": AppColors.paleBlue},
    {"emoji": "😣", "label": "Stressed", "value": 1, "color": AppColors.softPurple},
  ];

  final activities = [
    {"name": "Study", "color": AppColors.paleBlue},
    {"name": "Sleep", "color": AppColors.mint},
    {"name": "Family", "color": AppColors.softPink},
    {"name": "Friends", "color": AppColors.warmYellow},
    {"name": "Exercise", "color": AppColors.sage},
    {"name": "Music", "color": AppColors.softPurple},
    {"name": "Food", "color": AppColors.peach},
    {"name": "Nature", "color": AppColors.sage},
    {"name": "Work", "color": AppColors.lavender},
    {"name": "Rest", "color": AppColors.blush},
  ];

  Future<void> saveMood() async {
    if (selectedMoodEmoji.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select a mood first")),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final mood = MoodModel(
        moodEmoji: selectedMoodEmoji,
        moodLabel: selectedMoodLabel,
        moodValue: selectedMoodValue,
        activities: selectedActivities,
        note: noteController.text.trim(),
        createdAt: DateTime.now(),
      );

      await moodService.addMood(mood);

      if (!mounted) return;

      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text("Daily Check-in")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "How are you feeling?",
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 10),

            Text(
              "Take a moment to reflect on your emotional state.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            /// MOOD CARDS
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: moods.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final mood = moods[index];
                  final isSelected = selectedMoodEmoji == mood["emoji"];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMoodEmoji = mood["emoji"] as String;
                        selectedMoodLabel = mood["label"] as String;
                        selectedMoodValue = mood["value"] as int;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 100,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? mood["color"] as Color
                            : AppColors.whiteGlass,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.deepBlue
                              : AppColors.border,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (mood["color"] as Color).withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(mood["emoji"] as String,
                              style: const TextStyle(fontSize: 30)),
                          const SizedBox(height: 8),
                          Text(
                            mood["label"] as String,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            /// ACTIVITIES
            Text(
              "What influenced it?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: activities.map((activity) {
                final selected = selectedActivities.contains(activity["name"]);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected
                          ? selectedActivities.remove(activity["name"])
                          : selectedActivities.add(activity["name"] as String);
                    });
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? activity["color"] as Color
                          : AppColors.whiteGlass,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      activity["name"] as String,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            /// NOTE BOX
            TextField(
              controller: noteController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Write your thoughts...",
              ),
            ),

            const SizedBox(height: 28),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveMood,
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Mood"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}