import 'package:bc4f/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/screens/homepage/components/homepage-body.dart';
import 'package:bc4f/widget/layout/scaffold.dart';

class HomepageScreen extends StatefulWidget {
  static const route = '/';

  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  @override
  Widget build(BuildContext context) {
    return Bc4fScaffold(
      backgroundImage: Images.bc3,
      subtitle: Center(
        child: Text('Barcodes everywhere'),
      ),
      body: HomepageBody(),
    );
  }
}
