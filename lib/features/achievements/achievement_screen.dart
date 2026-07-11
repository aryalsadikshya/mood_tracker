import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colours.dart';
import '../mood/models/mood_model.dart';
import '../mood/services/mood_service.dart';
import 'achievement_service.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MoodService moodService = MoodService();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
        isDark ? AppColors.nightBackground : AppColors.cream,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Achievements",
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.nightText : AppColors.textDark,
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

              final cardColor = achievement.unlocked
                  ? isDark
                  ? AppColors.nightCard
                  : Colors.white.withOpacity(0.75)
                  : isDark
                  ? AppColors.nightCardSoft
                  : Colors.white.withOpacity(0.35);

              final borderColor = achievement.unlocked
                  ? isDark
                  ? AppColors.nightBorder
                  : AppColors.softPurple.withOpacity(0.3)
                  : isDark
                  ? AppColors.nightBorder.withOpacity(0.5)
                  : Colors.white.withOpacity(0.2);

              final badgeColor = achievement.unlocked
                  ? isDark
                  ? AppColors.nightCardSoft
                  : AppColors.blush
                  : isDark
                  ? AppColors.nightBorder
                  : AppColors.border.withOpacity(0.4);

              final titleColor = achievement.unlocked
                  ? isDark
                  ? AppColors.nightText
                  : AppColors.textDark
                  : isDark
                  ? AppColors.nightTextSoft
                  : AppColors.textSoft;

              final descriptionColor =
              isDark ? AppColors.nightTextSoft : AppColors.textSoft;

              final lockColor = achievement.unlocked
                  ? isDark
                  ? AppColors.nightMint
                  : Colors.green
                  : isDark
                  ? AppColors.nightTextSoft
                  : Colors.grey;

              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: borderColor,
                  ),
                  boxShadow: achievement.unlocked
                      ? [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.22)
                          : AppColors.softPurple.withOpacity(0.18),
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
                        color: badgeColor,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement.title,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: titleColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            achievement.description,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              height: 1.5,
                              color: descriptionColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      achievement.unlocked
                          ? Icons.lock_open_rounded
                          : Icons.lock_rounded,
                      color: lockColor,
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