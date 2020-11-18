import 'package:bc4f/widget/layout/appbar.dart';
import 'package:bc4f/widget/layout/bottom-navbar.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/layout/drawer.dart';

class Bc4fScaffold extends StatelessWidget {
  final Widget body;
  final Widget floatAction;
  final Widget bottomNavBar;
  final void Function() actionNew;
  final void Function() actionEdit;
  final void Function(String search) onSearch;
  final void Function(List<String> filter) onTagFilterChange;
  final void Function(List<String> filter) onGroupFilterChange;
  final Widget title;
  final Widget subtitle;
  final List<String> tagFilters;
  final List<String> groupFilters;
  final bool withExtendedAppbar;
  final String backgroundImage;

  const Bc4fScaffold({
    Key key,
    this.body,
    this.floatAction,
    this.bottomNavBar,
    this.actionNew,
    this.actionEdit,
    this.onSearch,
    this.title,
    this.subtitle,
    this.onTagFilterChange,
    this.onGroupFilterChange,
    this.tagFilters,
    this.withExtendedAppbar = true,
    this.groupFilters,
    this.backgroundImage,
  }) : super(key: key);

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: title ?? Text('BC4F'),
      elevation: 0,
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
      appBar: buildAppBar(context),
      body: DoubleBackPop(
        child: withExtendedAppbar
            ? WrapWithExpandedAppbar(
                child: body,
                subtitle: subtitle,
                onSearch: onSearch,
                onTagFilterChange: onTagFilterChange,
                onGroupFilterChange: onGroupFilterChange,
                tagFilters: tagFilters,
                groupFilters: groupFilters,
                backgroundImage: backgroundImage,
              )
            : body,
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
