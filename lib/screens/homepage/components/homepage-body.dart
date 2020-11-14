import 'package:bc4f/provider/group-provider.dart';
import 'package:bc4f/provider/tag-provider.dart';
import 'package:bc4f/screens/groups/group-card.dart';
import 'package:bc4f/screens/search/search.dart';
import 'package:bc4f/widget/components/tags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomepageBody extends StatelessWidget {
  const HomepageBody();

  @override
  Widget build(BuildContext context) {
    final subtitle = Theme.of(context).textTheme.subtitle1;
    return Column(
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
        // TODO
        // Render recently used barcodes
        Text('...'),
        Text('Tags', style: subtitle),
        Consumer<TagProvider>(builder: (context, tagProvider, _) {
          return TagList(
            tags: tagProvider.tags.map((t) => t.uid).toList(),
            onTap: (tag) => Navigator.of(context).pushNamedAndRemoveUntil(
              SearchScreen.route,
              (route) => false,
              arguments: {
                'tagFilters': [tag.uid]
              },
            ),
          );
        })
      ],
    );
  }
}
