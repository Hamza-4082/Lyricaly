import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/songs.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  Song? _current; // ✅ keep track of the current song
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  Song? get current => _current; // ✅ public getter
  Duration get duration => _duration;
  Duration get position => _position;
  bool get isPlaying => _isPlaying;

  PlayerProvider() {
    // listen for position updates
    _player.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    // listen for duration updates
    _player.durationStream.listen((dur) {
      if (dur != null) {
        _duration = dur;
        notifyListeners();
      }
    });

    // listen for play/pause state
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });
  }

  Future<void> play(Song song) async {
    try {
      _current = song; // ✅ set current song
      await _player.setUrl(song.audioUrl); // make sure Song has a `url` field
      await _player.play();
      notifyListeners();
    } catch (e) {
      debugPrint("Error playing song: $e");
    }
  }

  Future<void> pause() async {
    await _player.pause();
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
