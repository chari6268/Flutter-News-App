import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  // Example fields
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  // Getters
  String? get token => _token;
  String? get userId => _userId;
  bool get isAuthenticated => _token != null;

  // Example method to log in
  Future<void> login(String email, String password) async {
    // Simulate an API call
    await Future.delayed(Duration(seconds: 2));
    _token = "dummyToken";
    _userId = "dummyUserId";
    _expiryDate = DateTime.now().add(Duration(hours: 1));
    notifyListeners(); // Notify listeners about the state change
  }

  // Example method to log out
  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners(); // Notify listeners about the state change
  }
}