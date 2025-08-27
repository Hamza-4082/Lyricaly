import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../firebase_rest_config.dart';
import '../models/survey.dart';

class SurveyProvider with ChangeNotifier {
  final List<Survey> _items = [];
  bool _loading = false;

  List<Survey> get surveys => List.unmodifiable(_items);
  bool get isLoading => _loading;

  Future<void> fetchSurveys({String? token}) async {
    _loading = true;
    notifyListeners();
    try {
      final url = Uri.parse(
          "${FirebaseRestConfig.databaseURL}surveys.json${token != null ? '?auth=$token' : ''}");
      print('Fetching surveys from URL: $url');
      final resp = await http.get(url);
      print('Surveys response status: ${resp.statusCode}');
      print('Surveys response body: ${resp.body}');
      final data = json.decode(resp.body);

      _items.clear();
      if (data is Map<String, dynamic>) {
        data.forEach((id, value) {
          if (value is Map<String, dynamic> &&
              value.containsKey('question') &&
              value.containsKey('options') &&
              value.containsKey('timestamp')) {
            _items.add(Survey.fromMap(id, value));
          } else {
            print('Skipping invalid survey: $id -> $value');
          }
        });
        _items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }
      print('_items after parsing: $_items');
    } catch (e) {
      print('Error fetching surveys: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addSurvey({
    required String question,
    required List<String> options,
    required String authorId,
    required String token,
  }) async {
    final url = Uri.parse(
        "${FirebaseRestConfig.databaseURL}surveys.json?auth=$token");
    final payload = {
      'question': question,
      'options': options,
      'authorId': authorId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    final resp = await http.post(url, body: json.encode(payload));
    print('Add survey response status: ${resp.statusCode}');
    print('Add survey response body: ${resp.body}');
    final data = json.decode(resp.body);
    final id = data['name'] as String;
    _items.insert(
      0,
      Survey(
        id: id,
        question: question,
        options: options,
        authorId: authorId,
        timestamp: payload['timestamp'] as int,
      ),
    );
    notifyListeners();
  }
}