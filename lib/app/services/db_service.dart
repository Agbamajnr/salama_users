import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:salama_users/data/models/login_data.model.dart';

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

  Future<String?> getFirebaseToken() async {
    return _storage.read(key: "firebaseToken");
  }

  Future<void> saveFirebaseToken(String value) async {
    _storage.write(key: "firebaseToken", value: value);
  }

  Future<String?> getToken() async {
    return _storage.read(key: "token");
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  Future<void> saveToken(String value) async {
    _storage.write(key: "token", value: value);
  }

  Future<User?> getUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      return User.fromJson(userMap);
    }
    return null;
  }

  Future<void> saveUser(User value) async {
    final userJson = jsonEncode(value.toJson());
    _storage.write(key: _userKey, value: userJson);
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: _userKey);
  }
}
