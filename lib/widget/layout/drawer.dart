import 'package:bc4f/screens/groups/view/group-view.dart';
import 'package:bc4f/screens/homepage/homepage.dart';
import 'package:bc4f/screens/search/search.dart';
import 'package:bc4f/screens/tags/view/tag-view.dart';
import 'package:bc4f/service/firebase-service.dart';
import 'package:bc4f/utils/app-status.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:flutter/material.dart';

class Bc4fDrawer extends StatelessWidget {
  const Bc4fDrawer({super.key});

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
                child: const ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    GroupView.route, (route) => false),
                child: const ListTile(
                  leading: Icon(Icons.group_work),
                  title: Text('Groups'),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    TagView.route, (route) => false),
                child: const ListTile(
                  leading: Icon(Icons.label),
                  title: Text('Tags'),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    SearchScreen.route, (route) => false),
                child: const ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Search'),
                ),
              ),
              const Spacer(),
              if (!AppStatus().offlineMode)
                InkWell(
                  onTap: () async {
                    await AppStatus().saveProvidersToLocal();
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Saving complete',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.green),
                      ),
                    ));
                  },
                  child: const ListTile(
                    leading: Icon(Icons.save),
                    title: Text('Save for offline'),
                  ),
                ),
              InkWell(
                onTap: () async {
                  Navigator.of(context).pop();
                  if (!AppStatus().offlineMode) {
                    await showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (ctx) => Padding(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: Row(
                          children: [
                            const Expanded(
                              child: FittedBox(
                                child: Text(
                                    'Do you want to save data for offline access?'),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () async {
                                await AppStatus().saveProvidersToLocal();
                                if (!ctx.mounted) return;
                                Navigator.of(ctx).pop();
                              },
                              child: const Text('Yes'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey),
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('No'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  FirebaseService.logout();
                },
                child: const ListTile(
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
