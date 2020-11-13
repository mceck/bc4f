import 'package:bc4f/provider/group-provider.dart';
import 'package:bc4f/screens/groups/detail/group-detail.dart';
import 'package:bc4f/screens/groups/form/group-form.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/widget/components/firebase-stream-builder.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/group.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

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
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 4 / 3,
          maxCrossAxisExtent: 330,
          crossAxisSpacing: kDefaultPadding,
          mainAxisSpacing: kDefaultPadding,
        ),
        itemCount: groups.length,
        itemBuilder: (ctx, index) {
          final group = groups[index];
          return GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              GroupDetail.route,
              arguments: {'group': group},
            ),
            child: Card(
              child: Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Image.network(
                        group.imgUrl ?? '',
                        errorBuilder: (ctx, err, stack) {
                          return Container(
                            color: Colors.blue,
                            child: Center(child: Text(group.name)),
                          );
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ListTile(
                        title: Text(group.name ?? 'null'),
                        subtitle: Text(group.description ?? 'null'),
                      ),
                    )
                  ],
                ),
                actions: <Widget>[
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () => BarcodeService.deleteGroup(group.uid),
                  ),
                ],
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Edit',
                    color: Colors.blue,
                    icon: Icons.edit,
                    onTap: () => Navigator.of(context).pushNamed(
                        GroupForm.route,
                        arguments: {'group': group}),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatAction: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(GroupForm.route),
        child: Icon(Icons.add),
      ),
    );
  }
}
