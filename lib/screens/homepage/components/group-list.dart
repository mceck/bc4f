import 'package:bc4f/model/group.dart';
import 'package:bc4f/screens/homepage/components/group-card.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupList extends StatelessWidget {
  final List<QueryDocumentSnapshot> groups;
  const GroupList({
    Key key,
    this.groups,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: groups.map((g) {
          final json = g.data();
          final group = BarcodeGroup.fromJson(json);
          log.info('json $group');
          return GroupCard(group: group);
        }).toList(),
      ),
    );
  }
}
