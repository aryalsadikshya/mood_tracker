import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colours.dart';
import 'avator_catalog.dart';
import 'profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController usernameController = TextEditingController();
  final ProfileService profileService = ProfileService();

  String selectedAvatarId = "flower";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadCurrentProfile();
  }

  Future<void> loadCurrentProfile() async {
    try {
      final profileDoc = await profileService.getProfileOnce();
      final data = profileDoc.data();

      if (data == null || !mounted) return;

      setState(() {
        usernameController.text =
            (data["username"] ?? data["name"] ?? "").toString();

        selectedAvatarId = (data["avatarId"] ?? "flower").toString();
      });
    } catch (_) {
      // New users may not have profile data yet.
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    final username = usernameController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please enter your name."),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await profileService.updateProfile(
        username: username,
        avatarId: selectedAvatarId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Profile updated successfully."),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Profile update failed: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildAvatarPreview() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatar = getAvatarById(selectedAvatarId);

    return Container(
      height: 140,
      width: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: avatar.color.withOpacity(isDark ? 0.55 : 0.75),
        border: Border.all(
          color: isDark ? AppColors.nightBorder : Colors.white,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.24)
                : avatar.color.withOpacity(0.35),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Icon(
        avatar.icon,
        size: 64,
        color: isDark ? AppColors.nightText : AppColors.deepBlue,
      ),
    );
  }

  Widget buildAvatarPicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      alignment: WrapAlignment.center,
      children: mindBloomAvatars.map((avatar) {
        final bool isSelected = selectedAvatarId == avatar.id;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedAvatarId = avatar.id;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.nightCardSoft
                  : avatar.color.withOpacity(isSelected ? 0.95 : 0.55),
              border: Border.all(
                color: isSelected
                    ? isDark
                    ? AppColors.nightBlue
                    : AppColors.deepBlue
                    : isDark
                    ? AppColors.nightBorder
                    : Colors.white,
                width: isSelected ? 2.4 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(isSelected ? 0.24 : 0.12)
                      : avatar.color.withOpacity(
                    isSelected ? 0.35 : 0.12,
                  ),
                  blurRadius: isSelected ? 18 : 10,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              avatar.icon,
              color: isDark ? AppColors.nightText : AppColors.deepBlue,
              size: 30,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildNameField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.nightCard
            : Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark
              ? AppColors.nightBorder
              : Colors.white.withOpacity(0.85),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.16)
                : AppColors.softPurple.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: usernameController,
        cursorColor: isDark ? AppColors.nightBlue : AppColors.deepBlue,
        style: GoogleFonts.poppins(
          color: isDark ? AppColors.nightText : AppColors.textDark,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter your name",
          hintStyle: GoogleFonts.poppins(
            color: isDark
                ? AppColors.nightTextSoft
                : AppColors.textSoft,
          ),
          icon: Icon(
            Icons.person_outline_rounded,
            color: isDark ? AppColors.nightBlue : AppColors.deepBlue,
          ),
        ),
      ),
    );
  }

  Widget buildSaveButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : saveProfile,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
          isDark ? AppColors.nightBlue : AppColors.lakeBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: isDark
              ? AppColors.nightCardSoft
              : AppColors.lakeBlue.withOpacity(0.45),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(
          "Save Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
        isDark ? AppColors.nightBackground : AppColors.cream,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.playfairDisplay(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.nightText : AppColors.textDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            buildAvatarPreview(),

            const SizedBox(height: 16),

            Text(
              "Choose your MindBloom avatar",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDark
                    ? AppColors.nightTextSoft
                    : AppColors.textSoft,
              ),
            ),

            const SizedBox(height: 28),

            buildAvatarPicker(),

            const SizedBox(height: 34),

            buildNameField(),

            const SizedBox(height: 34),

            buildSaveButton(),
          ],
        ),
      ),
    );
  }
}