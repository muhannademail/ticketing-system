import 'package:flutter/material.dart';

class TicketProvider with ChangeNotifier {
  Map<String, dynamic> ticketMap = {};

  void saveInputs(String key, dynamic value) {
    ticketMap[key] = value;
    notifyListeners();
  }
}