import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';

class HomepageScreen extends StatefulWidget {
  static const route = '/';

  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  @override
  Widget build(BuildContext context) {
    return Bc4fScaffold(
      title: Text('Homepage'),
      body: Center(child: Text('Homepage')),
    );
  }
}
