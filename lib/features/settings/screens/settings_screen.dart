import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../../../core/theme/app_colours.dart';
import '../../../services/notification_service.dart';
import '../../auth/screen/auth_screen.dart';
import '../../auth/services/auth_service.dart';
import 'notification_permission_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool calmMode = false;
  bool hapticsEnabled = true;
  bool darkMode = false;
  bool isLoggingOut = false;

  TimeOfDay reminderTime = const TimeOfDay(hour: 20, minute: 0);

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      notificationsEnabled = prefs.getBool("notificationsEnabled") ?? true;
      calmMode = prefs.getBool("calmMode") ?? false;
      hapticsEnabled = prefs.getBool("hapticsEnabled") ?? true;
      darkMode = prefs.getBool("darkMode") ?? false;

      final hour = prefs.getInt("reminderHour") ?? 20;
      final minute = prefs.getInt("reminderMinute") ?? 0;

      reminderTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> toggleDarkMode(bool value) async {
    setState(() {
      darkMode = value;
    });

    await saveBool("darkMode", value);
    isDarkMode.value = value;
  }

  Future<void> saveReminderTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("reminderHour", time.hour);
    await prefs.setInt("reminderMinute", time.minute);
  }

  Future<void> pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: reminderTime,
    );

    if (picked == null) return;

    setState(() {
      reminderTime = picked;
    });

    await saveReminderTime(picked);

    if (notificationsEnabled) {
      await NotificationService.initialize();

      await NotificationService.scheduleDailyReminder(
        hour: picked.hour,
        minute: picked.minute,
      );
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Reminder time changed to ${formatTime(picked)}.",
        ),
      ),
    );
  }

  Future<void> toggleNotifications(bool value) async {
    setState(() {
      notificationsEnabled = value;
    });

    await saveBool("notificationsEnabled", value);

    if (value) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const NotificationPermissionScreen(),
        ),
      );

      await NotificationService.initialize();

      await NotificationService.scheduleDailyReminder(
        hour: reminderTime.hour,
        minute: reminderTime.minute,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Daily reminder set for ${formatTime(reminderTime)}.",
          ),
        ),
      );
    } else {
      await NotificationService.cancelDailyReminder();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Daily reminders turned off."),
        ),
      );
    }
  }

  Future<void> toggleHaptics(bool value) async {
    setState(() {
      hapticsEnabled = value;
    });

    await saveBool("hapticsEnabled", value);

    if (value) {
      HapticFeedback.lightImpact();
    }
  }

  Future<void> logoutUser() async {
    setState(() {
      isLoggingOut = true;
    });

    await AuthService().logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthScreen(),
      ),
          (route) => false,
    );
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";

    return "$hour:$minute $period";
  }

  void showAboutMindBloom() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.nightCard : AppColors.cream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: Text(
            "About MindBloom",
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.nightText : AppColors.textDark,
            ),
          ),
          content: Text(
            "MindBloom is a calm emotional wellness app created to help users reflect, journal, track moods, and build self-awareness through a soft and private experience.",
            style: GoogleFonts.poppins(
              height: 1.6,
              color: isDark ? AppColors.nightTextSoft : AppColors.textSoft,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close",
                style: GoogleFonts.poppins(
                  color: isDark ? AppColors.nightBlue : AppColors.deepBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showVersionDetails() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.nightCard : AppColors.cream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: Text(
            "Version Details",
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.nightText : AppColors.textDark,
            ),
          ),
          content: Text(
            "MindBloom v1.0.0\n\nFirst Flutter project build.\nIncludes mood tracking, diary journaling, profile, settings, Firebase authentication, Firestore storage, and emotional UI polish.",
            style: GoogleFonts.poppins(
              height: 1.6,
              color: isDark ? AppColors.nightTextSoft : AppColors.textSoft,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close",
                style: GoogleFonts.poppins(
                  color: isDark ? AppColors.nightBlue : AppColors.deepBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildSectionTitle(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14, top: 6),
      child: Text(
        title,
        style: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.nightText : AppColors.textDark,
        ),
      ),
    );
  }

  Widget buildTile({
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDanger = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tileColor =
    isDark ? AppColors.nightCard : Colors.white.withOpacity(0.62);

    final borderColor =
    isDark ? AppColors.nightBorder : Colors.white.withOpacity(0.8);

    final titleColor = isDanger
        ? const Color(0xFFD98282)
        : isDark
        ? AppColors.nightText
        : AppColors.textDark;

    final subtitleColor =
    isDark ? AppColors.nightTextSoft : AppColors.textSoft;

    final iconBackground = isDanger
        ? const Color(0xFFFFE7E7)
        : isDark
        ? AppColors.nightCardSoft
        : AppColors.blush;

    final iconColor = isDanger
        ? const Color(0xFFD98282)
        : isDark
        ? AppColors.nightBlue
        : AppColors.deepBlue;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.20)
                : AppColors.softPurple.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        leading: Container(
          height: 50,
          width: 50,
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
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: subtitleColor,
            ),
          ),
        ),
        trailing: trailing,
      ),
    );
  }

  Icon trailingArrow() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16,
      color: isDark ? AppColors.nightTextSoft : AppColors.textSoft,
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
          "Settings",
          style: GoogleFonts.playfairDisplay(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.nightText : AppColors.textDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle("Preferences"),

            buildTile(
              title: "Night Bloom Mode",
              subtitle: darkMode
                  ? "Soft navy theme is enabled"
                  : "Switch to a calmer night theme",
              icon: Icons.dark_mode_rounded,
              trailing: Switch(
                value: darkMode,
                activeColor: AppColors.nightBlue,
                onChanged: toggleDarkMode,
              ),
              onTap: () => toggleDarkMode(!darkMode),
            ),

            buildTile(
              title: "Notifications",
              subtitle: notificationsEnabled
                  ? "Gentle reflection reminders are enabled"
                  : "Turn on gentle reflection reminders",
              icon: Icons.notifications_active_rounded,
              trailing: Switch(
                value: notificationsEnabled,
                activeColor: AppColors.lakeBlue,
                onChanged: toggleNotifications,
              ),
              onTap: () => toggleNotifications(!notificationsEnabled),
            ),

            buildTile(
              title: "Reminder Time",
              subtitle: formatTime(reminderTime),
              icon: Icons.schedule_rounded,
              trailing: trailingArrow(),
              onTap: pickReminderTime,
            ),

            buildTile(
              title: "Calm Mode",
              subtitle: calmMode
                  ? "Calm mode preference is enabled"
                  : "Reduce overwhelming visual stimulation",
              icon: Icons.spa_rounded,
              trailing: Switch(
                value: calmMode,
                activeColor: AppColors.mint,
                onChanged: (value) async {
                  setState(() {
                    calmMode = value;
                  });

                  await saveBool("calmMode", value);
                },
              ),
            ),

            buildTile(
              title: "Haptic Feedback",
              subtitle: hapticsEnabled
                  ? "Soft touch feedback is enabled"
                  : "Subtle vibration during interactions",
              icon: Icons.vibration_rounded,
              trailing: Switch(
                value: hapticsEnabled,
                activeColor: AppColors.softPurple,
                onChanged: toggleHaptics,
              ),
            ),

            const SizedBox(height: 18),

            buildSectionTitle("About"),

            buildTile(
              title: "MindBloom",
              subtitle: "A reflective emotional wellness experience",
              icon: Icons.favorite_rounded,
              trailing: trailingArrow(),
              onTap: showAboutMindBloom,
            ),

            buildTile(
              title: "Version",
              subtitle: "v1.0.0",
              icon: Icons.info_outline_rounded,
              trailing: trailingArrow(),
              onTap: showVersionDetails,
            ),

            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}