import 'dart:math';

import 'package:bc4f/model/group.dart';
import 'package:bc4f/screens/groups/detail/group-detail.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  static const double MAX_WIDTH = 330;
  static const double MAX_HEIGHT = 250;
  final BarcodeGroup group;
  const GroupCard({
    Key key,
    this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = min(size.width * 0.4, MAX_WIDTH);
    final height = min(size.width * 0.3, MAX_HEIGHT);
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        GroupDetail.route,
        arguments: {'group': group},
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Card(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Image.network(
                  group.imgUrl ?? '',
                  errorBuilder: (ctx, err, stack) {
                    return Container(
                      color: Theme.of(context).accentColor,
                      child: Center(
                        child: Text(group.name?.toUpperCase() ?? 'null'),
                      ),
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
        ),
      ),
    );
  }
}
