import 'package:flutter/material.dart';

class CustomButtonBlue extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const CustomButtonBlue(
      {Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            primary: Colors.white,
            elevation: 2,
            backgroundColor: Colors.blue),
        onPressed: onPressed,
        child: SizedBox(
            height: 55,
            width: double.infinity,
            child: Center(
                child: Text(text, style: const TextStyle(fontSize: 18)))));
  }
}
