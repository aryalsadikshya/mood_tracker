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

      if (data == null) return;

      setState(() {
        usernameController.text =
            (data["username"] ?? data["name"] ?? "").toString();

        selectedAvatarId = (data["avatarId"] ?? "flower").toString();
      });
    } catch (_) {}
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
    final avatar = getAvatarById(selectedAvatarId);

    return Container(
      height: 140,
      width: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: avatar.color.withOpacity(0.75),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: avatar.color.withOpacity(0.35),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Icon(
        avatar.icon,
        size: 64,
        color: AppColors.deepBlue,
      ),
    );
  }

  Widget buildAvatarPicker() {
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
              color: avatar.color.withOpacity(isSelected ? 0.95 : 0.55),
              border: Border.all(
                color: isSelected ? AppColors.deepBlue : Colors.white,
                width: isSelected ? 2.4 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: avatar.color.withOpacity(isSelected ? 0.35 : 0.12),
                  blurRadius: isSelected ? 18 : 10,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              avatar.icon,
              color: AppColors.deepBlue,
              size: 30,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildNameField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.85),
        ),
      ),
      child: TextField(
        controller: usernameController,
        style: GoogleFonts.poppins(
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter your name",
          hintStyle: GoogleFonts.poppins(
            color: AppColors.textSoft,
          ),
          icon: const Icon(
            Icons.person_outline_rounded,
            color: AppColors.deepBlue,
          ),
        ),
      ),
    );
  }

  Widget buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : saveProfile,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.lakeBlue,
          foregroundColor: Colors.white,
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
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.playfairDisplay(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
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
                color: AppColors.textSoft,
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