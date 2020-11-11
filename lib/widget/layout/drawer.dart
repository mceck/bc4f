import 'package:bc4f/service/firebase-service.dart';
import 'package:flutter/material.dart';

class Bc4fDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
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
    );
  }
}
