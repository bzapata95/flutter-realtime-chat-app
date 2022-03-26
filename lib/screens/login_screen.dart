import 'package:chat_app/helpers/show_alert.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/custom_button_blue.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/labels_authentication.dart';
import 'package:chat_app/widgets/logo_authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Logo(title: 'Messenger'),
                  _Form(),
                  Labels(
                    navigateTo: 'register',
                    question: '¿No tines una cuenta?',
                    answer: 'Crea una ahora',
                  ),
                  Text('Términos y condiciones de uso',
                      style: TextStyle(fontWeight: FontWeight.w200))
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
        CustomInput(
          textController: emailCtrl,
          prefixIcon: const Icon(Icons.mail_outline),
          hinText: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        CustomInput(
          textController: passCtrl,
          prefixIcon: const Icon(Icons.lock_open),
          hinText: 'Contraseña',
          keyboardType: TextInputType.text,
          obscureText: true,
        ),
        const SizedBox(height: 30),
        CustomButtonBlue(
            text: 'Ingresar',
            onPressed: authService.isLoadingAuth
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    final res = await authService.login(
                        emailCtrl.text.trim(), passCtrl.text.trim());
                    if (res) {
                      // TODO: connect a nuestro socket server
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      showAlert(
                          context, 'Error', 'Correo o contraseña incorrectos');
                    }
                  })
      ]),
    );
  }
}
