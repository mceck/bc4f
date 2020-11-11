import 'package:flutter/material.dart';
import 'package:bc4f/widget/layout/appbar.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/layout/drawer.dart';

class Bc4fScaffold extends StatelessWidget {
  final Widget title;
  final Widget body;
  final Widget floatAction;
  final List<Widget> actions;

  const Bc4fScaffold(
      {Key key, this.title, this.body, this.actions, this.floatAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Bc4fDrawer(),
      appBar: Bc4fAppBar(
        title: title,
        actions: actions,
      ),
      body: DoubleBackPop(
        child: body,
      ),
      floatingActionButton: floatAction,
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
