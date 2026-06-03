import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colours.dart';
import '../mood/models/mood_model.dart';
import '../mood/services/mood_service.dart';

class MoodTrendScreen extends StatelessWidget {
  const MoodTrendScreen({super.key});

  double getAverageMood(List<MoodModel> moods) {
    if (moods.isEmpty) return 0;

    double total = 0;

    for (final mood in moods) {
      total += mood.moodValue;
    }

    return total / moods.length;
  }

  String getMoodState(double average) {
    if (average >= 4.5) return "Emotionally Thriving";
    if (average >= 3.5) return "Mostly Balanced";
    if (average >= 2.5) return "Emotionally Fluctuating";
    return "Needs Gentle Attention";
  }

  Color getMoodColor(double average) {
    if (average >= 4.5) return AppColors.mint;
    if (average >= 3.5) return AppColors.paleBlue;
    if (average >= 2.5) return AppColors.warmYellow;
    return AppColors.softPink;
  }

  List<FlSpot> buildSpots(List<MoodModel> moods) {
    final reversed = moods.reversed.toList();

    return List.generate(reversed.length, (index) {
      return FlSpot(
        index.toDouble(),
        reversed[index].moodValue.toDouble(),
      );
    });
  }

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
          "Mood Trends",
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

          if (moods.isEmpty) {
            return Center(
              child: Text(
                "No mood data yet 🌸",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textSoft,
                ),
              ),
            );
          }

          final averageMood = getAverageMood(moods);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                /// SUMMARY CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        getMoodColor(averageMood).withOpacity(0.9),
                        AppColors.blush,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(34),
                    boxShadow: [
                      BoxShadow(
                        color: getMoodColor(averageMood)
                            .withOpacity(0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Your Emotional State",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSoft,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        getMoodState(averageMood),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        averageMood.toStringAsFixed(1),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepBlue,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// GRAPH CARD
                Container(
                  height: 320,
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.softPurple.withOpacity(0.14),
                        blurRadius: 24,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mood Direction",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Your emotional trend over time",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textSoft,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Expanded(
                        child: LineChart(
                          LineChartData(
                            minY: 1,
                            maxY: 5,

                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: 1,
                              getDrawingHorizontalLine: (_) {
                                return FlLine(
                                  color: AppColors.border,
                                  strokeWidth: 1,
                                );
                              },
                            ),

                            borderData: FlBorderData(show: false),

                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  reservedSize: 28,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: AppColors.textSoft,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        "${value.toInt() + 1}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: AppColors.textSoft,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),

                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),

                            lineBarsData: [
                              LineChartBarData(
                                spots: buildSpots(moods),

                                isCurved: true,

                                color: AppColors.lakeBlue,

                                barWidth: 4,

                                dotData: FlDotData(
                                  show: true,
                                ),

                                belowBarData: BarAreaData(
                                  show: true,
                                  color: AppColors.lakeBlue
                                      .withOpacity(0.12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}