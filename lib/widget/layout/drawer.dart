import 'package:bc4f/screens/groups/view/group-view.dart';
import 'package:bc4f/screens/homepage/homepage.dart';
import 'package:bc4f/screens/search/search.dart';
import 'package:bc4f/screens/tags/view/tag-view.dart';
import 'package:bc4f/service/firebase-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:flutter/material.dart';

class Bc4fDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: Column(
            children: [
              InkWell(
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    HomepageScreen.route, (route) => false),
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil(GroupView.route, (route) => false),
                child: ListTile(
                  leading: Icon(Icons.group_work),
                  title: Text('Groups'),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil(TagView.route, (route) => false),
                child: ListTile(
                  leading: Icon(Icons.label),
                  title: Text('Tags'),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    SearchScreen.route, (route) => false),
                child: ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Search'),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: FirebaseService.logout,
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
