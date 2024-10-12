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

  Future<void> getToken() async {
    _storage.read(key: "token");
  }

  Future<void> saveToken(String value) async {
    _storage.write(key: "token", value: value);
  }

  Future<void> getUser() async {
    _storage.read(key: _userKey);
  }

  Future<void> saveUser(dynamic value) async {
    _storage.write(key: _userKey, value: value);
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: _userKey);
  }
}
