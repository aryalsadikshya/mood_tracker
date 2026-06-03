import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mood.dart';
import '../services/mood_storage.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<Mood> moods = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final data = await MoodStorage.loadMoods();
    setState(() {
      moods = data;
    });
  }

  /// 📊 Count moods
  Map<String, int> getStats() {
    Map<String, int> stats = {};
    for (var m in moods) {
      stats[m.mood] = (stats[m.mood] ?? 0) + 1;
    }
    return stats;
  }

  /// ⭐ Most frequent mood
  String getTopMood() {
    final stats = getStats();
    if (stats.isEmpty) return "None";

    return stats.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
  String getInsight() {
    if (moods.isEmpty) return "Start tracking your mood";

    final top = getTopMood();
    return "You feel $top most often. Keep monitoring your emotional patterns.";
  }

  /// 📅 Weekly Data (last 7 entries)
  List<BarChartGroupData> getWeeklyData() {
    final last7 = moods.take(7).toList();

    return List.generate(last7.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (getStats()[last7[index].mood] ?? 1).toDouble(),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final stats = getStats();

    return Scaffold(
      appBar: AppBar(title: const Text("Statistics")

      ),
      body: moods.isEmpty
          ? const Center(child: Text("No data yet"))
          : SingleChildScrollView(
            child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 📊 Summary Card
              Container(
                margin: const EdgeInsets.only(bottom:20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Entries: ${moods.length}"),
                    const SizedBox(height: 8),
                    Text("Top Mood: ${getTopMood()}"),
                  ],
                ),
              ),
            
              const SizedBox(height: 20),
            
              /// 📈 Chart Title
              const Text(
                "Weekly Activity",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            
              const SizedBox(height: 10),
            
              /// 📊 Chart
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(show: false),
                    barGroups: getWeeklyData(),
                  ),
                ),
              ),
            
              const SizedBox(height: 20),
            
              /// 📋 Mood Breakdown
              const Text(
                "Mood Breakdown",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            
              const SizedBox(height: 10),
            
              ...stats.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text("${e.key} - ${e.value} times"),
                );
              }),
            ],
                    ),
                  ),
          ),
    );
  }
}