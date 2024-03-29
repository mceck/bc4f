import 'package:bc4f/utils/app-status.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bc4f/screens/login/login.dart';
import 'package:bc4f/utils/logger.dart';

class IsAuth extends StatefulWidget {
  final Widget child;

  IsAuth({Key key, this.child}) : super(key: key);

  @override
  _IsAuthState createState() => _IsAuthState();
}

class _IsAuthState extends State<IsAuth> {
  final authStream = FirebaseAuth.instance.authStateChanges();

  @override
  void initState() {
    AppStatus().refreshAuthState = () => setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    AppStatus().refreshAuthState = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStatus().offlineMode
        ? widget.child
        : StreamBuilder<User>(
            stream: authStream,
            builder: (ctx, snapshot) {
              log.info('auth changed ${snapshot.data}');
              if (snapshot.connectionState == ConnectionState.waiting)
                return MaterialApp(
                  home: Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              if (snapshot.hasData) {
                AppStatus().loggedUser = snapshot.data;
                return widget.child;
              }
              return LoginScreen();
            });
  }
}
