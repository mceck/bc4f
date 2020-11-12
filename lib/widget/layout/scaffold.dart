import 'package:bc4f/widget/layout/bottom-navbar.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/layout/drawer.dart';

class Bc4fScaffold extends StatelessWidget {
  final Widget body;
  final Widget floatAction;
  final Widget bottomNavBar;
  final PreferredSizeWidget appBar;
  final void Function() actionNew;
  final void Function() actionEdit;
  final void Function(String search) onSearch;
  final String title;
  final String subtitle;
  final Widget icon;

  const Bc4fScaffold({
    Key key,
    this.body,
    this.floatAction,
    this.bottomNavBar,
    this.appBar,
    this.actionNew,
    this.actionEdit,
    this.onSearch,
    this.title = 'BC4F',
    this.subtitle = 'Barcodes everyware',
    this.icon,
  }) : super(key: key);

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: MediaQuery.of(context).size.height * 0.3,
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon,
              Text(title),
            ],
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Colors.white),
            ),
          if (onSearch != null)
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
              ),
              onChanged: onSearch,
            )
        ],
      ),
      actions: [
        if (actionEdit != null)
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: actionEdit,
          ),
        if (actionNew != null)
          IconButton(
            icon: Icon(Icons.add),
            onPressed: actionNew,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Bc4fDrawer(),
      appBar: appBar ?? buildAppBar(context),
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
