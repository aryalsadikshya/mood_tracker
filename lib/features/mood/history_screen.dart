import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colours.dart';
import 'mood_model.dart';
import 'mood_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Color moodColor(String label) {
    switch (label) {
      case "Happy":
        return AppColors.softPink;
      case "Calm":
        return AppColors.mint;
      case "Okay":
        return AppColors.warmYellow;
      case "Low":
        return AppColors.paleBlue;
      case "Stressed":
        return AppColors.softPurple;
      default:
        return AppColors.lavender;
    }
  }

  String formatDate(DateTime date) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];

    return "${date.day} ${months[date.month - 1]}, ${date.year}";
  }

  String formatTime(DateTime date) {
    final hour = date.hour > 12
        ? date.hour - 12
        : date.hour == 0
        ? 12
        : date.hour;

    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? "PM" : "AM";

    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    final MoodService moodService = MoodService();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text("Your Journal"),
      ),
      body: StreamBuilder<List<MoodModel>>(
        stream: moodService.getMoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.lakeBlue,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Something went wrong while loading your journal.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _EmptyJournalState();
          }

          final moods = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
            itemCount: moods.length,
            itemBuilder: (context, index) {
              final mood = moods[index];
              final color = moodColor(mood.moodLabel);

              return _JournalCard(
                mood: mood,
                color: color,
                date: formatDate(mood.createdAt),
                time: formatTime(mood.createdAt),
              );
            },
          );
        },
      ),
    );
  }
}

class _JournalCard extends StatelessWidget {
  final MoodModel mood;
  final Color color;
  final String date;
  final String time;

  const _JournalCard({
    required this.mood,
    required this.color,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.whiteGlass,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.28),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 9,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  bottomLeft: Radius.circular(32),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 58,
                          width: 58,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.75),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            mood.moodEmoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mood.moodLabel,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                "$date • $time",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.textSoft,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    if (mood.note.trim().isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        mood.note,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          height: 1.55,
                          color: AppColors.textSoft,
                        ),
                      ),
                    ],

                    if (mood.activities.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: mood.activities.map((activity) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.38),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              activity,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyJournalState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.whiteGlass,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: Colors.white.withOpacity(0.9)),
            boxShadow: [
              BoxShadow(
                color: AppColors.lakeBlue.withOpacity(0.16),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 76,
                width: 76,
                decoration: const BoxDecoration(
                  color: AppColors.lavender,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "🌱",
                  style: TextStyle(fontSize: 34),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                "Your journal is empty",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                "Once you save your first mood, your reflections will appear here like a soft timeline.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}