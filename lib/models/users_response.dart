// To parse this JSON data, do
//
//     final usersResponse = usersResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat_app/models/user.dart';

List<User> usersResponseFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String usersResponseToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
