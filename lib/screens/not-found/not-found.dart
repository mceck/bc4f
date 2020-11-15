import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  static final route = '/not-found';
  @override
  Widget build(BuildContext context) {
    return Bc4fScaffold(
      title: Text('404'),
      subtitle: Text('Page not found'),
      body: Center(
        child: Text('Page not found'),
      ),
    );
  }
}
