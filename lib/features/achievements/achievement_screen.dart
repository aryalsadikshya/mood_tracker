import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colours.dart';
import '../mood/mood_model.dart';
import '../mood/mood_service.dart';
import 'achievement_service.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MoodService moodService = MoodService();

    return Scaffold(
      backgroundColor: AppColors.cream,

      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Achievements",
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ),

      body: StreamBuilder<List<MoodModel>>(
        stream: moodService.getMoods(),
        builder: (context, snapshot) {
          final moods = snapshot.data ?? [];

          final achievements =
          AchievementService.getAchievements(moods);

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: achievement.unlocked
                      ? Colors.white.withOpacity(0.75)
                      : Colors.white.withOpacity(0.35),

                  borderRadius: BorderRadius.circular(30),

                  border: Border.all(
                    color: achievement.unlocked
                        ? AppColors.softPurple.withOpacity(0.3)
                        : Colors.white.withOpacity(0.2),
                  ),

                  boxShadow: achievement.unlocked
                      ? [
                    BoxShadow(
                      color: AppColors.softPurple.withOpacity(0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                    ),
                  ]
                      : [],
                ),

                child: Row(
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: achievement.unlocked
                            ? AppColors.blush
                            : AppColors.border.withOpacity(0.4),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        achievement.emoji,
                        style: const TextStyle(fontSize: 34),
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement.title,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: achievement.unlocked
                                  ? AppColors.textDark
                                  : AppColors.textSoft,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            achievement.description,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              height: 1.5,
                              color: AppColors.textSoft,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Icon(
                      achievement.unlocked
                          ? Icons.lock_open_rounded
                          : Icons.lock_rounded,
                      color: achievement.unlocked
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}