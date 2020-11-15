import 'package:bc4f/screens/groups/form/components/group-form-body.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/group.dart';

class GroupForm extends StatelessWidget {
  static const route = '/groups/form';

  final BarcodeGroup group;

  const GroupForm({Key key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isNew = group?.uid == null;

    return Bc4fScaffold(
      title: Text(isNew ? 'Add group' : 'Edit group'),
      subtitle: isNew
          ? Text('Add a new group')
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: kDefaultPadding / 2),
                  child: Text(
                    group.name,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (group.description != null && group.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: kDefaultPadding / 2),
                    child: Text(
                      group.description,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
      body: GroupFormBody(group: group),
    );
  }
}
