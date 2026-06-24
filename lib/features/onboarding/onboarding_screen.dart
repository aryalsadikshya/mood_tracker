import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colours.dart';
import '../auth/screen/auth_screen.dart';
import 'onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("seenOnboarding", true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthScreen(),
      ),
    );
  }

  void nextPage() {
    if (currentPage == onboardingPages.length - 1) {
      completeOnboarding();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  List<Color> pageColors(int index) {
    final colors = [
      [
        const Color(0xFFF6E8EE),
        const Color(0xFFEFE6F8),
        const Color(0xFFEAF3F7),
      ],
      [
        const Color(0xFFF8EEDC),
        const Color(0xFFF6E8EE),
        const Color(0xFFE7F1D8),
      ],
      [
        const Color(0xFFEFE6F8),
        const Color(0xFFFFEBDD),
        const Color(0xFFEAF3F7),
      ],
    ];

    return colors[index % colors.length];
  }

  Color panelTint(int index) {
    final tints = [
      const Color(0xFFF2E5EC),
      const Color(0xFFF5EAD8),
      const Color(0xFFEDE7F6),
    ];
    return tints[index % tints.length];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentData = onboardingPages[currentPage];

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingPages.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _FullScreenOnboardingImage(
                image: onboardingPages[index].image,
                colors: pageColors(index),
                tintColor: panelTint(index),
              );
            },
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _OnboardingBottomPanel(
              title: currentData.title,
              description: currentData.description,
              currentPage: currentPage,
              totalPages: onboardingPages.length,
              tintColor: panelTint(currentPage),
              onSkip: completeOnboarding,
              onNext: nextPage,
            ),
          ),
        ],
      ),
    );
  }
}

class _FullScreenOnboardingImage extends StatelessWidget {
  final String image;
  final List<Color> colors;
  final Color tintColor;

  const _FullScreenOnboardingImage({
    required this.image,
    required this.colors,
    required this.tintColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            image,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),

        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 24,
              sigmaY: 24,
            ),
            child: Container(
              color: AppColors.cream.withOpacity(0.14),
            ),
          ),
        ),

        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors[0].withOpacity(0.32),
                  colors[1].withOpacity(0.18),
                  colors[2].withOpacity(0.14),
                  AppColors.cream.withOpacity(0.92),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),

        Positioned(
          top: -70,
          left: -65,
          child: _SoftBlob(
            color: colors[0].withOpacity(0.52),
            size: 220,
          ),
        ),

        Positioned(
          top: 0,
          right: -60,
          child: _SoftBlob(
            color: colors[1].withOpacity(0.48),
            size: 190,
          ),
        ),

        Positioned(
          bottom: 180,
          right: -80,
          child: _SoftBlob(
            color: colors[2].withOpacity(0.48),
            size: 240,
          ),
        ),

        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 255),
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxWidth: 360,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: tintColor.withOpacity(0.38),
                  borderRadius: BorderRadius.circular(38),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.72),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: tintColor.withOpacity(0.20),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingBottomPanel extends StatelessWidget {
  final String title;
  final String description;
  final int currentPage;
  final int totalPages;
  final Color tintColor;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const _OnboardingBottomPanel({
    required this.title,
    required this.description,
    required this.currentPage,
    required this.totalPages,
    required this.tintColor,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentPage == totalPages - 1;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(38),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 18,
              sigmaY: 18,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.62),
                borderRadius: BorderRadius.circular(38),
                border: Border.all(
                  color: Colors.white.withOpacity(0.90),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: tintColor.withOpacity(0.16),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    child: Text(
                      title,
                      key: ValueKey(title),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                        height: 1.08,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    child: Text(
                      description,
                      key: ValueKey(description),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSoft,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _PageIndicator(
                    currentPage: currentPage,
                    totalPages: totalPages,
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: _SkipButton(
                          onTap: onSkip,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _NextButton(
                          label: isLastPage ? "Get Started" : "Next",
                          onTap: onNext,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _PageIndicator({
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final active = currentPage == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: active ? 10 : 9,
          width: active ? 30 : 9,
          decoration: BoxDecoration(
            color: active ? AppColors.lakeBlue : AppColors.lavender,
            borderRadius: BorderRadius.circular(30),
            boxShadow: active
                ? [
              BoxShadow(
                color: AppColors.lakeBlue.withOpacity(0.18),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
        );
      }),
    );
  }
}

class _SkipButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SkipButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 17),
        backgroundColor: const Color(0xFFF7EFF4),
        side: BorderSide(
          color: AppColors.softPurple.withOpacity(0.35),
          width: 1.2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        "Skip",
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF7B6586),
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NextButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 17),
        backgroundColor: const Color(0xFFBCA8DF),
        foregroundColor: AppColors.textDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: AppColors.textDark,
        ),
      ),
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