import 'package:cloud_firestore/cloud_firestore.dart';

class MoodModel {
  final String id;
  final String moodEmoji;
  final String moodLabel;
  final int moodValue;
  final List<String> activities;
  final String note;
  final DateTime createdAt;

  MoodModel({
    this.id = '',
    required this.moodEmoji,
    required this.moodLabel,
    required this.moodValue,
    required this.activities,
    required this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'moodEmoji': moodEmoji,
      'moodLabel': moodLabel,
      'moodValue': moodValue,
      'activities': activities,
      'note': note,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory MoodModel.fromMap(Map<String, dynamic> map, String id) {
    return MoodModel(
      id: id,
      moodEmoji: map['moodEmoji'] ?? '',
      moodLabel: map['moodLabel'] ?? '',
      moodValue: map['moodValue'] ?? 0,
      activities: List<String>.from(map['activities'] ?? []),
      note: map['note'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}