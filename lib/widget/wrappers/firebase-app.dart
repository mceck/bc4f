import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/utils/logger.dart';

class FirebaseApplication extends StatefulWidget {
  final Widget child;

  const FirebaseApplication({super.key, required this.child});

  @override
  State<FirebaseApplication> createState() => _FirebaseApplicationState();
}

class _FirebaseApplicationState extends State<FirebaseApplication> {
  late final Future<FirebaseApp> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: _initialization,
      builder: (ctx, snap) {
        if (snap.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Firebase init error')),
            ),
          );
        }
        if (snap.hasData) {
          log.info('firebase initialized ${snap.data}');
          return widget.child;
        }
        return const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
