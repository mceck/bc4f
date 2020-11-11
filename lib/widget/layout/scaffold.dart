import 'package:bc4f/widget/layout/bottom-navbar.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/widget/layout/appbar.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/layout/drawer.dart';

class Bc4fScaffold extends StatelessWidget {
  final Widget body;
  final Widget floatAction;
  final Widget bottomNavBar;
  final PreferredSizeWidget appBar;

  const Bc4fScaffold({
    Key key,
    this.body,
    this.floatAction,
    this.bottomNavBar,
    this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Bc4fDrawer(),
      appBar: appBar ?? Bc4fAppBar(title: Text('BC4F')),
      body: DoubleBackPop(
        child: SafeArea(child: body),
      ),
      floatingActionButton: floatAction,
      bottomNavigationBar: bottomNavBar ?? Bc4fBottomNavbar(),
    );
  }
}

class DoubleBackPop extends StatefulWidget {
  final child;

  DoubleBackPop({this.child});

  @override
  _DoubleBackPopState createState() => _DoubleBackPopState();
}

class _DoubleBackPopState extends State<DoubleBackPop> {
  DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: widget.child,
      onWillPop: () => onWillPop(context),
    );
  }

  Future<bool> onWillPop(BuildContext context) {
    if (Navigator.of(context).canPop()) return Future.value(true);
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      log.info('snack');
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black87,
          content: Text(
            'Premi 2 volte per uscire',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }
}
