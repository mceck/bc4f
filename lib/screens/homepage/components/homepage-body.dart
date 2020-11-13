import 'package:bc4f/provider/group-provider.dart';
import 'package:bc4f/screens/groups/group-card.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomepageBody extends StatelessWidget {
  const HomepageBody();

  @override
  Widget build(BuildContext context) {
    final subtitle = Theme.of(context).textTheme.subtitle1;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: ListView(
        children: [
          Text(
            'Groups',
            style: subtitle,
          ),
          Consumer<GroupProvider>(
            builder: (ctx, groupProvider, _) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: groupProvider.groups
                    .map(
                      (group) => SizedBox(
                        width: 200,
                        height: 200,
                        child: GroupCard(group: group),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Text('Recently used', style: subtitle),
          Text('...'),
          // TODO
          // Render recently used barcodes

          // TODO
          // Render tag list
        ],
      ),
    );
  }
}
