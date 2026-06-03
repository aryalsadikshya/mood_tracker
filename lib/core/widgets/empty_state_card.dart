import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colours.dart';

class EmptyStateCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const EmptyStateCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.blush,
            AppColors.paleBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(34),

        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),

      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(
              fontSize: 54,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            title,
            textAlign: TextAlign.center,

            style:
            GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            subtitle,
            textAlign: TextAlign.center,

            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.7,
              color: AppColors.textSoft,
            ),
          ),
        ],
      ),
    );
  }
}