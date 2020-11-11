import 'package:flutter/material.dart';
import 'package:bc4f/model/group.dart';

class GroupForm extends StatefulWidget {
  static const route = '/groups/form';

  final BarcodeGroup group;

  const GroupForm({Key key, this.group}) : super(key: key);

  @override
  _GroupFormState createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  @override
  Widget build(BuildContext context) {
    return Text('Not implemented');
  }
}
