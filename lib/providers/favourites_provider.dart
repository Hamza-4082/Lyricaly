import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../firebase_rest_config.dart';

class FavouritesProvider with ChangeNotifier {
  final Set<String> _favIds = {};
  bool _loading = false;

  bool get isLoading => _loading;
  Set<String> get ids => Set.unmodifiable(_favIds);
  bool isFavourite(String songId) => _favIds.contains(songId);

  Future<void> loadFavourites({
    required String userId,
    required String token,
  }) async {
    _loading = true;
    notifyListeners();
    try {
      final url = Uri.parse(
          "${FirebaseRestConfig.databaseURL}favourites/$userId.json?auth=$token");
      final resp = await http.get(url);
      final data = json.decode(resp.body);

      _favIds.clear();
      if (data is Map<String, dynamic>) {
        data.forEach((songId, val) {
          if (val == true) _favIds.add(songId);
        });
      }
    } catch (_) {
      // ignore
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavourite({
    required String songId,
    required String userId,
    required String token,
  }) async {
    final currentlyFav = _favIds.contains(songId);
    final newVal = !currentlyFav;

    // Optimistic update
    if (newVal) {
      _favIds.add(songId);
    } else {
      _favIds.remove(songId);
    }
    notifyListeners();

    final url = Uri.parse(
        "${FirebaseRestConfig.databaseURL}favourites/$userId/$songId.json?auth=$token");
    final resp = await http.put(url, body: json.encode(newVal));
    if (resp.statusCode >= 400) {
      // revert
      if (newVal) {
        _favIds.remove(songId);
      } else {
        _favIds.add(songId);
      }
      notifyListeners();
    }
  }
}
