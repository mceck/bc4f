import 'package:bc4f/screens/groups/view/group-view.dart';
import 'package:bc4f/screens/homepage/homepage.dart';
import 'package:bc4f/screens/search/search.dart';
import 'package:bc4f/screens/tags/view/tag-view.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:flutter/material.dart';

class Bc4fBottomNavbar extends StatefulWidget {
  const Bc4fBottomNavbar({super.key});

  @override
  State<Bc4fBottomNavbar> createState() => _Bc4fBottomNavbarState();
}

class _Bc4fBottomNavbarState extends State<Bc4fBottomNavbar> {
  static const _routes = [
    {
      'route': HomepageScreen.route,
      'label': 'Homepage',
    },
    {
      'route': GroupView.route,
      'label': 'Groups',
    },
    {
      'route': TagView.route,
      'label': 'Tags',
    },
    {
      'route': SearchScreen.route,
      'label': 'Search',
    },
  ];

  static const _icons = [
    Icon(Icons.home),
    Icon(Icons.group_work),
    Icon(Icons.label),
    Icon(Icons.search),
  ];

  void _navigateTo(int id) {
    final newRoute = _routes[id]['route']!;
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    if (currentRoute != newRoute) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(newRoute, (_) => false);
    }
  }

  int get _currentIndex {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    int endIdx = currentRoute.indexOf('/', 1);
    if (endIdx < 0) endIdx = currentRoute.length;
    final routeName = currentRoute.substring(0, endIdx);
    log.info('route $routeName');
    return _getIndexOf(routeName);
  }

  int _getIndexOf(String route) {
    final id = _routes
        .indexWhere((r) => (r['route'] ?? '').startsWith(route));
    return id >= 0 ? id : 0;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: List.generate(
        _routes.length,
        (i) => BottomNavigationBarItem(
          label: _routes[i]['label']!,
          icon: _icons[i],
        ),
      ),
      onTap: _navigateTo,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.black87,
      currentIndex: _currentIndex,
    );
  }
}
