import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:bc4f/provider/auth.dart';
import 'package:bc4f/screens/login/login.dart';
import 'package:bc4f/utils/logger.dart';

class IsAuth extends StatelessWidget {
  final Widget child;
  final authStream = FirebaseAuth.instance.authStateChanges();

  IsAuth({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: authStream,
        builder: (ctx, snapshot) {
          log.info('auth changed ${snapshot.data}');
          if (snapshot.hasData) {
            final auth = Provider.of<Auth>(context, listen: false);
            auth.setUser(snapshot.data);
            return child;
          }
          return LoginScreen();
        });
  }
}
