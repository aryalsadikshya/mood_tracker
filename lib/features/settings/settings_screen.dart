import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colours.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool calmMode = false;
  bool hapticsEnabled = true;

  TimeOfDay reminderTime = const TimeOfDay(hour: 20, minute: 0);

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      notificationsEnabled =
          prefs.getBool("notificationsEnabled") ?? true;

      calmMode =
          prefs.getBool("calmMode") ?? false;

      hapticsEnabled =
          prefs.getBool("hapticsEnabled") ?? true;

      final hour = prefs.getInt("reminderHour") ?? 20;
      final minute = prefs.getInt("reminderMinute") ?? 0;

      reminderTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
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

    if (picked != null) {
      setState(() {
        reminderTime = picked;
      });

      await saveReminderTime(picked);
    }
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, top: 6),
      child: Text(
        title,
        style: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
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
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.62),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withOpacity(0.12),
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
            color: AppColors.blush,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.deepBlue,
          ),
        ),

        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSoft,
            ),
          ),
        ),

        trailing: trailing,
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
          "Settings",
          style: GoogleFonts.playfairDisplay(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
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
              title: "Notifications",
              subtitle: "Daily emotional check-in reminders",
              icon: Icons.notifications_active_rounded,
              trailing: Switch(
                value: notificationsEnabled,
                activeColor: AppColors.lakeBlue,
                onChanged: (value) async {
                  setState(() {
                    notificationsEnabled = value;
                  });

                  await saveBool(
                    "notificationsEnabled",
                    value,
                  );
                },
              ),
            ),

            buildTile(
              title: "Reminder Time",
              subtitle:
              "${reminderTime.hour}:${reminderTime.minute.toString().padLeft(2, '0')}",
              icon: Icons.schedule_rounded,
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.textSoft,
              ),
              onTap: pickReminderTime,
            ),

            buildTile(
              title: "Calm Mode",
              subtitle:
              "Reduce overwhelming visual stimulation",
              icon: Icons.spa_rounded,
              trailing: Switch(
                value: calmMode,
                activeColor: AppColors.mint,
                onChanged: (value) async {
                  setState(() {
                    calmMode = value;
                  });

                  await saveBool(
                    "calmMode",
                    value,
                  );
                },
              ),
            ),

            buildTile(
              title: "Haptic Feedback",
              subtitle:
              "Subtle vibration during interactions",
              icon: Icons.vibration_rounded,
              trailing: Switch(
                value: hapticsEnabled,
                activeColor: AppColors.softPurple,
                onChanged: (value) async {
                  setState(() {
                    hapticsEnabled = value;
                  });

                  await saveBool(
                    "hapticsEnabled",
                    value,
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            buildSectionTitle("About"),

            buildTile(
              title: "MindBloom",
              subtitle:
              "A reflective emotional wellness experience",
              icon: Icons.favorite_rounded,
            ),

            buildTile(
              title: "Version",
              subtitle: "v1.0.0",
              icon: Icons.info_outline_rounded,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}