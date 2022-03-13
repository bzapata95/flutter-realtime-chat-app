import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final Widget? prefixIcon;
  final String? hinText;
  final bool obscureText;
  final TextEditingController? textController;
  final TextInputType? keyboardType;

  const CustomInput(
      {Key? key,
      this.prefixIcon,
      this.hinText,
      this.obscureText = false,
      this.textController,
      this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 5),
                  blurRadius: 5)
            ]),
        child: TextField(
          controller: textController,
          autocorrect: false,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
              prefixIcon: prefixIcon,
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: hinText),
        ));
  }
}
