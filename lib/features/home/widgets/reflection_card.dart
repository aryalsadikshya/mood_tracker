import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_radius.dart';

import '../../../core/theme/app_colours.dart';

class ReflectionCard extends StatelessWidget {
  final String prompt;

  const ReflectionCard({
    super.key,
    required this.prompt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.blush,
            AppColors.lavender,
            AppColors.paleBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: Colors.white.withOpacity(0.9)),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withOpacity(0.24),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.deepBlue,
            size: 26,
          ),
          const SizedBox(height: 18),
          Text(
            "Reflection Prompt",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.deepBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            prompt,
            style: GoogleFonts.playfairDisplay(
              fontSize: 27,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}