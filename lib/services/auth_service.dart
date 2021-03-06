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

  Future<dynamic> register(String name, String email, String password) async {
    isLoadingAuth = true;

    final data = {'name': name, 'email': email, 'password': password};

    final response = await http.post(Uri.parse('${Environment.apiUrl}/users'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    isLoadingAuth = false;

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      user = loginResponse.user;

      await _saveToken(loginResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(response.body);
      return respBody['error'];
    }
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

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    final resp = await http.get(
        Uri.parse('${Environment.apiUrl}/sessions/renew'),
        headers: {'Content-Type': 'application/json', 'x-token': token ?? ''});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;

      await _saveToken(loginResponse.token);
      return true;
    } else {
      _deleteToken();
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _deleteToken() async {
    return await _storage.delete(key: 'token');
  }
}
