import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colours.dart';

class MemoryOfMonthCard extends StatelessWidget {
  final String text;
  final String imagePath;
  final String date;

  const MemoryOfMonthCard({
    super.key,
    required this.text,
    required this.imagePath,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(
              top: Radius.circular(34),
            ),
            child: Image.file(
              File(imagePath),
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding:
            const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  "🌸 Memory of the Month",
                  style:
                  GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Text(
                  text,
                  maxLines: 3,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.6,
                    color:
                    AppColors.textSoft,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration:
                  BoxDecoration(
                    color:
                    AppColors.blush,
                    borderRadius:
                    BorderRadius
                        .circular(
                      30,
                    ),
                  ),
                  child: Text(
                    date,
                    style:
                    GoogleFonts.poppins(
                      fontWeight:
                      FontWeight.w600,
                    ),
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