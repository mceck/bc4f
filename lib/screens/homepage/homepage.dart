import 'package:bc4f/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/screens/homepage/components/group-list.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/layout/bottom-navbar.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomepageScreen extends StatefulWidget {
  static const route = '/';

  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final Stream groupStream = BarcodeService.getAll();
  @override
  Widget build(BuildContext context) {
    final subtitle = Theme.of(context).textTheme.subtitle1;
    return Bc4fScaffold(
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Groups',
              style: subtitle,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: groupStream,
              builder: (ctx, snap) {
                if (snap.hasError)
                  return Center(child: SelectableText(snap.error.toString()));
                if (snap.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                log.info('got ${snap.data.size} results');
                return GroupList(groups: snap.data.docs);
              },
            ),
            Text('Recently used', style: subtitle),
            Text('...'),
            // TODO
            // StreamBuilder<QuerySnapshot>(
            //   stream: recentBcStream,
            //   builder: (ctx, snap) {
            //     if (snap.hasError)
            //       return Center(child: SelectableText(snap.error.toString()));
            //     if (snap.connectionState == ConnectionState.waiting)
            //       return Center(child: CircularProgressIndicator());
            //     log.info('got ${snap.data.size} results');
            //     return BarcodeList(barcodes: snap.data.docs);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
