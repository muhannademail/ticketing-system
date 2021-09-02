import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String token = "";

  getUserToken() => token;

  saveUserToken(String token) {
    this.token = token;

    notifyListeners();
  }
}