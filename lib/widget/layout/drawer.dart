import 'package:bc4f/screens/groups/view/group-view.dart';
import 'package:bc4f/screens/homepage/homepage.dart';
import 'package:bc4f/screens/search/search.dart';
import 'package:bc4f/screens/tags/view/tag-view.dart';
import 'package:bc4f/service/firebase-service.dart';
import 'package:bc4f/utils/app-status.dart';
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
              if (!AppStatus().offlineMode)
                InkWell(
                  child: ListTile(
                    leading: Icon(Icons.save),
                    title: Text('Save for offline'),
                  ),
                  onTap: () async {
                    await AppStatus().saveProvidersToLocal();
                    Navigator.of(context).pop();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Saving complete',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.green),
                      ),
                    ));
                  },
                ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  if (!AppStatus().offlineMode)
                    await showModalBottomSheet(
                        isDismissible: false,
                        context: context,
                        builder: (ctx) {
                          return Padding(
                            padding: const EdgeInsets.all(kDefaultPadding),
                            child: Row(
                              children: [
                                Expanded(
                                  child: FittedBox(
                                    child: Text(
                                        'Do you want to save data for offline access? '),
                                  ),
                                ),
                                RaisedButton(
                                  color: Colors.green,
                                  child: Text('Yes'),
                                  onPressed: () async {
                                    await AppStatus().saveProvidersToLocal();
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                                RaisedButton(
                                  color: Colors.grey,
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  FirebaseService.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
