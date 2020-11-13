import 'package:bc4f/model/group.dart';
import 'package:bc4f/screens/groups/detail/group-detail.dart';
import 'package:bc4f/screens/groups/form/group-form.dart';
import 'package:bc4f/screens/groups/group-card.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GroupViewBody extends StatelessWidget {
  const GroupViewBody({
    Key key,
    @required this.groups,
  }) : super(key: key);

  final List<BarcodeGroup> groups;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 4 / 3,
          maxCrossAxisExtent: 330,
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
      ),
    );
  }
}
