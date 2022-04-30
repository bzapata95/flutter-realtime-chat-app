import 'dart:io';

import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('send-message', listenMessage);

    _loadHistoryChat(chatService.userTo.uid);
  }

  void _loadHistoryChat(String uid) async {
    List<MessagesResponse> messages = await chatService.getChat(uid);
    final history = messages.map((m) => ChatMessage(
        text: m.message,
        uid: m.from,
        animationController: AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        )));

    _messages.insertAll(0, history.toList());
    setState(() {});
  }

  void listenMessage(dynamic data) {
    ChatMessage message = ChatMessage(
        text: data['message'],
        uid: data['from'],
        animationController: AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        ));
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final userTo = chatService.userTo;
    print(_messages);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(children: [
            CircleAvatar(
              child: Text(userTo.name.substring(0, 2),
                  style: const TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            const SizedBox(
              height: 3,
            ),
            Text(userTo.name,
                style: const TextStyle(color: Colors.black87, fontSize: 12)),
          ]),
          centerTitle: true,
          elevation: 1,
        ),
        body: Column(children: [
          Flexible(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _messages.length,
                  reverse: true,
                  itemBuilder: (_, i) => _messages[i])),
          const Divider(height: 1),
          _inputChat()
        ]));
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Flexible(
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmit,
                  onChanged: (String text) {
                    if (text.isEmpty) return;
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: 'Enviar mensaje'),
                  focusNode: _focusNode,
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Platform.isIOS
                      ? CupertinoButton(child: Text('Enviar'), onPressed: () {})
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          child: IconTheme(
                            data: IconThemeData(color: Colors.blue[400]),
                            child: IconButton(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: Icon(Icons.send),
                                onPressed: _textController.text.isEmpty
                                    ? null
                                    : () {}),
                          ),
                        ))
            ])));
  }

  _handleSubmit(String text) {
    if (text.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: authService.user.uid,
      text: text,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {});

    socketService.emit('send-message', {
      'from': authService.user.uid,
      'to': chatService.userTo.uid,
      'message': text,
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('send-message');
    super.dispose();
  }
}
