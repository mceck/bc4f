import 'package:bc4f/screens/login/components/login-body.dart';
import 'package:flutter/material.dart';

enum LoginMode { login, signup }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginMode _mode = LoginMode.login;

  void onSetMode(LoginMode mode) => setState(() => _mode = mode);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BC4F - Login',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton.icon(
              icon: Icon(
                _mode == LoginMode.login ? Icons.person_add : Icons.login,
                color: primaryColor,
              ),
              label: Text(_mode == LoginMode.login ? 'Signup' : 'Login'),
              onPressed: () {
                onSetMode(_mode == LoginMode.login
                    ? LoginMode.signup
                    : LoginMode.login);
              },
            ),
          ],
        ),
        body: LoginBody(mode: _mode, onSetMode: onSetMode),
      ),
    );
  }
}
