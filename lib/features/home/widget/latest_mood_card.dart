import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colours.dart';
import '../../mood/mood_model.dart';

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
        border: Border.all(color: Colors.white.withOpacity(0.9)),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.whiteGlass,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Colors.white.withOpacity(0.9)),
        boxShadow: [
          BoxShadow(
            color: AppColors.mint.withOpacity(0.22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 62,
            width: 62,
            decoration: const BoxDecoration(
              color: AppColors.mint,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              "🌱",
              style: TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Your first mood entry will appear here.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}