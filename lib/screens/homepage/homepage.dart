import 'package:bc4f/model/group.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/widget/components/firebase-stream-builder.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/screens/homepage/components/group-list.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/layout/scaffold.dart';

class HomepageScreen extends StatefulWidget {
  static const route = '/';

  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final Stream groupStream = BarcodeService.streamGroups();
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
            FirebaseQueryBuilder<BarcodeGroup>(
              stream: groupStream,
              builder: (ctx, list) => GroupList(groups: list),
              factoryMethod: (json) => BarcodeGroup.fromJson(json),
            ),
            Text('Recently used', style: subtitle),
            Text('...'),
            // TODO
            // FirebaseQueryBuilder<Barcode>(
            //   stream: recentBcStream,
            //   builder: (ctx, list) {
            //     return BarcodeList(barcodes: list);
            //   },
            //   factoryMethod: (json) => Barcode.fromJson(json),
            // ),
          ],
        ),
      ),
    );
  }
}
