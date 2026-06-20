import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colours.dart';

class DrinkWaterScreen extends StatefulWidget {
  const DrinkWaterScreen({super.key});

  @override
  State<DrinkWaterScreen> createState() => _DrinkWaterScreenState();
}

class _DrinkWaterScreenState extends State<DrinkWaterScreen>
    with SingleTickerProviderStateMixin {
  int cupsDrunk = 0;
  final int dailyGoal = 8;

  late AnimationController _controller;

  double get progress => cupsDrunk / dailyGoal;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          const _CuteHydrationBackground(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 34),
              child: Column(
                children: [
                  _TopBar(
                    onBack: () => Navigator.pop(context),
                    onReset: resetCups,
                  ),

                  const SizedBox(height: 18),

                  _MainHydrationCard(
                    controller: _controller,
                    progress: progress,
                    cupsDrunk: cupsDrunk,
                    dailyGoal: dailyGoal,
                    percent: percent,
                    onAddCup: addCup,
                  ),

                  const SizedBox(height: 22),

                  _HydrationStreakCard(
                    cupsDrunk: cupsDrunk,
                    dailyGoal: dailyGoal,
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

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onReset;

  const _TopBar({
    required this.onBack,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: onBack,
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
            const SizedBox(height: 2),
            Text(
              "Small sips, big difference.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSoft,
              ),
            ),
          ],
        ),
        const Spacer(),
        _RoundIconButton(
          icon: Icons.restart_alt_rounded,
          onTap: onReset,
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({
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
          color: Colors.white.withOpacity(0.86),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.lakeBlue.withOpacity(0.13),
              blurRadius: 18,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: AppColors.deepBlue,
          size: 25,
        ),
      ),
    );
  }
}

class _MainHydrationCard extends StatelessWidget {
  final AnimationController controller;
  final double progress;
  final int cupsDrunk;
  final int dailyGoal;
  final int percent;
  final VoidCallback onAddCup;

  const _MainHydrationCard({
    required this.controller,
    required this.progress,
    required this.cupsDrunk,
    required this.dailyGoal,
    required this.percent,
    required this.onAddCup,
  });

  @override
  Widget build(BuildContext context) {
    final completed = cupsDrunk >= dailyGoal;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.paleBlue.withOpacity(0.60),
            AppColors.mint.withOpacity(0.48),
            Colors.white.withOpacity(0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(42),
        border: Border.all(
          color: Colors.white.withOpacity(0.95),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.lakeBlue.withOpacity(0.16),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        children: [
          _CuteMessageBubble(
            completed: completed,
            cupsDrunk: cupsDrunk,
            dailyGoal: dailyGoal,
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 370,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 12,
                  left: 8,
                  child: _FloatingLeaf(
                    size: 42,
                    angle: -0.35,
                    opacity: 0.50,
                  ),
                ),

                Positioned(
                  right: 8,
                  bottom: 30,
                  child: _CutePlant(),
                ),

                Positioned(
                  top: 8,
                  right: 42,
                  child: Transform.rotate(
                    angle: -0.32,
                    child: _CuteJug(controller: controller),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  child: _CuteGlass(
                    progress: progress,
                    controller: controller,
                  ),
                ),

                Positioned(
                  left: 0,
                  top: 145,
                  child: _MiniStatCircle(
                    icon: Icons.water_drop_rounded,
                    title: "Daily Goal",
                    value: "$dailyGoal Cups",
                  ),
                ),

                Positioned(
                  right: 0,
                  top: 160,
                  child: _MiniStatCircle(
                    icon: Icons.local_drink_rounded,
                    title: "Cups Drunk",
                    value: "$cupsDrunk / $dailyGoal",
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.78),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withOpacity(0.95),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.lakeBlue.withOpacity(0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "$percent%",
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: AppColors.deepBlue,
                  ),
                ),
                Text(
                  "$cupsDrunk of $dailyGoal cups completed",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSoft,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: completed ? null : onAddCup,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor:
                completed ? AppColors.mint : AppColors.deepBlue,
                disabledBackgroundColor: AppColors.mint.withOpacity(0.85),
                foregroundColor:
                completed ? AppColors.deepBlue : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                completed ? "Hydration Goal Complete" : "Pour One Cup",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CuteMessageBubble extends StatelessWidget {
  final bool completed;
  final int cupsDrunk;
  final int dailyGoal;

  const _CuteMessageBubble({
    required this.completed,
    required this.cupsDrunk,
    required this.dailyGoal,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;

    if (completed) {
      title = "You did it!";
      subtitle = "Your hydration goal is complete.";
    } else if (cupsDrunk == 0) {
      title = "Ready to hydrate?";
      subtitle = "Let's fill your cute little glass.";
    } else {
      title = "You're doing great!";
      subtitle = "Only ${dailyGoal - cupsDrunk} cups left today.";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.80),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.95),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: AppColors.paleBlue.withOpacity(0.55),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              color: AppColors.lakeBlue,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
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

class _CuteJug extends StatelessWidget {
  final AnimationController controller;

  const _CuteJug({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 145,
      child: Stack(
        children: [
          Positioned(
            top: 78,
            left: 8,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(42, 120),
                  painter: _WaterStreamPainter(controller.value),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(115, 90),
              painter: _JugPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CuteGlass extends StatelessWidget {
  final double progress;
  final AnimationController controller;

  const _CuteGlass({
    required this.progress,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      width: 190,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              height: 34,
              width: 160,
              decoration: BoxDecoration(
                color: AppColors.textDark.withOpacity(0.08),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),

          ClipPath(
            clipper: _GlassClipper(),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                height: 235 * progress.clamp(0.0, 1.0),
                width: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFAEE8FF).withOpacity(0.95),
                      AppColors.lakeBlue.withOpacity(0.70),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return ClipPath(
                clipper: _GlassClipper(),
                child: CustomPaint(
                  size: const Size(190, 250),
                  painter: _WavePainter(
                    progress: progress,
                    animation: controller.value,
                  ),
                ),
              );
            },
          ),

          CustomPaint(
            size: const Size(190, 250),
            painter: _GlassOutlinePainter(),
          ),

          Positioned(
            bottom: 72,
            child: Column(
              children: [
                Row(
                  children: const [
                    _CuteEye(),
                    SizedBox(width: 34),
                    _CuteEye(),
                  ],
                ),
                const SizedBox(height: 10),
                CustomPaint(
                  size: const Size(28, 14),
                  painter: _SmilePainter(),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 94,
            left: 43,
            child: _BlushDot(),
          ),
          Positioned(
            bottom: 94,
            right: 43,
            child: _BlushDot(),
          ),
        ],
      ),
    );
  }
}

class _MiniStatCircle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _MiniStatCircle({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      width: 116,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.95),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.lakeBlue.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.lakeBlue,
            size: 26,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.deepBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class _HydrationStreakCard extends StatelessWidget {
  final int cupsDrunk;
  final int dailyGoal;

  const _HydrationStreakCard({
    required this.cupsDrunk,
    required this.dailyGoal,
  });

  @override
  Widget build(BuildContext context) {
    final done = cupsDrunk >= dailyGoal;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.78),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: Colors.white.withOpacity(0.94),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withOpacity(0.11),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 62,
            width: 62,
            decoration: BoxDecoration(
              color: AppColors.paleBlue.withOpacity(0.55),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              color: AppColors.lakeBlue,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              done
                  ? "Hydration streak protected. Your body is quietly celebrating."
                  : "Keep hydrating gently. Small sips still count.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.55,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            done
                ? Icons.check_circle_rounded
                : Icons.favorite_border_rounded,
            color: done ? AppColors.mint : AppColors.lakeBlue,
            size: 34,
          ),
        ],
      ),
    );
  }
}

class _CuteHydrationBackground extends StatelessWidget {
  const _CuteHydrationBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.cream),
        Positioned(
          top: -80,
          right: -70,
          child: _SoftBlob(
            color: AppColors.paleBlue.withOpacity(0.55),
            size: 250,
          ),
        ),
        Positioned(
          bottom: 90,
          left: -90,
          child: _SoftBlob(
            color: AppColors.mint.withOpacity(0.55),
            size: 250,
          ),
        ),
        Positioned(
          top: 310,
          right: -80,
          child: _SoftBlob(
            color: AppColors.lavender.withOpacity(0.33),
            size: 220,
          ),
        ),
        Positioned(
          top: 160,
          left: 22,
          child: _FloatingLeaf(
            size: 54,
            angle: -0.5,
            opacity: 0.32,
          ),
        ),
        Positioned(
          bottom: 140,
          right: 28,
          child: _FloatingLeaf(
            size: 44,
            angle: 0.4,
            opacity: 0.28,
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

class _CutePlant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      width: 78,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              height: 38,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.peach.withOpacity(0.85),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.textDark.withOpacity(0.22),
                  width: 1.4,
                ),
              ),
              child: const Center(
                child: Text(
                  "•ᴗ•",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 12,
            child: Transform.rotate(
              angle: -0.5,
              child: _Leaf(color: AppColors.mint, size: 38),
            ),
          ),
          Positioned(
            bottom: 38,
            right: 8,
            child: Transform.rotate(
              angle: 0.55,
              child: _Leaf(color: AppColors.mint, size: 42),
            ),
          ),
          Positioned(
            bottom: 44,
            child: _Leaf(color: AppColors.mint, size: 34),
          ),
        ],
      ),
    );
  }
}

class _FloatingLeaf extends StatelessWidget {
  final double size;
  final double angle;
  final double opacity;

  const _FloatingLeaf({
    required this.size,
    required this.angle,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: _Leaf(
        color: AppColors.mint.withOpacity(opacity),
        size: size,
      ),
    );
  }
}

class _Leaf extends StatelessWidget {
  final Color color;
  final double size;

  const _Leaf({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 1.35),
      painter: _LeafPainter(color),
    );
  }
}

class _CuteEye extends StatelessWidget {
  const _CuteEye();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14,
      width: 14,
      decoration: const BoxDecoration(
        color: AppColors.textDark,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _BlushDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 20,
      decoration: BoxDecoration(
        color: AppColors.blush.withOpacity(0.80),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _GlassClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(36, 24);
    path.lineTo(size.width - 36, 24);
    path.lineTo(size.width - 52, size.height - 24);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 2,
      52,
      size.height - 24,
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _GlassOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glassFill = Paint()
      ..color = Colors.white.withOpacity(0.34)
      ..style = PaintingStyle.fill;

    final border = Paint()
      ..color = AppColors.deepBlue.withOpacity(0.42)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final highlight = Paint()
      ..color = Colors.white.withOpacity(0.70)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(36, 24);
    path.lineTo(size.width - 36, 24);
    path.lineTo(size.width - 52, size.height - 24);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 2,
      52,
      size.height - 24,
    );
    path.close();

    canvas.drawPath(path, glassFill);
    canvas.drawPath(path, border);

    final highlightPath = Path();
    highlightPath.moveTo(62, 46);
    highlightPath.quadraticBezierTo(56, 112, 66, 190);
    canvas.drawPath(highlightPath, highlight);

    final markPaint = Paint()
      ..color = AppColors.deepBlue.withOpacity(0.22)
      ..strokeWidth = 1.2;

    for (double y = 74; y <= 194; y += 40) {
      canvas.drawLine(
        Offset(64, y),
        Offset(size.width - 64, y),
        markPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _WavePainter extends CustomPainter {
  final double progress;
  final double animation;

  _WavePainter({
    required this.progress,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final waterTop = size.height - (235 * progress);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    for (double x = 30; x <= size.width - 30; x++) {
      final y = waterTop +
          8 * math.sin((x / 18) + animation * math.pi * 2);
      if (x == 30) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return true;
  }
}

class _JugPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final body = Paint()
      ..color = const Color(0xFFBDEFFF).withOpacity(0.86)
      ..style = PaintingStyle.fill;

    final border = Paint()
      ..color = AppColors.deepBlue.withOpacity(0.40)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(20, 20);
    path.quadraticBezierTo(50, 2, 90, 16);
    path.quadraticBezierTo(105, 42, 90, 76);
    path.quadraticBezierTo(54, 98, 16, 70);
    path.quadraticBezierTo(4, 42, 20, 20);
    path.close();

    canvas.drawPath(path, body);
    canvas.drawPath(path, border);

    final facePaint = Paint()
      ..color = AppColors.textDark
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(48, 48), 3.8, facePaint);
    canvas.drawCircle(const Offset(70, 48), 3.8, facePaint);

    final smilePaint = Paint()
      ..color = AppColors.textDark
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final smile = Path();
    smile.moveTo(54, 60);
    smile.quadraticBezierTo(60, 66, 68, 59);
    canvas.drawPath(smile, smilePaint);

    final blush = Paint()
      ..color = AppColors.blush.withOpacity(0.65)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(38, 57), 4.5, blush);
    canvas.drawCircle(const Offset(80, 57), 4.5, blush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _WaterStreamPainter extends CustomPainter {
  final double animation;

  _WaterStreamPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.paleBlue.withOpacity(0.82)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width - 4, 0);
    path.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.38,
      size.width * 0.55,
      size.height,
    );

    canvas.drawPath(path, paint);

    final dropPaint = Paint()
      ..color = AppColors.lakeBlue.withOpacity(0.50)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 4; i++) {
      final y = ((animation * size.height) + i * 28) % size.height;
      canvas.drawCircle(
        Offset(size.width * 0.35 + (i.isEven ? -6 : 7), y),
        3.5,
        dropPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaterStreamPainter oldDelegate) {
    return true;
  }
}

class _SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textDark
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(3, 2);
    path.quadraticBezierTo(size.width / 2, size.height, size.width - 3, 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _LeafPainter extends CustomPainter {
  final Color color;

  _LeafPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(size.width, size.height * 0.42, size.width / 2,
        size.height);
    path.quadraticBezierTo(0, size.height * 0.42, size.width / 2, 0);
    path.close();

    canvas.drawPath(path, paint);

    final vein = Paint()
      ..color = Colors.white.withOpacity(0.42)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width / 2, 8),
      Offset(size.width / 2, size.height - 8),
      vein,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}