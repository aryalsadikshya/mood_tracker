import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colours.dart';
import '../../../core/theme/app_radius.dart';
import '../memory_model.dart';

class BestMemoryCard extends StatelessWidget {
  final MemoryCardData memory;

  const BestMemoryCard({
    super.key,
    required this.memory,
  });

  String formattedDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withOpacity(0.20),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.55),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.deepBlue,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Best Memory",
                      style:
                      GoogleFonts.playfairDisplay(
                        fontSize: 26,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        AppColors.textDark,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "A moment worth remembering",
                      style:
                      GoogleFonts.poppins(
                        fontSize: 12,
                        color:
                        AppColors.textSoft,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.45),
              borderRadius:
              BorderRadius.circular(18),
            ),
            child: Text(
              memory.mood,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.deepBlue,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            '"${memory.note}"',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              height: 1.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: AppColors.deepBlue,
                size: 18,
              ),

              const SizedBox(width: 8),

              Text(
                formattedDate(memory.date),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSoft,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}