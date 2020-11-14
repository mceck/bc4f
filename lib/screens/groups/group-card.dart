import 'package:bc4f/model/group.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'detail/group-detail.dart';
import 'form/group-form.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    Key key,
    @required this.group,
    this.withSlideActions = false,
  }) : super(key: key);

  final BarcodeGroup group;
  final bool withSlideActions;

  @override
  Widget build(BuildContext context) {
    final fallbackImg = Container(
      color: Colors.blue,
      child: Center(child: Text(group.name)),
    );
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        GroupDetail.route,
        arguments: {'group': group},
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Image.network(
                  group.imgUrl ?? '',
                  loadingBuilder: (ctx, child, progress) =>
                      progress != null ? fallbackImg : child,
                  errorBuilder: (ctx, error, stackTrace) => fallbackImg,
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
          actions: withSlideActions
              ? [
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () => BarcodeService.deleteGroup(group.uid),
                  ),
                ]
              : null,
          secondaryActions: withSlideActions
              ? [
                  IconSlideAction(
                    caption: 'Edit',
                    color: Colors.blue,
                    icon: Icons.edit,
                    onTap: () => Navigator.of(context).pushNamed(
                        GroupForm.route,
                        arguments: {'group': group}),
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
