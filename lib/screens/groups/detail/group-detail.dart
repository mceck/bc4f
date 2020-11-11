import 'package:flutter/material.dart';
import 'package:bc4f/model/barcode.dart';

class GroupDetail extends StatefulWidget {
  static const route = '/groups/detail';

  final List<Barcode> barcodes;
  final int startIdx;

  const GroupDetail({Key key, this.barcodes, this.startIdx}) : super(key: key);

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  @override
  Widget build(BuildContext context) {
    return Text('Not implemented');
  }
}
