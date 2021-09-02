import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketing_system/Models/UserModel.dart';
import 'package:ticketing_system/Models/api_response.dart';

class UserRepository {
  // Caching user data
  static saveUserData(ApiResponse response) async {
    // Extracting data object from json
    String data = jsonEncode(response.data);
    // Storing it to sharedPreferences
    final preferences = await SharedPreferences.getInstance();
    preferences.setString("user", data);
  }

  static logout() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  // Get cached user data
  static Future<UserModel?> getUserData() async {
    final preferences = await SharedPreferences.getInstance();
    String? userJson = preferences.getString("user");
    if(userJson == null)
      return null;
    return UserModel.fromJson(json.decode(userJson));
  }
}