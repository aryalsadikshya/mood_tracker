import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colours.dart';
import '../../../core/widgets/app_loading.dart';
import '../models/mood_model.dart';
import '../services/mood_service.dart';

void showMindBloomSnackBar(
    BuildContext context, {
      required String title,
      required String message,
      IconData icon = Icons.check_rounded,
      bool isError = false,
    }) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isError
                ? isDark
                ? [
              const Color(0xFF3A1F2B),
              AppColors.nightCard,
            ]
                : [
              const Color(0xFFFFE1E1),
              const Color(0xFFFFF5F5),
            ]
                : isDark
                ? [
              AppColors.nightCardSoft,
              AppColors.nightCard,
              AppColors.nightBackground,
            ]
                : [
              AppColors.lavender.withOpacity(0.95),
              AppColors.paleBlue.withOpacity(0.95),
              AppColors.mint.withOpacity(0.90),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? AppColors.nightBorder
                : Colors.white.withOpacity(0.85),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.28)
                  : AppColors.softPurple.withOpacity(0.18),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.nightCardSoft
                    : Colors.white.withOpacity(0.65),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isError
                    ? Colors.redAccent
                    : isDark
                    ? AppColors.nightBlue
                    : AppColors.deepBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color:
                      isDark ? AppColors.nightText : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.nightTextSoft
                          : AppColors.textSoft,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController journalController = TextEditingController();
  final MoodService moodService = MoodService();

  bool isSaving = false;

  @override
  void dispose() {
    journalController.dispose();
    super.dispose();
  }

  String get uid {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("No user logged in");
    }

    return user.uid;
  }

  Future<void> saveJournal() async {
    final text = journalController.text.trim();

    if (text.isEmpty) {
      showMindBloomSnackBar(
        context,
        title: "Your diary is still empty",
        message: "Write a few thoughts before saving this note.",
        icon: Icons.edit_note_rounded,
        isError: true,
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("journals")
          .add({
        "text": text,
        "createdAt": Timestamp.fromDate(DateTime.now()),
      });

      journalController.clear();

      if (!mounted) return;

      showMindBloomSnackBar(
        context,
        title: "Diary note saved",
        message: "Your reflection has been added to your memories.",
        icon: Icons.favorite_rounded,
      );
    } catch (e) {
      if (!mounted) return;

      showMindBloomSnackBar(
        context,
        title: "Could not save note",
        message: "Something went wrong. Please try again.",
        icon: Icons.error_outline_rounded,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> journalStream() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("journals")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  String journalPrompt(List<MoodModel> moods) {
    if (moods.isEmpty) {
      return "What emotion is quietly asking for your attention today?";
    }

    switch (moods.first.moodLabel) {
      case "Happy":
        return "What moment today deserves to be remembered?";
      case "Calm":
        return "What helped your mind feel peaceful today?";
      case "Low":
        return "What has been sitting quietly in your heart?";
      case "Stressed":
        return "What is taking most of your emotional energy lately?";
      case "Okay":
        return "What felt simple, steady, or enough today?";
      default:
        return "What do you want to understand about today?";
    }
  }

  String formatDate(DateTime date) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return "${date.day} ${months[date.month - 1]}, ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          const _PastelNotebookBackground(),
          SafeArea(
            child: StreamBuilder<List<MoodModel>>(
              stream: moodService.getMoods(),
              builder: (context, moodSnapshot) {
                if (moodSnapshot.connectionState == ConnectionState.waiting) {
                  return const AppLoading(
                    message: "Opening your journal...",
                  );
                }

                final moods = moodSnapshot.data ?? [];

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const _DiaryTitle(),
                      const SizedBox(height: 24),
                      _PromptCard(
                        prompt: journalPrompt(moods),
                      ),
                      const SizedBox(height: 24),
                      _BigDiaryPaper(
                        controller: journalController,
                        isSaving: isSaving,
                        onSave: saveJournal,
                      ),
                      const SizedBox(height: 30),
                      _JournalHistory(
                        stream: journalStream(),
                        formatDate: formatDate,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PastelNotebookBackground extends StatelessWidget {
  const _PastelNotebookBackground();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Container(
          color: isDark ? AppColors.nightBackground : AppColors.cream,
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _PastelGridPainter(isDark: isDark),
          ),
        ),
        Positioned(
          top: -80,
          right: -70,
          child: _GlowCircle(
            color: isDark
                ? AppColors.nightLavender.withOpacity(0.18)
                : AppColors.lavender.withOpacity(0.55),
            size: 220,
          ),
        ),
        Positioned(
          bottom: 120,
          left: -80,
          child: _GlowCircle(
            color: isDark
                ? AppColors.nightBlue.withOpacity(0.16)
                : AppColors.paleBlue.withOpacity(0.55),
            size: 240,
          ),
        ),
      ],
    );
  }
}

class _PastelGridPainter extends CustomPainter {
  final bool isDark;

  _PastelGridPainter({
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final whitePaint = Paint()
      ..color = isDark
          ? Colors.white.withOpacity(0.035)
          : Colors.white.withOpacity(0.35)
      ..strokeWidth = 22;

    final lavenderPaint = Paint()
      ..color = isDark
          ? AppColors.nightLavender.withOpacity(0.06)
          : AppColors.lavender.withOpacity(0.26)
      ..strokeWidth = 14;

    final bluePaint = Paint()
      ..color = isDark
          ? AppColors.nightBlue.withOpacity(0.055)
          : AppColors.paleBlue.withOpacity(0.30)
      ..strokeWidth = 10;

    final blushPaint = Paint()
      ..color = isDark
          ? AppColors.nightBlush.withOpacity(0.045)
          : AppColors.blush.withOpacity(0.24)
      ..strokeWidth = 12;

    for (double x = 30; x < size.width; x += 95) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        whitePaint,
      );
    }

    for (double x = 70; x < size.width; x += 130) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        lavenderPaint,
      );
    }

    for (double y = 42; y < size.height; y += 100) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        bluePaint,
      );
    }

    for (double y = 82; y < size.height; y += 130) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        blushPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PastelGridPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowCircle({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _DiaryTitle extends StatelessWidget {
  const _DiaryTitle();

  @override
  Widget build(BuildContext context) {
    final titleColor =
        Theme.of(context).textTheme.headlineMedium?.color ??
            AppColors.textDark;

    final subtitleColor =
        Theme.of(context).textTheme.bodyMedium?.color ??
            AppColors.textSoft;

    return Column(
      children: [
        Text(
          "My Journal",
          style: GoogleFonts.playfairDisplay(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "A soft space for your thoughts",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: subtitleColor,
          ),
        ),
      ],
    );
  }
}

class _PromptCard extends StatelessWidget {
  final String prompt;

  const _PromptCard({
    required this.prompt,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
            AppColors.nightCardSoft,
            AppColors.nightCard,
          ]
              : [
            AppColors.lavender.withOpacity(0.9),
            AppColors.blush.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? AppColors.nightBorder
              : Colors.white.withOpacity(0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.25)
                : AppColors.softPurple.withOpacity(0.15),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            "💭",
            style: TextStyle(fontSize: 34),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              prompt,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.nightText
                    : AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BigDiaryPaper extends StatelessWidget {
  final TextEditingController controller;
  final bool isSaving;
  final VoidCallback onSave;

  const _BigDiaryPaper({
    required this.controller,
    required this.isSaving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.nightCard
            : Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: isDark
              ? AppColors.nightBorder
              : Colors.white.withOpacity(0.85),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.28)
                : AppColors.softPurple.withOpacity(0.14),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            maxLines: 12,
            style: GoogleFonts.poppins(
              color: isDark
                  ? AppColors.nightText
                  : AppColors.textDark,
              height: 1.8,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText:
              "Write about your day, your feelings, or anything on your mind...",
              hintStyle: GoogleFonts.poppins(
                color: isDark
                    ? AppColors.nightTextSoft
                    : AppColors.textSoft,
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSaving ? null : onSave,
              child: isSaving
                  ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Text("Save Reflection"),
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalHistory extends StatelessWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  final String Function(DateTime) formatDate;

  const _JournalHistory({
    required this.stream,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(30),
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "No reflections yet.",
              style: GoogleFonts.poppins(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color ??
                    AppColors.textSoft,
              ),
            ),
          );
        }

        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Previous Reflections",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.color ??
                      AppColors.textDark,
                ),
              ),
            ),

            const SizedBox(height: 16),

            ...docs.map((doc) {
              final data = doc.data();

              final text =
              (data["text"] ?? "").toString();

              final createdAt =
                  (data["createdAt"] as Timestamp?)
                      ?.toDate() ??
                      DateTime.now();

              return _JournalCard(
                text: text,
                date: formatDate(createdAt),
              );
            }),
          ],
        );
      },
    );
  }
}

class _JournalCard extends StatelessWidget {
  final String text;
  final String date;

  const _JournalCard({
    required this.text,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.nightCard
            : Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? AppColors.nightBorder
              : Colors.white.withOpacity(0.85),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.22)
                : AppColors.softPurple.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.nightBlue
                  : AppColors.deepBlue,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.7,
              color: isDark
                  ? AppColors.nightText
                  : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}