import 'package:flutter/material.dart';

class RegisterProvider with ChangeNotifier {
  Map<String, dynamic> registerMap = {};

  void saveInputs(String key, dynamic value) {
    registerMap[key] = value;

    notifyListeners();
  }
}