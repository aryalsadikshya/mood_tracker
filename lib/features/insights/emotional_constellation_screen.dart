import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colours.dart';
import '../mood/mood_model.dart';
import '../mood/mood_service.dart';

class EmotionalConstellationScreen extends StatelessWidget {
  const EmotionalConstellationScreen({super.key});

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
          "Emotional Constellation",
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
          final latestMoods = moods.take(30).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your latest 30 emotional check-ins become a quiet sky of memories.",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.6,
                    color: AppColors.textSoft,
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.whiteGlass,
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.softPurple.withOpacity(0.22),
                        blurRadius: 30,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Mood Sky",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Tap a star to revisit the mood, note, and date behind it.",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          height: 1.5,
                          color: AppColors.textSoft,
                        ),
                      ),

                      const SizedBox(height: 22),

                      AspectRatio(
                        aspectRatio: 1.08,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFF8EEF8),
                                Color(0xFFEAF6FA),
                                Color(0xFFFDFCF0),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          child: latestMoods.isEmpty
                              ? const _EmptyConstellation()
                              : _ConstellationSky(moods: latestMoods),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const _ConstellationLegend(),
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

class _ConstellationSky extends StatelessWidget {
  final List<MoodModel> moods;

  const _ConstellationSky({
    required this.moods,
  });

  static const List<Offset> positions = [
    Offset(0.14, 0.22),
    Offset(0.34, 0.16),
    Offset(0.58, 0.24),
    Offset(0.80, 0.18),
    Offset(0.22, 0.42),
    Offset(0.46, 0.38),
    Offset(0.68, 0.46),
    Offset(0.88, 0.38),
    Offset(0.12, 0.64),
    Offset(0.32, 0.58),
    Offset(0.54, 0.66),
    Offset(0.76, 0.60),
    Offset(0.24, 0.82),
    Offset(0.48, 0.84),
    Offset(0.72, 0.80),
    Offset(0.90, 0.76),
    Offset(0.18, 0.32),
    Offset(0.40, 0.28),
    Offset(0.62, 0.34),
    Offset(0.84, 0.30),
    Offset(0.28, 0.50),
    Offset(0.50, 0.52),
    Offset(0.72, 0.52),
    Offset(0.16, 0.74),
    Offset(0.38, 0.72),
    Offset(0.60, 0.76),
    Offset(0.82, 0.70),
    Offset(0.30, 0.90),
    Offset(0.55, 0.92),
    Offset(0.78, 0.88),
  ];

  Color moodColor(String moodLabel) {
    switch (moodLabel) {
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

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void showMoodDetails(BuildContext context, MoodModel mood) {
    final color = moodColor(mood.moodLabel);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.all(14),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: Colors.white.withOpacity(0.9),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.softPurple.withOpacity(0.24),
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 5,
                  width: 46,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 22),

                Container(
                  height: 76,
                  width: 76,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.75),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.35),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    mood.moodEmoji,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  mood.moodLabel,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  formatDate(mood.createdAt),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textSoft,
                  ),
                ),

                if (mood.note.trim().isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(
                    mood.note,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textSoft,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: _ConstellationLinePainter(
                count: moods.length,
                positions: positions,
              ),
            ),

            ...List.generate(moods.length, (index) {
              final mood = moods[index];
              final position = positions[index % positions.length];
              final color = moodColor(mood.moodLabel);
              final isLatest = index == 0;

              final left = constraints.maxWidth * position.dx;
              final top = constraints.maxHeight * position.dy;

              return Positioned(
                left: left - 16,
                top: top - 16,
                child: GestureDetector(
                  onTap: () => showMoodDetails(context, mood),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.4, end: 1),
                    duration: Duration(
                      milliseconds: 350 + (index * 35),
                    ),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      height: isLatest ? 38 : 30,
                      width: isLatest ? 38 : 30,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.92),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(
                              isLatest ? 0.65 : 0.35,
                            ),
                            blurRadius: isLatest ? 24 : 14,
                            spreadRadius: isLatest ? 3 : 1,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        height: isLatest ? 11 : 8,
                        width: isLatest ? 11 : 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _ConstellationLinePainter extends CustomPainter {
  final int count;
  final List<Offset> positions;

  _ConstellationLinePainter({
    required this.count,
    required this.positions,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (count < 2) return;

    final paint = Paint()
      ..color = AppColors.deepBlue.withOpacity(0.15)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < count - 1; i++) {
      final a = positions[i % positions.length];
      final b = positions[(i + 1) % positions.length];

      canvas.drawLine(
        Offset(a.dx * size.width, a.dy * size.height),
        Offset(b.dx * size.width, b.dy * size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationLinePainter oldDelegate) {
    return oldDelegate.count != count;
  }
}

class _EmptyConstellation extends StatelessWidget {
  const _EmptyConstellation();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              size: 48,
              color: AppColors.deepBlue,
            ),

            const SizedBox(height: 14),

            Text(
              "Your sky is waiting",
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Log your first mood to place the first star.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConstellationLegend extends StatelessWidget {
  const _ConstellationLegend();

  @override
  Widget build(BuildContext context) {
    final legends = [
      {"label": "Happy", "color": AppColors.softPink},
      {"label": "Calm", "color": AppColors.mint},
      {"label": "Okay", "color": AppColors.warmYellow},
      {"label": "Low", "color": AppColors.paleBlue},
      {"label": "Stressed", "color": AppColors.softPurple},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: legends.map((item) {
        final color = item["color"] as Color;

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.45),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          child: Text(
            item["label"] as String,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        );
      }).toList(),
    );
  }
}