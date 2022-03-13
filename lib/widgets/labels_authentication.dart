import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String navigateTo;
  final String question;
  final String answer;

  const Labels(
      {Key? key,
      required this.navigateTo,
      required this.question,
      required this.answer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(question,
          style: const TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w300)),
      const SizedBox(height: 10),
      GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, navigateTo);
        },
        child: Text(answer,
            style: TextStyle(
                color: Colors.blue[600], fontWeight: FontWeight.bold)),
      )
    ]);
  }
}
