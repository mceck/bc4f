import 'package:bc4f/screens/login/components/login-body.dart';
import 'package:flutter/material.dart';

enum LoginMode {
  Login,
  Signup,
}

class LoginScreen extends StatefulWidget {
  final Function toggleOffline;

  const LoginScreen({Key key, this.toggleOffline}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginMode _mode = LoginMode.Login;

  void onSetMode(LoginMode mode) => setState(() => _mode = mode);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BC4F - Login',
      // initialRoute: '/login',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  _mode == LoginMode.Login
                      ? Icons.person_add
                      : Icons.account_circle,
                  color: primaryColor,
                ),
                onPressed: () {
                  onSetMode(_mode == LoginMode.Login
                      ? LoginMode.Signup
                      : LoginMode.Login);
                })
          ],
        ),
        body: LoginBody(
          mode: _mode,
          onSetMode: onSetMode,
          toggleOffline: widget.toggleOffline,
        ),
      ),
    );
  }
}
