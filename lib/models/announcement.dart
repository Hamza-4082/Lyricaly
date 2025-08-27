class Announcement {
  final String id;
  final String text;
  final String authorId;
  final int timestamp; // ms since epoch

  Announcement({
    required this.id,
    required this.text,
    required this.authorId,
    required this.timestamp,
  });

  factory Announcement.fromMap(String id, Map<String, dynamic> m) {
    return Announcement(
      id: id,
      text: (m['text'] ?? '').toString(),
      authorId: (m['authorId'] ?? '').toString(),
      timestamp: (m['timestamp'] ?? 0) is int
          ? m['timestamp']
          : int.tryParse('${m['timestamp'] ?? 0}') ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'text': text,
    'authorId': authorId,
    'timestamp': timestamp,
  };
}
