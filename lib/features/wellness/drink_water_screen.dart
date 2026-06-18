import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colours.dart';

class DrinkWaterScreen extends StatefulWidget {
  const DrinkWaterScreen({super.key});

  @override
  State<DrinkWaterScreen> createState() => _DrinkWaterScreenState();
}

class _DrinkWaterScreenState extends State<DrinkWaterScreen> {
  int cupsDrunk = 0;
  final int dailyGoal = 8;

  double get progress => cupsDrunk / dailyGoal;

  void addCup() {
    if (cupsDrunk < dailyGoal) {
      setState(() {
        cupsDrunk++;
      });
    }
  }

  void resetCups() {
    setState(() {
      cupsDrunk = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          const _HydrationBackground(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 40),
              child: Column(
                children: [
                  Row(
                    children: [
                      _CircleButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Text(
                            "Drink Water",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            "Small sips, big difference.",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.textSoft,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      _CircleButton(
                        icon: Icons.local_florist_rounded,
                        onTap: resetCups,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.mint.withOpacity(0.55),
                          AppColors.paleBlue.withOpacity(0.42),
                          Colors.white.withOpacity(0.70),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(38),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lakeBlue.withOpacity(0.16),
                          blurRadius: 30,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _SpeechBubble(
                          cupsDrunk: cupsDrunk,
                          dailyGoal: dailyGoal,
                        ),

                        const SizedBox(height: 28),

                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 10,
                              right: 34,
                              child: Transform.rotate(
                                angle: -0.35,
                                child: const _PouringJug(),
                              ),
                            ),

                            Column(
                              children: [
                                const SizedBox(height: 82),
                                _WaterGlass(progress: progress),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Text(
                          "$percent%",
                          style: GoogleFonts.poppins(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deepBlue,
                          ),
                        ),

                        Text(
                          "$cupsDrunk of $dailyGoal cups completed",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSoft,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: _InfoBubble(
                                icon: Icons.water_drop_rounded,
                                title: "Daily Goal",
                                value: "$dailyGoal Cups",
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _InfoBubble(
                                icon: Icons.local_drink_rounded,
                                title: "Cups Drunk",
                                value: "$cupsDrunk / $dailyGoal",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: addCup,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColors.deepBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: Text(
                              cupsDrunk >= dailyGoal
                                  ? "Goal Completed"
                                  : "Add One Cup",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.78),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 58,
                          width: 58,
                          decoration: BoxDecoration(
                            color: AppColors.mint.withOpacity(0.65),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.water_drop_rounded,
                            color: AppColors.deepBlue,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            cupsDrunk >= dailyGoal
                                ? "You completed your hydration goal today. Your body says thank you."
                                : "Keep going gently. One small sip still counts.",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              height: 1.55,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HydrationBackground extends StatelessWidget {
  const _HydrationBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.cream),
        Positioned(
          top: -70,
          right: -50,
          child: _SoftBlob(
            color: AppColors.mint.withOpacity(0.50),
            size: 230,
          ),
        ),
        Positioned(
          bottom: 80,
          left: -80,
          child: _SoftBlob(
            color: AppColors.paleBlue.withOpacity(0.55),
            size: 260,
          ),
        ),
        Positioned(
          top: 290,
          right: -90,
          child: _SoftBlob(
            color: AppColors.lavender.withOpacity(0.35),
            size: 220,
          ),
        ),
      ],
    );
  }
}

class _SoftBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _SoftBlob({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        width: 58,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.82),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.softPurple.withOpacity(0.14),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: AppColors.deepBlue,
        ),
      ),
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  final int cupsDrunk;
  final int dailyGoal;

  const _SpeechBubble({
    required this.cupsDrunk,
    required this.dailyGoal,
  });

  @override
  Widget build(BuildContext context) {
    final done = cupsDrunk >= dailyGoal;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.76),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "💧",
            style: TextStyle(fontSize: 26),
          ),
          const SizedBox(width: 10),
          Text(
            done ? "Hydration goal complete!" : "Let's fill up your goal.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _PouringJug extends StatelessWidget {
  const _PouringJug();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.local_drink_rounded,
          size: 86,
          color: AppColors.deepBlue,
        ),
        Container(
          height: 90,
          width: 12,
          decoration: BoxDecoration(
            color: AppColors.paleBlue.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }
}

class _WaterGlass extends StatelessWidget {
  final double progress;

  const _WaterGlass({
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: 180,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipPath(
            clipper: _GlassClipper(),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutCubic,
                height: 240 * progress.clamp(0.0, 1.0),
                width: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.paleBlue.withOpacity(0.95),
                      AppColors.lakeBlue.withOpacity(0.72),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          CustomPaint(
            size: const Size(180, 260),
            painter: _GlassPainter(),
          ),

          Positioned(
            bottom: 58,
            child: Column(
              children: [
                Row(
                  children: [
                    _Eye(),
                    const SizedBox(width: 24),
                    _Eye(),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 8,
                  width: 24,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.textDark.withOpacity(0.75),
                        width: 2,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(20),
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

class _Eye extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 13,
      width: 13,
      decoration: const BoxDecoration(
        color: AppColors.textDark,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _GlassClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(32, 22);
    path.lineTo(size.width - 32, 22);
    path.lineTo(size.width - 48, size.height - 18);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 4,
      48,
      size.height - 18,
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _GlassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glassPaint = Paint()
      ..color = Colors.white.withOpacity(0.45)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = AppColors.deepBlue.withOpacity(0.48)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(32, 22);
    path.lineTo(size.width - 32, 22);
    path.lineTo(size.width - 48, size.height - 18);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 4,
      48,
      size.height - 18,
    );
    path.close();

    canvas.drawPath(path, glassPaint);
    canvas.drawPath(path, borderPaint);

    final linePaint = Paint()
      ..color = AppColors.deepBlue.withOpacity(0.25)
      ..strokeWidth = 1;

    for (double y = 70; y <= 205; y += 45) {
      canvas.drawLine(
        Offset(58, y),
        Offset(size.width - 58, y),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _InfoBubble extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoBubble({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.70),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withOpacity(0.88),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.lakeBlue,
            size: 28,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.deepBlue,
            ),
          ),
        ],
      ),
    );
  }
}