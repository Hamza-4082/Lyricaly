import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _role;

  bool get isAuth => _token != null;
  String? get token => _token;
  String? get userId => _userId;
  String? get role => _role;

  Future<void> login(String email, String password) async {
    // TODO: Replace with Firebase Identity Toolkit REST call
    _token = "dummyToken";
    _userId = "dummyUid";
    _role = email.contains("admin")
        ? "admin"
        : email.contains("adv")
        ? "advertiser"
        : "user";
    notifyListeners();
  }

  void logout() {
    _token = null;
    _userId = null;
    _role = null;
    notifyListeners();
  }
}
