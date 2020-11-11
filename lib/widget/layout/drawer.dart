import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Bc4fDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            InkWell(
              onTap: FirebaseAuth.instance.signOut,
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
