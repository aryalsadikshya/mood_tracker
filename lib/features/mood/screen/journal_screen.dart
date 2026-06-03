import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colours.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/empty_state_card.dart';
import '../models/mood_model.dart';
import '../services/mood_service.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Write something before saving."),
        ),
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Journal saved."),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save journal: $e"),
        ),
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
      backgroundColor: AppColors.cream,
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
    return Stack(
      children: [
        Container(
          color: AppColors.cream,
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _PastelGridPainter(),
          ),
        ),
        Positioned(
          top: -80,
          right: -70,
          child: _GlowCircle(
            color: AppColors.lavender.withOpacity(0.55),
            size: 220,
          ),
        ),
        Positioned(
          bottom: 120,
          left: -80,
          child: _GlowCircle(
            color: AppColors.paleBlue.withOpacity(0.55),
            size: 240,
          ),
        ),
      ],
    );
  }
}

class _PastelGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final whitePaint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..strokeWidth = 22;

    final lavenderPaint = Paint()
      ..color = AppColors.lavender.withOpacity(0.26)
      ..strokeWidth = 14;

    final bluePaint = Paint()
      ..color = AppColors.paleBlue.withOpacity(0.30)
      ..strokeWidth = 10;

    final blushPaint = Paint()
      ..color = AppColors.blush.withOpacity(0.24)
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
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

class _DiaryTitle extends StatelessWidget {
  const _DiaryTitle();

  @override
  Widget build(BuildContext context) {
    final letters = ["D", "i", "a", "r", "y"];
    final colors = [
      AppColors.warmYellow,
      AppColors.blush,
      AppColors.lavender,
      AppColors.paleBlue,
      AppColors.mint,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        letters.length,
            (index) {
          return Transform.rotate(
            angle: index.isEven ? -0.045 : 0.045,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: colors[index],
                border: Border.all(
                  color: AppColors.textDark,
                  width: 1.4,
                ),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.softPurple.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                letters[index],
                style: GoogleFonts.playfairDisplay(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ),
          );
        },
      ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.70),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.85),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.lakeBlue.withOpacity(0.12),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Text(
        prompt,
        textAlign: TextAlign.center,
        style: GoogleFonts.playfairDisplay(
          fontSize: 25,
          fontWeight: FontWeight.w700,
          height: 1.35,
          color: AppColors.deepBlue,
        ),
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 22),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFEFA),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: AppColors.deepBlue,
              width: 1.8,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.lakeBlue.withOpacity(0.20),
                blurRadius: 30,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  const _PaperLines(),
                  TextField(
                    controller: controller,
                    maxLines: 14,
                    minLines: 12,
                    keyboardType: TextInputType.multiline,
                    cursorColor: AppColors.deepBlue,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      height: 1.85,
                      color: AppColors.textDark,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                      "Dear diary...\n\nToday I felt...\n\nSomething I want to remember is...\n\nMaybe tomorrow I need...",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        height: 1.85,
                        color: AppColors.textSoft.withOpacity(0.62),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSaving ? null : onSave,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.deepBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: isSaving
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    "Save Diary Note",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const Positioned(
          top: -18,
          right: 24,
          child: _Star(size: 26),
        ),

        const Positioned(
          left: 18,
          bottom: 82,
          child: _Star(size: 20),
        ),
      ],
    );
  }
}

class _PaperLines extends StatelessWidget {
  const _PaperLines();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _PaperLinePainter(),
      ),
    );
  }
}

class _PaperLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.lavender.withOpacity(0.48)
      ..strokeWidth = 1.3;

    for (double y = 35; y < size.height; y += 32) {
      canvas.drawLine(
        Offset(4, y),
        Offset(size.width - 4, y),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _Star extends StatelessWidget {
  final double size;

  const _Star({
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "⭐",
      style: TextStyle(fontSize: size),
    );
  }
}

class _JournalHistory extends StatelessWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  final String Function(DateTime date) formatDate;

  const _JournalHistory({
    required this.stream,
    required this.formatDate,
  });

  Future<void> deleteJournal(
      BuildContext context,
      String docId,
      ) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("journals")
        .doc(docId)
        .delete();

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Diary note deleted."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppLoading(
            message: "Loading diary notes...",
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(34),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.blush.withOpacity(0.95),
                  AppColors.lavender.withOpacity(0.90),
                  AppColors.paleBlue.withOpacity(0.92),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(34),
              border: Border.all(
                color: Colors.white.withOpacity(0.9),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.softPurple.withOpacity(0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 82,
                  width: 82,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.55),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "📔",
                    style: TextStyle(fontSize: 40),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  "Your diary is still empty",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  "The thoughts you write here become quiet emotional memories you can revisit later.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.7,
                    color: AppColors.textSoft,
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    "Write your first reflection tonight",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepBlue,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Diary Memories",
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 16),

            ...docs.map((doc) {
              final data = doc.data();

              final text = (data["text"] ?? "").toString();

              final createdAt = data["createdAt"] is Timestamp
                  ? (data["createdAt"] as Timestamp).toDate()
                  : DateTime.now();

              return _SavedDiaryCard(
                text: text,
                date: formatDate(createdAt),
                index: docs.indexOf(doc),
                onDelete: () {
                  deleteJournal(context, doc.id);
                },
              );
            }),
          ],
        );
      },
    );
  }
}

class _SavedDiaryCard extends StatelessWidget {
  final String text;
  final String date;
  final int index;
  final VoidCallback onDelete;

  const _SavedDiaryCard({
    required this.text,
    required this.date,
    required this.index,
    required this.onDelete,
  });

  Color getCardColor() {
    final colors = [
      AppColors.blush,
      AppColors.lavender,
      AppColors.paleBlue,
      AppColors.mint,
      AppColors.warmYellow,
      AppColors.peach,
    ];

    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = getCardColor();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cardColor.withOpacity(0.88),
            Colors.white.withOpacity(0.65),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.30),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.60),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepBlue,
                  ),
                ),
              ),

              const Spacer(),

              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.deepBlue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 15,
              height: 1.7,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}