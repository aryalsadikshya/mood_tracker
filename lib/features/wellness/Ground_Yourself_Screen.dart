import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colours.dart';

class GroundYourselfScreen extends StatefulWidget {
  const GroundYourselfScreen({super.key});

  @override
  State<GroundYourselfScreen> createState() => _GroundYourselfScreenState();
}

class _GroundYourselfScreenState extends State<GroundYourselfScreen> {
  int currentStep = 0;

  final List<List<TextEditingController>> controllers = [
    List.generate(5, (_) => TextEditingController()),
    List.generate(4, (_) => TextEditingController()),
    List.generate(3, (_) => TextEditingController()),
    List.generate(2, (_) => TextEditingController()),
    List.generate(1, (_) => TextEditingController()),
  ];

  final List<_GroundingStep> steps = const [
    _GroundingStep(
      emoji: "👀",
      title: "5 Things You Can See",
      subtitle: "Look around gently and notice five things near you.",
      hint: "Something you can see",
      color: AppColors.paleBlue,
    ),
    _GroundingStep(
      emoji: "🖐️",
      title: "4 Things You Can Touch",
      subtitle: "Notice textures, surfaces, or anything your hands can feel.",
      hint: "Something you can touch",
      color: AppColors.blush,
    ),
    _GroundingStep(
      emoji: "👂",
      title: "3 Things You Can Hear",
      subtitle: "Listen softly to the sounds around you.",
      hint: "Something you can hear",
      color: AppColors.lavender,
    ),
    _GroundingStep(
      emoji: "🌸",
      title: "2 Things You Can Smell",
      subtitle: "Notice any scent nearby, even if it is very faint.",
      hint: "Something you can smell",
      color: AppColors.mint,
    ),
    _GroundingStep(
      emoji: "🍯",
      title: "1 Thing You Can Taste",
      subtitle: "Notice one taste in your mouth or take a gentle sip of water.",
      hint: "Something you can taste",
      color: AppColors.warmYellow,
    ),
  ];

  bool get isLastStep => currentStep == steps.length - 1;
  bool get isComplete => currentStep >= steps.length;

