import 'package:flutter/material.dart';
import 'package:bc4f/model/group.dart';

class GroupView extends StatefulWidget {
  static const route = '/groups/view';

  final List<BarcodeGroup> groups;

  const GroupView({Key key, this.groups}) : super(key: key);

  @override
  _GroupViewState createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  @override
  Widget build(BuildContext context) {
    return Text('Not implemented');
  }
}
