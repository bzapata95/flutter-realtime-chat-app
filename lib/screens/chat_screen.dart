import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(children: [
            CircleAvatar(
              child: Text("Te", style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            const SizedBox(
              height: 3,
            ),
            const Text('Melissa Flores',
                style: TextStyle(color: Colors.black87, fontSize: 12)),
          ]),
          centerTitle: true,
          elevation: 1,
        ),
        body: Container(
            child: Column(children: [
          Flexible(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: _messages.length,
                  reverse: true,
                  itemBuilder: (_, i) => _messages[i])),
          const Divider(height: 1),
          _inputChat()
        ])));
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
    print(text);
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      uid: '123',
      text: text,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {});
  }

  @override
  void dispose() {
    // TODO: Off socket
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
