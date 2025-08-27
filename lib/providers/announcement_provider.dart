import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../firebase_rest_config.dart';
import '../models/announcement.dart';

class AnnouncementProvider with ChangeNotifier {
  final List<Announcement> _items = [];
  bool _loading = false;

  List<Announcement> get announcements => List.unmodifiable(_items);
  bool get isLoading => _loading;

  Future<void> fetchAnnouncements({String? token}) async {
    _loading = true;
    notifyListeners();
    try {
      final url = Uri.parse(
          "${FirebaseRestConfig.databaseURL}announcements.json${token != null ? '?auth=$token' : ''}");
      print('Fetching from URL: $url');
      final resp = await http.get(url);
      print('Response status: ${resp.statusCode}');
      print('Response body: ${resp.body}');
      final data = json.decode(resp.body);
      print('Fetched data: $data'); // Debugging

      _items.clear();
      if (data is Map<String, dynamic>) {
        data.forEach((id, value) {
          // Only add announcements that have required fields
          if (value is Map<String, dynamic> &&
              value.containsKey('text') &&
              value.containsKey('timestamp')) {
            _items.add(Announcement.fromMap(id, value));
          } else {
            print('Skipping invalid announcement: $id -> $value');
          }
        });
        _items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      } else {
        print('Data is not a Map: $data');
      }
      print('_items after parsing: $_items'); // Debugging
    } catch (e) {
      print('Error fetching announcements: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addAnnouncement({
    required String text,
    required String authorId,
    required String token,
  }) async {
    final url = Uri.parse(
        "${FirebaseRestConfig.databaseURL}announcements.json?auth=$token");
    final payload = {
      'text': text,
      'authorId': authorId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    final resp = await http.post(url, body: json.encode(payload));
    print('Add announcement response status: ${resp.statusCode}');
    print('Add announcement response body: ${resp.body}');
    final data = json.decode(resp.body);
    final id = data['name'] as String;
    _items.insert(
      0,
      Announcement(
        id: id,
        text: text,
        authorId: authorId,
        timestamp: payload['timestamp'] as int,
      ),
    );
    notifyListeners();
  }
}