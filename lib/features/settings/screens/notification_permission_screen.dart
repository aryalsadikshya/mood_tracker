import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colours.dart';
import '../../../services/notification_service.dart';

class NotificationPermissionScreen extends StatefulWidget {
  const NotificationPermissionScreen({super.key});

  @override
  State<NotificationPermissionScreen> createState() =>
      _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState
    extends State<NotificationPermissionScreen> {
  bool isLoading = false;

  Future<void> enableNotifications() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      final hour = prefs.getInt("reminderHour") ?? 20;
      final minute = prefs.getInt("reminderMinute") ?? 0;

      await NotificationService.initialize();

      await NotificationService.scheduleDailyReminder(
        hour: 20,
        minute: 0,
      );

      await prefs.setBool("notificationsEnabled", true);

      await NotificationService.showTestNotification();

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.12),
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
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
                borderRadius: BorderRadius.circular(38),
                border: Border.all(
                  color: Colors.white.withOpacity(0.9),
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.softPurple.withOpacity(0.22),
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 92,
                    width: 92,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.45),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 68,
                          width: 68,
                          decoration: const BoxDecoration(
                            color: AppColors.softPink,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Icon(
                          Icons.notifications_active_rounded,
                          size: 40,
                          color: AppColors.deepBlue,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "Gentle reminders are on",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    "MindBloom will remind you daily to pause, breathe, and check in with yourself.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.7,
                      color: AppColors.textSoft,
                    ),
                  ),

                  const SizedBox(height: 26),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.42),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      "Daily reminder scheduled",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepBlue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.deepBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: Text(
                        "Lovely",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Notification setup failed: $e"),
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

  Future<void> skipNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("notificationsEnabled", false);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 96,
                width: 96,
                decoration: const BoxDecoration(
                  color: AppColors.lavender,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  size: 48,
                  color: AppColors.deepBlue,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                "Stay Connected to Your Mind",
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                "MindBloom can gently remind you to reflect, slow down, and reconnect with yourself.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  height: 1.6,
                  color: AppColors.textSoft,
                ),
              ),

              const SizedBox(height: 42),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : enableNotifications,
                  child: isLoading
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text("Enable Notifications"),
                ),
              ),

              const SizedBox(height: 14),

              TextButton(
                onPressed: isLoading ? null : skipNotifications,
                child: const Text("Maybe Later"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}