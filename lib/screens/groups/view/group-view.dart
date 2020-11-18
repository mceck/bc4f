import 'package:bc4f/provider/group-provider.dart';
import 'package:bc4f/screens/groups/form/group-form.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/images.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/group.dart';
import 'package:provider/provider.dart';

import 'components/group-view-body.dart';

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
    final groups = Provider.of<GroupProvider>(context).groups;
    return Bc4fScaffold(
      title: Text('Groups'),
      subtitle: Text('Create groups where store your barcodes'),
      backgroundImage: Images.bc2,
      body: GroupViewBody(groups: groups),
      floatAction: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(GroupForm.route),
        child: Icon(Icons.add),
      ),
    );
  }
}
