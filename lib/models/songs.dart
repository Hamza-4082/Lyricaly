class Song {
  final String id;
  final String title;
  final String artist;
  final String audioUrl; // <— keep this exact name; providers use it


  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.audioUrl,
  });


  factory Song.fromMap(String id, Map<String, dynamic> m) {
    return Song(
      id: id,
      title: (m['title'] ?? '').toString(),
      artist: (m['artist'] ?? '').toString(),
      audioUrl: (m['audioUrl'] ?? '').toString(),
    );
  }


  Map<String, dynamic> toMap() => {
    'title': title,
    'artist': artist,
    'audioUrl': audioUrl,
  };


  Song copyWith({String? id, String? title, String? artist, String? audioUrl}) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      audioUrl: audioUrl ?? this.audioUrl,
    );
  }
}
