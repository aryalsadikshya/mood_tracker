import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood.dart';

class MoodStorage {
  static const String key = "moods";

  static Future<void> saveMoods(List<Mood> moods) async {
    final prefs = await SharedPreferences.getInstance();
    final data = moods.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(key, data);
  }

  static Future<List<Mood>> loadMoods() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];

    return data.map((e) => Mood.fromJson(jsonDecode(e))).toList();
  }
}