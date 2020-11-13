import 'package:bc4f/screens/groups/form/components/group-form-body.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/group.dart';

class GroupForm extends StatelessWidget {
  static const route = '/groups/form';

  final BarcodeGroup group;

  const GroupForm({Key key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bc4fScaffold(
      title: 'Group form',
      body: GroupFormBody(group: group),
    );
  }
}
