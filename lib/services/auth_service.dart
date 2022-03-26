import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/global/environment.dart';

class AuthService with ChangeNotifier {
  late User user;
  bool _isLoadingAuth = false;
  final _storage = const FlutterSecureStorage();

  bool get isLoadingAuth => _isLoadingAuth;
  set isLoadingAuth(bool value) {
    _isLoadingAuth = value;
    notifyListeners();
  }

  static Future<String?> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    isLoadingAuth = true;

    final data = {'email': email, 'password': password};

    final response = await http.post(
        Uri.parse('${Environment.apiUrl}/sessions'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});

    isLoadingAuth = false;

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      user = loginResponse.user;

      await _saveToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _deleteToken(String token) async {
    return await _storage.delete(key: 'token');
  }
}
