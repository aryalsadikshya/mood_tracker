import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/theme/app_colours.dart';
import '../mood/models/mood_model.dart';
import '../mood/services/mood_service.dart';

class MoodCalendarScreen extends StatefulWidget {
  const MoodCalendarScreen({super.key});

  @override
  State<MoodCalendarScreen> createState() => _MoodCalendarScreenState();
}

class _MoodCalendarScreenState extends State<MoodCalendarScreen> {
  final MoodService moodService = MoodService();

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  Color getMoodColor(String moodLabel) {
    switch (moodLabel) {
      case "Happy":
        return AppColors.softPink;

      case "Calm":
        return AppColors.mint;

      case "Okay":
        return AppColors.warmYellow;

      case "Low":
        return AppColors.paleBlue;

      case "Stressed":
        return AppColors.softPurple;

      default:
        return AppColors.border;
    }
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
          "Mood Calendar",
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ),

      body: StreamBuilder<List<MoodModel>>(
        stream: moodService.getMoods(),
        builder: (context, snapshot) {
          final moods = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.55),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.softPurple.withOpacity(0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: TableCalendar(
                focusedDay: focusedDay,
                firstDay: DateTime.utc(2024),
                lastDay: DateTime.utc(2030),

                selectedDayPredicate: (day) {
                  return isSameDay(selectedDay, day);
                },

                onDaySelected: (selected, focused) {
                  setState(() {
                    selectedDay = selected;
                    focusedDay = focused;
                  });
                },

                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,

                  todayDecoration: BoxDecoration(
                    color: AppColors.lakeBlue.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),

                  selectedDecoration: const BoxDecoration(
                    color: AppColors.lakeBlue,
                    shape: BoxShape.circle,
                  ),

                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),

                  defaultTextStyle: GoogleFonts.poppins(
                    color: AppColors.textDark,
                    fontSize: 13,
                  ),

                  weekendTextStyle: GoogleFonts.poppins(
                    color: AppColors.textDark,
                    fontSize: 13,
                  ),
                ),

                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,

                  titleTextStyle: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),

                  leftChevronIcon: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.deepBlue,
                  ),

                  rightChevronIcon: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.deepBlue,
                  ),
                ),

                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    MoodModel? moodForDay;

                    for (final mood in moods) {
                      if (isSameDay(mood.createdAt, day)) {
                        moodForDay = mood;
                        break;
                      }
                    }

                    if (moodForDay == null) {
                      return Center(
                        child: Text(
                          "${day.day}",
                          style: GoogleFonts.poppins(
                            color: AppColors.textSoft,
                          ),
                        ),
                      );
                    }

                    return Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: getMoodColor(moodForDay.moodLabel),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${day.day}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}