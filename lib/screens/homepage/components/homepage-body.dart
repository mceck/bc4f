import 'package:bc4f/provider/group-provider.dart';
import 'package:bc4f/provider/tag-provider.dart';
import 'package:bc4f/screens/groups/group-card.dart';
import 'package:bc4f/screens/tags/view/components/tag-view-body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomepageBody extends StatelessWidget {
  const HomepageBody();

  @override
  Widget build(BuildContext context) {
    final subtitle = Theme.of(context)
        .textTheme
        .subtitle1
        .copyWith(fontWeight: FontWeight.bold);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Consumer<TagProvider>(
            builder: (context, tagProvider, _) =>
                TagViewBody(tags: tagProvider.tags, readOnly: true))
      ],
    );
  }
}
