import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../firebase_rest_config.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _userRole; // 'user' | 'admin' | 'advertiser'

  bool get isAuth => _token != null;
  String? get token => _token;
  String? get userId => _userId;
  String? get userRole => _userRole;

  Future<void> signup(String email, String password, String role) async {
    final url = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${FirebaseRestConfig.apiKey}",
    );

    final resp = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    final data = json.decode(resp.body);
    if (data['error'] != null) {
      throw Exception(data['error']['message']);
    }

    _token = data['idToken'];
    _userId = data['localId'];
    _userRole = role;

    // store role in DB
    final roleUrl = Uri.parse(
        "${FirebaseRestConfig.databaseURL}users/$_userId/role.json?auth=$_token");
    await http.put(roleUrl, body: json.encode(role));

    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${FirebaseRestConfig.apiKey}",
    );
    final resp = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    final data = json.decode(resp.body);
    if (data['error'] != null) {
      throw Exception(data['error']['message']);
    }

    _token = data['idToken'];
    _userId = data['localId'];

    // fetch role
    final roleUrl = Uri.parse(
        "${FirebaseRestConfig.databaseURL}users/$_userId/role.json?auth=$_token");
    final roleResp = await http.get(roleUrl);
    final roleData = json.decode(roleResp.body);

    _userRole = (roleData is String && roleData.isNotEmpty) ? roleData : 'user';

    notifyListeners();
  }


  void logout() {
    _token = null;
    _userId = null;
    _userRole = null;
    notifyListeners();
  }
}
