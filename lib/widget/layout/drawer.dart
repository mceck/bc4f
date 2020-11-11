import 'package:bc4f/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Bc4fDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            InkWell(
              onTap: auth.logout,
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
