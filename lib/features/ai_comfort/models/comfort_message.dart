enum ComfortMessageRole {
  user,
  assistant,
}

class ComfortMessage {
  final String text;
  final ComfortMessageRole role;
  final DateTime createdAt;

  const ComfortMessage({
    required this.text,
    required this.role,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "text": text,
      "role": role.name,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory ComfortMessage.fromMap(Map<String, dynamic> map) {
    return ComfortMessage(
      text: (map["text"] ?? "").toString(),
      role: map["role"] == ComfortMessageRole.assistant.name
          ? ComfortMessageRole.assistant
          : ComfortMessageRole.user,
      createdAt: DateTime.tryParse(
        (map["createdAt"] ?? "").toString(),
      ) ??
          DateTime.now(),
    );
  }
}