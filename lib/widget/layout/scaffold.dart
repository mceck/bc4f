import 'package:bc4f/widget/layout/appbar.dart';
import 'package:bc4f/widget/layout/bottom-navbar.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/layout/drawer.dart';

class Bc4fScaffold extends StatelessWidget {
  final Widget? body;
  final Widget? floatAction;
  final Widget? bottomNavBar;
  final void Function()? actionNew;
  final void Function()? actionEdit;
  final void Function(String search)? onSearch;
  final void Function(List<String> filter)? onTagFilterChange;
  final void Function(List<String> filter)? onGroupFilterChange;
  final Widget? title;
  final Widget? subtitle;
  final List<String>? tagFilters;
  final List<String>? groupFilters;
  final bool withExtendedAppbar;
  final String? backgroundImage;

  const Bc4fScaffold({
    super.key,
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
  });

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.redAccent,
      title: title ?? const Text('BC4F'),
      elevation: 0,
      actions: [
        if (actionEdit != null)
          IconButton(icon: const Icon(Icons.edit), onPressed: actionEdit),
        if (actionNew != null)
          IconButton(icon: const Icon(Icons.add), onPressed: actionNew),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Bc4fDrawer(),
      appBar: _buildAppBar(context),
      body: _DoubleBackPop(
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
            : body ?? const SizedBox.shrink(),
      ),
      floatingActionButton: floatAction,
      bottomNavigationBar: bottomNavBar ?? const Bc4fBottomNavbar(),
    );
  }
}

class _DoubleBackPop extends StatefulWidget {
  final Widget child;

  const _DoubleBackPop({required this.child});

  @override
  State<_DoubleBackPop> createState() => _DoubleBackPopState();
}

class _DoubleBackPopState extends State<_DoubleBackPop> {
  DateTime? _currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _onWillPop(context);
      },
      child: widget.child,
    );
  }

  void _onWillPop(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    final now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
      _currentBackPressTime = now;
      log.info('double back requested');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.black87,
          content: Text(
            'Premi 2 volte per uscire',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // chiudi l'app
      Navigator.of(context).pop();
    }
  }
}
