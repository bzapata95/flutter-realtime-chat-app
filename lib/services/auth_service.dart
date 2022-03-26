import 'dart:convert';

import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/global/environment.dart';

class AuthService with ChangeNotifier {
  late User user;
  bool _isLoadingAuth = false;

  bool get isLoadingAuth => _isLoadingAuth;
  set isLoadingAuth(bool value) {
    _isLoadingAuth = value;
    notifyListeners();
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

      // TODO: save token
      return true;
    } else {
      return false;
    }
  }
}
