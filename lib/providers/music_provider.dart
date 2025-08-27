// lib/providers/music_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../firebase_rest_config.dart';
import '../models/songs.dart';

class MusicProvider with ChangeNotifier {
  List<Song> _songs = [];
  bool _loading = false;

  List<Song> get songs => List.unmodifiable(_songs);
  bool get isLoading => _loading;

  // Fetch all songs from Firebase
  Future<void> fetchSongs({String? token}) async {
    _loading = true;
    notifyListeners();
    try {
      final url = Uri.parse(
        '${FirebaseRestConfig.databaseURL}songs.json${token != null ? '?auth=$token' : ''}',
      );
      final resp = await http.get(url);
      if (resp.statusCode != 200) {
        throw Exception('GET ${url.toString()} failed: ${resp.statusCode} ${resp.body}');
      }

      final decoded = json.decode(resp.body);
      final List<Song> loaded = [];
      if (decoded == null) {
        _songs = [];
      } else if (decoded is Map<String, dynamic>) {
        decoded.forEach((id, value) {
          if (value is Map<String, dynamic>) {
            loaded.add(Song.fromMap(id, value));
          } else if (value is Map) {
            loaded.add(Song.fromMap(id, Map<String, dynamic>.from(value)));
          }
        });
        _songs = loaded;
      } else if (decoded is List) {
        for (var i = 0; i < decoded.length; i++) {
          final value = decoded[i];
          if (value is Map) {
            loaded.add(Song.fromMap(i.toString(), Map<String, dynamic>.from(value)));
          }
        }
        _songs = loaded;
      } else {
        _songs = [];
      }
    } catch (e, st) {
      debugPrint('[MusicProvider] fetchSongs error: $e\n$st');
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Add a new song to Firebase
  Future<Song> addSong({
    required String title,
    required String artist,
    required String audioUrl,
    required String token,
  }) async {
    final body = {
      'title': title,
      'artist': artist,
      'audioUrl': audioUrl,
    };

    final url = Uri.parse(
      '${FirebaseRestConfig.databaseURL}songs.json?auth=$token',
    );

    final resp = await http.post(
      url,
      body: json.encode(body),
    );

    if (resp.statusCode != 200) {
      throw Exception('POST ${url.toString()} failed: ${resp.statusCode} ${resp.body}');
    }

    final decoded = json.decode(resp.body);
    final newId = decoded['name'];

    final newSong = Song(
      id: newId,
      title: title,
      artist: artist,
      audioUrl: audioUrl,
    );

    _songs.add(newSong);
    notifyListeners();

    return newSong;
  }

  // Local search (used in SearchScreen)
  List<Song> searchLocal(String query) {
    if (query.isEmpty) return _songs;
    final lower = query.toLowerCase();
    return _songs.where((s) {
      return s.title.toLowerCase().contains(lower) ||
          s.artist.toLowerCase().contains(lower);
    }).toList();
  }
}
