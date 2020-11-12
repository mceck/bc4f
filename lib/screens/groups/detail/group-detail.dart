import 'dart:async';

import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/model/group.dart';
import 'package:bc4f/model/tag.dart';
import 'package:bc4f/screens/groups/detail/components/group-grid.dart';
import 'package:bc4f/screens/groups/form/group-form.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/components/firebase-stream-builder.dart';
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
  List<Tag> tagFilters = [];

  List<Barcode> filterList(List<Barcode> barcodes) {
    return barcodes
        .where((bar) =>
            tagFilters.every((filter) => bar.tags.contains(filter.uid)))
        .toList();
  }

  Stream barcodeStream;

  @override
  void initState() {
    barcodeStream = BarcodeService.streamBarcodesByGroup(widget.group.uid);
    super.initState();
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
        child: FirebaseQueryBuilder<Barcode>(
          stream: barcodeStream,
          builder: (ctx, list) => Column(
            children: [
              Text('Barcodes:'),
              Expanded(
                child: GroupGrid(barcodes: filterList(list)),
              ),
            ],
          ),
          factoryMethod: (json) => Barcode.fromJson(json),
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
