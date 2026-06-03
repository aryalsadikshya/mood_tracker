import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/mood.dart';
import '../services/mood_storage.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Mood> moods = [];
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadMoods();
  }

  void loadMoods() async {
    final data = await MoodStorage.loadMoods();
    setState(() {
      moods = data;
    });
  }

  String? getMoodForDay(DateTime day) {
    for (var mood in moods) {
      final date = DateTime.parse(mood.date);
      if (date.year == day.year &&
          date.month == day.month &&
          date.day == day.day) {
        return mood.mood;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2100),
              focusedDay: selectedDay,
              selectedDayPredicate: (day) =>
                  isSameDay(selectedDay, day),
              onDaySelected: (selected, focused) {
                setState(() {
                  selectedDay = selected;
                });
              },

              /// 👇 Mood Indicator
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final mood = getMoodForDay(day);

                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: mood == null
                          ? null
                          : Colors.purple.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text("${day.day}"),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// Selected day mood
            Text(
              "Mood: ${getMoodForDay(selectedDay) ?? "No entry"}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}