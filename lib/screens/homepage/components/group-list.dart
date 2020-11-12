import 'package:bc4f/model/group.dart';
import 'package:bc4f/screens/homepage/components/group-card.dart';
import 'package:flutter/material.dart';

class GroupList extends StatelessWidget {
  final List<BarcodeGroup> groups;
  const GroupList({
    Key key,
    this.groups,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: groups.map((group) => GroupCard(group: group)).toList(),
      ),
    );
  }
}
