import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colours.dart';

class HomeWelcomeBanner extends StatelessWidget {
  final String greeting;
  final String subGreeting;

  const HomeWelcomeBanner({
    super.key,
    required this.greeting,
    required this.subGreeting,
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
            AppColors.lavender,
            AppColors.paleBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(38),

        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withOpacity(0.18),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Text(
            greeting,

            style:
            GoogleFonts.playfairDisplay(
              fontSize: 38,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            subGreeting,

            style: GoogleFonts.poppins(
              fontSize: 15,
              height: 1.7,
              color: AppColors.textSoft,
            ),
          ),

          const SizedBox(height: 26),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),

            decoration: BoxDecoration(
              color:
              Colors.white.withOpacity(0.5),

              borderRadius:
              BorderRadius.circular(24),
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 18,
                  color: AppColors.deepBlue,
                ),

                const SizedBox(width: 8),

                Text(
                  "Your emotional space is ready",

                  style:
                  GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.deepBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}