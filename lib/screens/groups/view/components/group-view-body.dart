import 'package:bc4f/model/group.dart';
import 'package:bc4f/screens/groups/group-card.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:flutter/material.dart';

class GroupViewBody extends StatelessWidget {
  const GroupViewBody({
    Key key,
    @required this.groups,
  }) : super(key: key);

  final List<BarcodeGroup> groups;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        childAspectRatio: kDefaultGridCellAspectRatio,
        maxCrossAxisExtent: kDefaultGridMaxExtent,
        crossAxisSpacing: kDefaultPadding,
        mainAxisSpacing: kDefaultPadding,
      ),
      itemCount: groups.length,
      itemBuilder: (ctx, index) {
        final group = groups[index];
        return GroupCard(
          group: group,
          withSlideActions: true,
        );
      },
    );
  }
}
