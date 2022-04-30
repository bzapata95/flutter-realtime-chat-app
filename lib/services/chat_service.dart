import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  late User userTo;

  Future getChat(String userId) async {
    final token = await AuthService.getToken();

    final response = await http.get(
        Uri.parse('${Environment.apiUrl}/messages/$userId'),
        headers: {'Content-Type': 'application/json', 'x-token': token!});

    final messages = messagesResponseFromJson(response.body);

    return messages;
  }
}
