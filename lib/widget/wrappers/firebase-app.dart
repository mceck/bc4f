import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/utils/logger.dart';

class FirebaseApplication extends StatelessWidget {
  final Widget child;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  FirebaseApplication({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (ctx, snap) {
        if (snap.hasError) {
          return Center(child: Text('Firebase init error'));
        }
        if (snap.hasData) {
          log.info('firebase initialized ${snap.data}');
          return child;
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
