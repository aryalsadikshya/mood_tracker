import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'breathing_screen.dart';
import '../../core/theme/app_colours.dart';

class WellnessScreen extends StatefulWidget {
  const WellnessScreen({super.key});

  @override
  State<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen> {
  final TextEditingController calmController = TextEditingController();

  String companionReply =
      "Hi, I’m your little calm companion. Tell me what is on your mind.";

  @override
  void dispose() {
    calmController.dispose();
    super.dispose();
  }

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  void generateCompanionReply() {
    final text = calmController.text.toLowerCase().trim();

    if (text.isEmpty) {
      setState(() {
        companionReply =
        "Write even one small sentence. I will sit with you through it.";
      });
      return;
    }

    if (text.contains("exam") ||
        text.contains("study") ||
        text.contains("assignment")) {
      companionReply =
      "Your mind is carrying a lot. Choose one tiny task and give it just ten calm minutes.";
    } else if (text.contains("sad") ||
        text.contains("low") ||
        text.contains("cry")) {
      companionReply =
      "Today feels heavy, and that is okay. Be soft with yourself. One slow breath first.";
    } else if (text.contains("angry") ||
        text.contains("mad") ||
        text.contains("frustrated")) {
      companionReply =
      "That feeling is strong. Let your shoulders drop, unclench your hands, and give yourself a quiet pause.";
    } else if (text.contains("alone") ||
        text.contains("lonely")) {
      companionReply =
      "Lonely moments can feel loud. Send one small message to someone safe, even if it is simple.";
    } else if (text.contains("stress") ||
        text.contains("anxious") ||
        text.contains("panic")) {
      companionReply =
      "Place both feet on the ground. Breathe in slowly. Breathe out longer. This moment can become smaller.";
    } else {
      companionReply =
      "That sounds like something your heart has been holding quietly. What would make the next five minutes gentler?";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          const _CuteBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _CuteWellnessHero(),

                  const SizedBox(height: 26),

                  _CuteCompanionCard(
                    controller: calmController,
                    reply: companionReply,
                    onGenerate: generateCompanionReply,
                  ),

                  const SizedBox(height: 30),

                  const _CuteSectionHeader(
                    sticker: "🎧",
                    title: "Mood Music",
                    subtitle: "Pick a feeling. MindBloom opens Spotify for you.",
                  ),

                  const SizedBox(height: 16),

                  _CuteMusicGrid(
                    items: [
                      _CuteWellnessItem(
                        emoji: "🌙",
                        title: "Calm",
                        subtitle: "soft relaxing songs",
                        color: AppColors.paleBlue,
                        onTap: () => openLink(
                          "https://open.spotify.com/search/calm%20relaxing%20music",
                        ),
                      ),
                      _CuteWellnessItem(
                        emoji: "📚",
                        title: "Focus",
                        subtitle: "study flow music",
                        color: AppColors.mint,
                        onTap: () => openLink(
                          "https://open.spotify.com/search/soft%20focus%20study%20music",
                        ),
                      ),
                      _CuteWellnessItem(
                        emoji: "☀️",
                        title: "Happy",
                        subtitle: "feel-good songs",
                        color: AppColors.warmYellow,
                        onTap: () => openLink(
                          "https://open.spotify.com/search/happy%20feel%20good%20songs",
                        ),
                      ),
                      _CuteWellnessItem(
                        emoji: "🪩",
                        title: "Dance",
                        subtitle: "move your mood",
                        color: AppColors.softPink,
                        onTap: () => openLink(
                          "https://open.spotify.com/search/dance%20party%20songs",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  const _CuteSectionHeader(
                    sticker: "🧘",
                    title: "Gentle Movement",
                    subtitle: "Open simple YouTube routines for your body.",
                  ),

                  const SizedBox(height: 16),

                  _CuteMovementList(
                    items: [
                      _CuteMovementItem(
                        emoji: "🌿",
                        title: "5 Minute Stretch",
                        subtitle: "quick soft body reset",
                        color: AppColors.mint,
                        onTap: () => openLink(
                          "https://www.youtube.com/results?search_query=5+minute+gentle+stretch",
                        ),
                      ),
                      _CuteMovementItem(
                        emoji: "☁️",
                        title: "Stress Relief Yoga",
                        subtitle: "release tension gently",
                        color: AppColors.paleBlue,
                        onTap: () => openLink(
                          "https://www.youtube.com/results?search_query=stress+relief+yoga+for+beginners",
                        ),
                      ),
                      _CuteMovementItem(
                        emoji: "🌙",
                        title: "Sleep Yoga",
                        subtitle: "soft bedtime calm",
                        color: AppColors.lavender,
                        onTap: () => openLink(
                          "https://www.youtube.com/results?search_query=bedtime+yoga+for+sleep+beginners",
                        ),
                      ),
                      _CuteMovementItem(
                        emoji: "🌞",
                        title: "Morning Energy",
                        subtitle: "start your day lightly",
                        color: AppColors.peach,
                        onTap: () => openLink(
                          "https://www.youtube.com/results?search_query=morning+energy+yoga+beginners",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  const _CuteSectionHeader(
                    sticker: "🫧",
                    title: "Tiny Reset Tools",
                    subtitle: "Small actions when your mind feels crowded.",
                  ),

                  const SizedBox(height: 16),

                  _CuteResetTools(
                    onBreathTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BreathingScreen(),
                        ),
                      );
                    },
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

class _CuteBackground extends StatelessWidget {
  const _CuteBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.cream),
        Positioned(
          top: -70,
          right: -60,
          child: _SoftBlob(
            color: AppColors.lavender.withOpacity(0.55),
            size: 220,
          ),
        ),
        Positioned(
          top: 230,
          left: -80,
          child: _SoftBlob(
            color: AppColors.blush.withOpacity(0.50),
            size: 210,
          ),
        ),
        Positioned(
          bottom: 110,
          right: -70,
          child: _SoftBlob(
            color: AppColors.paleBlue.withOpacity(0.55),
            size: 250,
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

class _CuteWellnessHero extends StatelessWidget {
  const _CuteWellnessHero();

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
        border: Border.all(
          color: Colors.white,
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withOpacity(0.18),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 76,
            width: 76,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.65),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              "🌸",
              style: TextStyle(fontSize: 38),
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Wellness",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "A cute calm corner for music, movement, and tiny resets.",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.textSoft,
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

class _CuteCompanionCard extends StatelessWidget {
  final TextEditingController controller;
  final String reply;
  final VoidCallback onGenerate;

  const _CuteCompanionCard({
    required this.controller,
    required this.reply,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(
          color: Colors.white.withOpacity(0.92),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.lakeBlue.withOpacity(0.13),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: const BoxDecoration(
                  color: AppColors.mint,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "🧸",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  "Calm Companion",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            "Write what is bothering you. MindBloom gives a soft comforting reply.",
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSoft,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cream.withOpacity(0.80),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: TextField(
              controller: controller,
              maxLines: 4,
              cursorColor: AppColors.deepBlue,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.6,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Today my mind feels...",
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.textSoft.withOpacity(0.70),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onGenerate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: Text(
                "Comfort Me",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.mint,
                  AppColors.paleBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Text(
              reply,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.65,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CuteSectionHeader extends StatelessWidget {
  final String sticker;
  final String title;
  final String subtitle;

  const _CuteSectionHeader({
    required this.sticker,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          sticker,
          style: const TextStyle(fontSize: 34),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  height: 1.45,
                  color: AppColors.textSoft,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CuteMusicGrid extends StatelessWidget {
  final List<_CuteWellnessItem> items;

  const _CuteMusicGrid({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 0.95,
      children: items,
    );
  }
}

class _CuteWellnessItem extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CuteWellnessItem({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.78),
          borderRadius: BorderRadius.circular(34),
          border: Border.all(
            color: Colors.white.withOpacity(0.90),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.30),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 38),
            ),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CuteMovementList extends StatelessWidget {
  final List<_CuteMovementItem> items;

  const _CuteMovementList({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items,
    );
  }
}

class _CuteMovementItem extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CuteMovementItem({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.78),
              Colors.white.withOpacity(0.64),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withOpacity(0.88),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.22),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 58,
              width: 58,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.60),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSoft,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.deepBlue,
            ),
          ],
        ),
      ),
    );
  }
}

class _CuteResetTools extends StatelessWidget {
  final VoidCallback onBreathTap;

  const _CuteResetTools({
    required this.onBreathTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CuteResetTile(
          emoji: "🌬️",
          title: "Soft Breath",
          subtitle: "Inhale for 4 seconds. Exhale for 6 seconds.",
          color: AppColors.paleBlue,
          onTap: onBreathTap,
        ),
        const _CuteResetTile(
          emoji: "💧",
          title: "Drink Water",
          subtitle: "A tiny body reset can help your mind feel lighter.",
          color: AppColors.mint,
        ),
        const _CuteResetTile(
          emoji: "🖐️",
          title: "Ground Yourself",
          subtitle: "Name 5 things you can see around you.",
          color: AppColors.blush,
        ),
      ],
    );
  }
}

class _CuteResetTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _CuteResetTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.65),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 34),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      height: 1.45,
                      color: AppColors.textSoft,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}