import 'package:bc4f/model/group.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/barcode.dart';

class GroupDetail extends StatefulWidget {
  static const route = '/groups/detail';

  final BarcodeGroup group;

  const GroupDetail({Key key, this.group}) : super(key: key);

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  @override
  Widget build(BuildContext context) {
    return Bc4fScaffold(
      body: Center(
        child: Text('Group detail'),
      ),
    );
  }
}
