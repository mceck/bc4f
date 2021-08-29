import 'package:bc4f/model/group.dart';
import 'package:bc4f/screens/groups/group-card.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class GroupViewBody extends StatelessWidget {
  const GroupViewBody({
    Key key,
    @required this.groups,
  }) : super(key: key);

  final List<BarcodeGroup> groups;

  @override
  Widget build(BuildContext context) {
    return ReorderableWrap(
        runSpacing: kDefaultPadding,
        spacing: kDefaultPadding,
        children: groups
            .map((group) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: AspectRatio(
                    aspectRatio: kDefaultGridCellAspectRatio,
                    child: GroupCard(
                      group: group,
                      withSlideActions: true,
                    ),
                  ),
                ))
            .toList(),
        onReorder: (from, to) {
          log.info('from $from to $to');
          BarcodeService.reorderGroup(groups, from, to);
        });
  }
}
