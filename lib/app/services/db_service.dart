import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DBService {
  final _storage = new FlutterSecureStorage();

  final String _userKey = 'user_data';

  // Future<void> saveUser(User user) async {
  //   final userJson = jsonEncode(user.toJson());
  //   await _storage.write(key: _userKey, value: userJson);
  // }

  // Future<User?> getUser() async {
  //   final userJson = await _storage.read(key: _userKey);
  //   if (userJson != null) {
  //     final userMap = jsonDecode(userJson);
  //     return User.fromJson(userMap);
  //   }
  //   return null;
  // }

  Future<String?> getToken() async {
    // Implement the logic to retrieve the token from your database
    // Return the token or null if not found
    return ""; // Your implementation here
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: _userKey);
  }
}
