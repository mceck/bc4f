import 'dart:async';

import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/model/group.dart';
import 'package:bc4f/model/tag.dart';
import 'package:bc4f/screens/groups/detail/components/group-grid.dart';
import 'package:bc4f/screens/groups/form/group-form.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';

class GroupDetail extends StatefulWidget {
  static const route = '/groups/detail';

  final BarcodeGroup group;

  const GroupDetail({Key key, this.group}) : super(key: key);

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  List<Barcode> barcodes = [];
  List<Tag> tagFilters = [];

  List<Barcode> get filteredBarcodes {
    return barcodes
        .where((bar) =>
            tagFilters.every((filter) => bar.tags.contains(filter.uid)))
        .toList();
  }

  List<StreamSubscription> subscriptions = [];

  @override
  void initState() {
    widget.group.barcodes.forEach((bcId) {
      //listen firebase barocde entity each barcodeId in the list
      final subs = BarcodeService.getBarcode(bcId).listen((snap) {
        final barcode = Barcode.fromJson(snap.data());
        final updIdx = barcodes.indexWhere((bc) => bc.uid == barcode.uid);
        // store the result/changes on the buffer
        setState(() {
          if (updIdx < 0) {
            //new one
            barcodes.add(barcode);
          } else {
            //update
            barcodes[updIdx] = barcode;
          }
        });
      });
      subscriptions.add(subs);
    });
    super.initState();
  }

  @override
  void dispose() {
    subscriptions.forEach((subs) => subs.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Bc4fScaffold(
      icon: Icon(Icons.group_work),
      title: widget.group.name,
      subtitle: widget.group.description,
      actionEdit: () {
        log.info('edit group');
        Navigator.of(context).pushNamed(
          GroupForm.route,
          arguments: {'group': widget.group},
        );
      },
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            Text('Barcodes:'),
            Expanded(
              child: GroupGrid(barcodes: filteredBarcodes),
            ),
          ],
        ),
      ),
      floatAction: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          log.info('new barcode for group');
          Navigator.of(context).pushNamed(GroupForm.route);
        },
      ),
    );
  }
}
