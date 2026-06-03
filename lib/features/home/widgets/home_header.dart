import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/navigation/soft_page_route.dart';
import '../../../core/theme/app_colours.dart';
import '../../../core/theme/app_radius.dart';
import '../../settings/screens/settings_screen.dart';

class HomeHeader extends StatelessWidget {
  final String greeting;
  final String subGreeting;

  const HomeHeader({
    super.key,
    required this.greeting,
    required this.subGreeting,
  });

  void openReminderSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.82,
              ),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius:BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: Colors.white.withOpacity(0.9)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.softPurple.withOpacity(0.25),
                    blurRadius: 30,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 5,
                      width: 46,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      height: 68,
                      width: 68,
                      decoration: BoxDecoration(
                        color: AppColors.paleBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        size: 32,
                        color: AppColors.deepBlue,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "Daily Check-In Reminder",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Your reminder settings help MindBloom gently bring you back to your reflection space.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.textSoft,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          openSoftPage(
                            context,
                            const SettingsScreen(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.lakeBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: Text(
                          "Manage Reminder",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subGreeting,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSoft,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => openReminderSheet(context),
          child: Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: AppColors.paleBlue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.lakeBlue.withOpacity(0.22),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.deepBlue,
            ),
          ),
        ),
      ],
    );
  }
}