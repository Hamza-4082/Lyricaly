class Survey {
  final String id;
  final String question;
  final List<String> options;
  final String authorId;
  final int timestamp;

  Survey({
    required this.id,
    required this.question,
    required this.options,
    required this.authorId,
    required this.timestamp,
  });

  factory Survey.fromMap(String id, Map<String, dynamic> map) {
    return Survey(
      id: id,
      question: map['question'] ?? '',
      options: (map['options'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      authorId: map['authorId'] ?? '',
      timestamp: map['timestamp'] ?? 0,
    );
  }
}