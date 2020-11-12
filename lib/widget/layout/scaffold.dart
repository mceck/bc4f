import 'package:bc4f/model/group.dart';
import 'package:bc4f/model/tag.dart';
import 'package:bc4f/widget/components/tags.dart';
import 'package:bc4f/widget/layout/bottom-navbar.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/layout/drawer.dart';

class Bc4fScaffold extends StatefulWidget {
  final Widget body;
  final Widget floatAction;
  final Widget bottomNavBar;
  final PreferredSizeWidget appBar;
  final void Function() actionNew;
  final void Function() actionEdit;
  final void Function(String search) onSearch;
  final void Function(List<String> filter) onTagFilterChange;
  final void Function(List<String> filter) onGroupFilterChange;
  final String title;
  final String subtitle;
  final Widget icon;
  final List<String> tagFilters;

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
    this.onTagFilterChange,
    this.onGroupFilterChange,
    this.tagFilters,
  }) : super(key: key);

  @override
  _Bc4fScaffoldState createState() => _Bc4fScaffoldState();
}

class _Bc4fScaffoldState extends State<Bc4fScaffold> {
  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: MediaQuery.of(context).size.height * 0.3,
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) widget.icon,
              Text(widget.title),
            ],
          ),
          if (widget.subtitle != null)
            Text(
              widget.subtitle,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Colors.white),
            ),
          if (widget.onGroupFilterChange != null) Text('Group filters'),
          if (widget.onTagFilterChange != null)
            EditableTagList(
              onTagFilterChange: widget.onTagFilterChange,
              tags: widget.tagFilters,
            ),
          if (widget.onSearch != null)
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
              ),
              onChanged: widget.onSearch,
            ),
        ],
      ),
      actions: [
        if (widget.actionEdit != null)
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: widget.actionEdit,
          ),
        if (widget.actionNew != null)
          IconButton(
            icon: Icon(Icons.add),
            onPressed: widget.actionNew,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Bc4fDrawer(),
      appBar: widget.appBar ?? buildAppBar(context),
      body: DoubleBackPop(
        child: SafeArea(child: widget.body),
      ),
      floatingActionButton: widget.floatAction,
      bottomNavigationBar: widget.bottomNavBar ?? Bc4fBottomNavbar(),
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
