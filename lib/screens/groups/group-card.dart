import 'package:bc4f/model/group.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'detail/group-detail.dart';
import 'form/group-form.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.group,
    this.withSlideActions = false,
  });

  final BarcodeGroup group;
  final bool withSlideActions;

  @override
  Widget build(BuildContext context) {
    final h5 = Theme.of(context)
        .textTheme
        .headlineSmall
        ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold);
    final fallbackImg = Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Text(group.name ?? '', style: h5),
      ),
    );
    final cardContent = Column(
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
        ),
      ],
    );

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        GroupDetail.route,
        arguments: {'group': group},
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: withSlideActions
            ? Slidable(
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (_) =>
                          BarcodeService.deleteGroup(group.uid!),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (_) => Navigator.of(context).pushNamed(
                          GroupForm.route,
                          arguments: {'group': group}),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                child: cardContent,
              )
            : cardContent,
      ),
    );
  }
}
