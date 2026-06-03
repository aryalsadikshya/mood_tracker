import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/navigation/soft_page_route.dart';
import '../../core/theme/app_colours.dart';
import '../../core/widgets/soft_tap.dart';

import '../auth/screen/auth_screen.dart';
import '../auth/services/auth_service.dart';
import '../mood/models/mood_model.dart';
import '../mood/services/mood_service.dart';
import '../settings/screens/settings_screen.dart';
import 'avator_catalog.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  double averageMood(List<MoodModel> moods) {
    if (moods.isEmpty) return 0;

    final total = moods.fold<int>(
      0,
          (sum, mood) => sum + mood.moodValue,
    );

    return total / moods.length;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfileStream() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .snapshots();
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
          "Profile",
          style: GoogleFonts.playfairDisplay(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: getProfileStream(),
          builder: (context, profileSnapshot) {
            final profileData = profileSnapshot.data?.data() ?? {};

            final username =
            (profileData["username"] ?? "").toString().trim();

            final avatarId =
            (profileData["avatarId"] ?? "flower").toString().trim();

            return StreamBuilder<List<MoodModel>>(
              stream: moodService.getMoods(),
              builder: (context, moodSnapshot) {
                final moods = moodSnapshot.data ?? [];

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileHeader(
                        username: username,
                        avatarId: avatarId,
                      ),

                      const SizedBox(height: 26),

                      const _SectionTitle(title: "Reflection Summary"),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              title: "Entries",
                              value: moods.length.toString(),
                              color: AppColors.softPink,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _StatCard(
                              title: "Average Mood",
                              value: moods.isEmpty
                                  ? "--"
                                  : averageMood(moods).toStringAsFixed(1),
                              color: AppColors.mint,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      const SizedBox(height: 30),

                      const _SectionTitle(title: "Your Emotional Energy"),

                      const SizedBox(height: 14),

                      _EmotionMeter(
                        moods: moods,
                      ),

                      const SizedBox(height: 30),

                      const _SectionTitle(title: "Account"),

                      const SizedBox(height: 14),

                      _ActionTile(
                        title: "Edit Profile",
                        subtitle: "Update your name and avatar",
                        icon: Icons.edit_rounded,
                        onTap: () {
                          openSoftPage(
                            context,
                            const EditProfileScreen(),
                          );
                        },
                      ),

                      _ActionTile(
                        title: "Settings",
                        subtitle: "Manage reminders and app preferences",
                        icon: Icons.settings_rounded,
                        onTap: () {
                          openSoftPage(
                            context,
                            const SettingsScreen(),
                          );
                        },
                      ),

                      _ActionTile(
                        title: "Logout",
                        subtitle: "End current session",
                        icon: Icons.logout_rounded,
                        isDanger: true,
                        onTap: () async {
                          await AuthService().logout();

                          if (!context.mounted) return;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AuthScreen(),
                            ),
                                (route) => false,
                          );
                        },
                      ),


                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String username;
  final String avatarId;

  const _ProfileHeader({
    required this.username,
    required this.avatarId,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasUsername = username.trim().isNotEmpty;
    final avatar = getAvatarById(avatarId);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
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
        children: [
          Container(
            height: 92,
            width: 92,
            decoration: BoxDecoration(
              color: avatar.color.withOpacity(0.75),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: avatar.color.withOpacity(0.32),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              avatar.icon,
              size: 46,
              color: AppColors.deepBlue,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            hasUsername ? username : "Personal Profile",
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Manage your account, preferences, and reflection space.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSoft,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.55),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withOpacity(0.85),
              ),
            ),
            child: Text(
              "MindBloom Account",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.deepBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.72),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.85),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.30),
            blurRadius: 22,
            offset: const Offset(0, 11),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSoft,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDanger;

  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor =
    isDanger ? const Color(0xFFD98282) : AppColors.deepBlue;

    final iconBackground =
    isDanger ? const Color(0xFFFFE7E7) : AppColors.paleBlue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SoftTap(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        pressedScale: 0.97,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteGlass,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.9),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.softPurple.withOpacity(0.10),
                blurRadius: 18,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 6,
            ),
            leading: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDanger
                    ? const Color(0xFFD98282)
                    : AppColors.textDark,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSoft,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: isDanger
                  ? const Color(0xFFD98282)
                  : AppColors.deepBlue,
            ),
          ),
        ),
      ),
    );
  }
}
class _EmotionMeter extends StatelessWidget {
  final List<MoodModel> moods;

  const _EmotionMeter({
    required this.moods,
  });

  double calculateEnergy() {
    if (moods.isEmpty) return 0.5;

    final total = moods.fold<double>(
      0,
          (sum, mood) => sum + mood.moodValue,
    );

    return (total / moods.length) / 5;
  }

  @override
  Widget build(BuildContext context) {
    final energy = calculateEnergy();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your emotional energy has been",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSoft,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            energy >= 0.75
                ? "Bright & Positive"
                : energy >= 0.5
                ? "Balanced & Calm"
                : "Emotionally Heavy",
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 20),

          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: LinearProgressIndicator(
              value: energy,
              minHeight: 16,
              backgroundColor: Colors.white.withOpacity(0.55),
              valueColor: AlwaysStoppedAnimation<Color>(
                energy >= 0.75
                    ? AppColors.softPink
                    : energy >= 0.5
                    ? AppColors.mint
                    : AppColors.softPurple,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            "This gently reflects your recent emotional patterns.",
            style: GoogleFonts.poppins(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textSoft,
            ),
          ),
        ],
      ),
    );
  }
}