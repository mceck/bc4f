import 'package:flutter/material.dart';

class Bc4fAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double APPBAR_HEIGHT = 60;

  final Widget title;

  final List<Widget> actions;

  const Bc4fAppBar({Key key, this.title, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(APPBAR_HEIGHT);
}
