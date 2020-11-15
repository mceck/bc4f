import 'package:bc4f/provider/group-provider.dart';
import 'package:bc4f/provider/tag-provider.dart';
import 'package:bc4f/screens/barcodes/form/barcode-form.dart';
import 'package:bc4f/screens/groups/form/group-form.dart';
import 'package:bc4f/screens/groups/group-card.dart';
import 'package:bc4f/screens/tags/form/tag-form.dart';
import 'package:bc4f/screens/tags/view/components/tag-view-body.dart';
import 'package:bc4f/utils/constants.dart';
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
        Padding(
          padding: const EdgeInsets.only(bottom: kDefaultPadding / 2),
          child: RaisedButton.icon(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: Text('Add new barcode'),
            color: Colors.green,
            onPressed: () => Navigator.of(context).pushNamed(BarcodeForm.route),
          ),
        ),
        Row(
          children: [
            Text('Groups', style: subtitle),
            FlatButton.icon(
              icon: Icon(
                Icons.add,
                color: Colors.green[700],
              ),
              label: Text(
                'Add new group',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(GroupForm.route);
              },
            )
          ],
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
        SizedBox(height: kDefaultPadding * 2),
        Text('Recently used', style: subtitle),
        // TODO
        // Render recently used barcodes
        Text('... coming soon ...'),
        SizedBox(height: kDefaultPadding * 2),
        Row(
          children: [
            Text('Tags', style: subtitle),
            FlatButton.icon(
              icon: Icon(
                Icons.add,
                color: Colors.green[700],
              ),
              label: Text(
                'Add new tag',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(TagForm.route);
              },
            )
          ],
        ),
        Consumer<TagProvider>(
            builder: (context, tagProvider, _) =>
                TagViewBody(tags: tagProvider.tags, readOnly: true))
      ],
    );
  }
}
