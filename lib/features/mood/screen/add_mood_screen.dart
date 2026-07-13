import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colours.dart';
import '../models/mood_model.dart';
import '../services/mood_service.dart';

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
    {
      "emoji": "😊",
      "label": "Happy",
      "value": 5,
      "color": AppColors.softPink,
    },
    {
      "emoji": "😌",
      "label": "Calm",
      "value": 4,
      "color": AppColors.mint,
    },
    {
      "emoji": "🙂",
      "label": "Okay",
      "value": 3,
      "color": AppColors.warmYellow,
    },
    {
      "emoji": "😔",
      "label": "Low",
      "value": 2,
      "color": AppColors.paleBlue,
    },
    {
      "emoji": "😣",
      "label": "Stressed",
      "value": 1,
      "color": AppColors.softPurple,
    },
  ];

  final activities = [
    {
      "name": "Study",
      "color": AppColors.paleBlue,
    },
    {
      "name": "Sleep",
      "color": AppColors.mint,
    },
    {
      "name": "Family",
      "color": AppColors.softPink,
    },
    {
      "name": "Exam",
      "color": AppColors.warmYellow,
    },
    {
      "name": "Exercise",
      "color": AppColors.sage,
    },
    {
      "name": "Music",
      "color": AppColors.softPurple,
    },
    {
      "name": "Food",
      "color": AppColors.peach,
    },
    {
      "name": "Weather",
      "color": AppColors.sage,
    },
    {
      "name": "Work",
      "color": AppColors.lavender,
    },
    {
      "name": "Rest",
      "color": AppColors.blush,
    },
  ];

  Color get selectedMoodColor {
    if (selectedMoodEmoji.isEmpty) {
      return AppColors.lakeBlue;
    }

    final selectedMood = moods.firstWhere(
          (mood) => mood["emoji"] == selectedMoodEmoji,
    );

    return selectedMood["color"] as Color;
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  Future<void> saveMood() async {
    if (selectedMoodEmoji.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Select a mood first"),
        ),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

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
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final headingColor =
    isDark ? AppColors.nightText : AppColors.textDark;

    final softTextColor =
    isDark ? AppColors.nightTextSoft : AppColors.textSoft;

    final defaultCardColor = isDark
        ? AppColors.nightCard
        : Colors.white.withOpacity(0.55);

    final defaultBorderColor = isDark
        ? AppColors.nightBorder
        : Colors.white.withOpacity(0.7);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
        isDark ? AppColors.nightBackground : AppColors.cream,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.nightText : AppColors.deepBlue,
        ),
        title: Text(
          "Daily Check-in",
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.w700,
            color: headingColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How are you feeling?",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: headingColor,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Take a moment to reflect on your emotional state.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: softTextColor,
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              height: 125,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: moods.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final mood = moods[index];

                  final isSelected = selectedMoodEmoji == mood["emoji"];

                  final moodColor = mood["color"] as Color;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMoodEmoji = mood["emoji"] as String;
                        selectedMoodLabel = mood["label"] as String;
                        selectedMoodValue = mood["value"] as int;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 240),
                      width: 104,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? moodColor.withOpacity(isDark ? 0.30 : 0.22)
                            : defaultCardColor,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: isSelected
                              ? moodColor
                              : defaultBorderColor,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: moodColor.withOpacity(
                              isDark ? 0.22 : 0.35,
                            ),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mood["emoji"] as String,
                            style: const TextStyle(
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            mood["label"] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: headingColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            Text(
              "What influenced it?",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: headingColor,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 14),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: activities.map((activity) {
                final selected = selectedActivities.contains(
                  activity["name"],
                );

                final activityColor = activity["color"] as Color;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected
                          ? selectedActivities.remove(
                        activity["name"],
                      )
                          : selectedActivities.add(
                        activity["name"] as String,
                      );
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? activityColor.withOpacity(isDark ? 0.78 : 1)
                          : isDark
                          ? AppColors.nightCard
                          : AppColors.whiteGlass,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: selected
                            ? isDark
                            ? AppColors.nightBlue
                            : AppColors.deepBlue
                            : isDark
                            ? AppColors.nightBorder
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      activity["name"] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: selected && isDark
                            ? AppColors.nightBackground
                            : headingColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            TextField(
              controller: noteController,
              maxLines: 5,
              cursorColor:
              isDark ? AppColors.nightBlue : selectedMoodColor,
              style: GoogleFonts.poppins(
                color: headingColor,
                height: 1.6,
              ),
              decoration: InputDecoration(
                hintText: "Write a gentle reflection...",
                hintStyle: GoogleFonts.poppins(
                  color: softTextColor.withOpacity(0.72),
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.nightCard
                    : Colors.white.withOpacity(0.6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.nightBorder
                        : Colors.white.withOpacity(0.8),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.nightBlue
                        : selectedMoodColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 34),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveMood,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: isDark
                      ? AppColors.nightBlue
                      : selectedMoodColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: isDark
                      ? AppColors.nightCardSoft
                      : selectedMoodColor.withOpacity(0.45),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Text(
                  "Save Reflection",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}