import 'package:bc4f/provider/group-provider.dart';
import 'package:bc4f/screens/groups/form/group-form.dart';
import 'package:bc4f/utils/images.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/group-view-body.dart';

class GroupView extends StatelessWidget {
  static const route = '/groups/view';

  const GroupView({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = Provider.of<GroupProvider>(context).groups;
    return Bc4fScaffold(
      title: const Text('Groups'),
      subtitle: const Text('Create groups where store your barcodes'),
      backgroundImage: Images.bc2,
      body: GroupViewBody(groups: groups),
      floatAction: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(GroupForm.route),
        child: const Icon(Icons.add),
      ),
    );
  }
}
