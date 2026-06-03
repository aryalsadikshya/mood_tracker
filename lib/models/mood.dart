class Mood {
  final String mood;
  final String date;
  final String? note;

  Mood({required this.mood, required this.date, this.note});

  Map<String, dynamic> toJson() {
    return {
      'mood': mood,
      'date': date,
      'note': note,
    };
  }

  factory Mood.fromJson(Map<String, dynamic> json) {
    return Mood(
      mood: json['mood'],
      date: json['date'],
      note: json['note'],
    );
  }
}