  @override
  void dispose() {
    for (final group in controllers) {
      for (final controller in group) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void nextStep() {
    FocusScope.of(context).unfocus();

    if (isLastStep) {
      setState(() {
        currentStep = steps.length;
      });
      return;
    }

    setState(() {
      currentStep++;
    });
  }

  void previousStep() {
    FocusScope.of(context).unfocus();

    if (currentStep > 0 && !isComplete) {
      setState(() {
        currentStep--;
      });
    }
  }

  void restart() {
    FocusScope.of(context).unfocus();

    for (final group in controllers) {
      for (final controller in group) {
        controller.clear();
      }
    }

    setState(() {
      currentStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          const _GroundingBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 36),
              child: Column(
                children: [
                  _TopBar(
                    onBack: () => Navigator.pop(context),
                    onRestart: restart,
                  ),
                  const SizedBox(height: 20),
                  isComplete
                      ? _CompleteCard(
                    onRestart: restart,
                  )
                      : _GroundingCard(
                    step: steps[currentStep],
                    stepIndex: currentStep,
                    totalSteps: steps.length,
                    controllers: controllers[currentStep],
                    onNext: nextStep,
                    onPrevious: previousStep,
                    showBack: currentStep > 0,
                    isLastStep: isLastStep,
                  ),
                  const SizedBox(height: 22),
                  _CalmGarden(
                    completedSteps: isComplete ? steps.length : currentStep,
                    totalSteps: steps.length,
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

class _GroundingStep {
  final String emoji;
  final String title;
  final String subtitle;
  final String hint;
  final Color color;

  const _GroundingStep({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.hint,
    required this.color,
  });
}

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onRestart;

  const _TopBar({
    required this.onBack,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleButton(
          icon: Icons.arrow_back_rounded,
          onTap: onBack,
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              "Ground Yourself",
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Come back to this moment.",
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSoft,
              ),
            ),
          ],
        ),
        const Spacer(),
        _CircleButton(
          icon: Icons.refresh_rounded,
          onTap: onRestart,
        ),
      ],
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
          color: Colors.white.withOpacity(0.86),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.92),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.softPurple.withOpacity(0.13),
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

class _GroundingCard extends StatelessWidget {
  final _GroundingStep step;
  final int stepIndex;
  final int totalSteps;
  final List<TextEditingController> controllers;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool showBack;
  final bool isLastStep;

  const _GroundingCard({
    required this.step,
    required this.stepIndex,
    required this.totalSteps,
    required this.controllers,
    required this.onNext,
    required this.onPrevious,
    required this.showBack,
    required this.isLastStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            step.color.withOpacity(0.74),
            Colors.white.withOpacity(0.78),
            AppColors.cream.withOpacity(0.92),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(42),
        border: Border.all(
          color: Colors.white.withOpacity(0.95),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: step.color.withOpacity(0.23),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          _StepProgress(
            currentStep: stepIndex,
            totalSteps: totalSteps,
            color: step.color,
          ),
          const SizedBox(height: 22),
          Container(
            height: 96,
            width: 96,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.72),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: step.color.withOpacity(0.24),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              step.emoji,
              style: const TextStyle(fontSize: 44),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            step.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.55,
              fontWeight: FontWeight.w500,
              color: AppColors.textSoft,
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(
            controllers.length,
                (index) => _CuteInputField(
              controller: controllers[index],
              hint: "${step.hint} ${index + 1}",
              color: step.color,
              leadingNumber: index + 1,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              if (showBack)
                Expanded(
                  child: _SoftButton(
                    label: "Back",
                    icon: Icons.arrow_back_rounded,
                    onTap: onPrevious,
                    color: Colors.white,
                    textColor: AppColors.deepBlue,
                  ),
                ),
              if (showBack) const SizedBox(width: 12),
              Expanded(
                flex: showBack ? 1 : 2,
                child: _SoftButton(
                  label: isLastStep ? "Complete" : "Next",
                  icon: isLastStep
                      ? Icons.favorite_rounded
                      : Icons.arrow_forward_rounded,
                  onTap: onNext,
                  color: AppColors.deepBlue,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color color;

  const _StepProgress({
    required this.currentStep,
    required this.totalSteps,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ["See", "Touch", "Hear", "Smell", "Taste"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final active = index <= currentStep;

        return Expanded(
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: active ? AppColors.deepBlue : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: active
                        ? AppColors.deepBlue
                        : AppColors.textSoft.withOpacity(0.25),
                    width: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                labels[index],
                style: GoogleFonts.poppins(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: active ? AppColors.deepBlue : AppColors.textSoft,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _CuteInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Color color;
  final int leadingNumber;

  const _CuteInputField({
    required this.controller,
    required this.hint,
    required this.color,
    required this.leadingNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.95),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.62),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "$leadingNumber",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.deepBlue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              cursorColor: AppColors.deepBlue,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textSoft.withOpacity(0.68),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;

  const _SoftButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isWhite = color == Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: color.withOpacity(isWhite ? 0.78 : 1),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withOpacity(0.95),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.softPurple.withOpacity(isWhite ? 0.09 : 0.16),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              size: 19,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _CalmGarden extends StatelessWidget {
  final int completedSteps;
  final int totalSteps;

  const _CalmGarden({
    required this.completedSteps,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.76),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: Colors.white.withOpacity(0.92),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withOpacity(0.10),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Tiny Calm Garden",
            style: GoogleFonts.playfairDisplay(
              fontSize: 27,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "$completedSteps of $totalSteps calm flowers grown",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSoft,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps, (index) {
              final grown = index < completedSteps;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                height: grown ? 54 : 44,
                width: grown ? 54 : 44,
                decoration: BoxDecoration(
                  color: grown
                      ? AppColors.blush.withOpacity(0.52)
                      : AppColors.border.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  grown ? "🌷" : "•",
                  style: TextStyle(
                    fontSize: grown ? 26 : 22,
                    color: AppColors.textSoft,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CompleteCard extends StatelessWidget {
  final VoidCallback onRestart;

  const _CompleteCard({
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 34, 24, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mint.withOpacity(0.76),
            AppColors.paleBlue.withOpacity(0.58),
            AppColors.blush.withOpacity(0.48),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(44),
        border: Border.all(
          color: Colors.white.withOpacity(0.95),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.lakeBlue.withOpacity(0.18),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 116,
            width: 116,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.74),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              "🌈",
              style: TextStyle(fontSize: 58),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "You Did It",
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You took a small moment to reconnect with the present.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: AppColors.textSoft,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.70),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              "Take one slow breath.\nYou are here.\nYou are present.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                height: 1.7,
                fontWeight: FontWeight.w700,
                color: AppColors.deepBlue,
              ),
            ),
          ),
          const SizedBox(height: 22),
          _SoftButton(
            label: "Start Again",
            icon: Icons.refresh_rounded,
            onTap: onRestart,
            color: AppColors.deepBlue,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _GroundingBackground extends StatelessWidget {
  const _GroundingBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.cream),
        Positioned(
          top: -70,
          right: -70,
          child: _SoftBlob(
            color: AppColors.blush.withOpacity(0.48),
            size: 240,
          ),
        ),
        Positioned(
          top: 260,
          left: -90,
          child: _SoftBlob(
            color: AppColors.paleBlue.withOpacity(0.52),
            size: 250,
          ),
        ),
        Positioned(
          bottom: 80,
          right: -90,
          child: _SoftBlob(
            color: AppColors.lavender.withOpacity(0.42),
            size: 260,
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