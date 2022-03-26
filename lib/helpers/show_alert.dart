import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlert(BuildContext context, String title, String? subtitle) {
  if (Platform.isAndroid) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: subtitle != null ? Text(subtitle) : null,
          actions: <Widget>[
            MaterialButton(
                elevation: 5,
                color: Colors.blue,
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok'))
          ],
        );
      },
    );
  }

  showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
            title: Text(title),
            content: subtitle != null ? Text(subtitle) : null,
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));
}
