import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoadingState(context),
        builder: ((context, snapshot) {
          return const Center(
            child: Text('Espere...'),
          );
        }),
      ),
    );
  }

  Future checkLoadingState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final isAuth = await authService.isLoggedIn();
    if (isAuth) {
      // TODO: connect to socket
      Navigator.pushReplacementNamed(context, 'users');
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }
}
