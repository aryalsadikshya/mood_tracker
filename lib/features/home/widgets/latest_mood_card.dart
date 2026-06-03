
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/empty_state_card.dart';
import '../../../core/theme/app_colours.dart';
import '../../mood/models/mood_model.dart';

class LatestMoodCard extends StatelessWidget {
  final MoodModel mood;
  final String time;

  const LatestMoodCard({
    super.key,
    required this.mood,
    required this.time,
  });

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

  @override
  Widget build(BuildContext context) {
    final color = moodColor(mood.moodLabel);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteGlass,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.26),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 66,
            width: 66,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              mood.moodEmoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Latest Check-in",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSoft,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  mood.moodLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),

                if (mood.note.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),

                  Text(
                    mood.note,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSoft,
                    ),
                  ),
                ],
              ],
            ),
          ),

          Text(
            time,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSoft,
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyLastMoodCard extends StatelessWidget {
  const EmptyLastMoodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateCard(
      emoji: "🌱",
      title: "Your journey begins here",
      subtitle:
      "Your first emotional reflection will appear here and slowly become part of your personal story.",
    );
  }
}