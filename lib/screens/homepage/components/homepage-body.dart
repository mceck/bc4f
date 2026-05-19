import 'package:bc4f/provider/group-provider.dart';
import 'package:bc4f/provider/recent-barcode-provider.dart';
import 'package:bc4f/provider/tag-provider.dart';
import 'package:bc4f/screens/barcodes/barcode-card.dart';
import 'package:bc4f/screens/barcodes/form/barcode-form.dart';
import 'package:bc4f/screens/groups/form/group-form.dart';
import 'package:bc4f/screens/groups/group-card.dart';
import 'package:bc4f/screens/tags/form/tag-form.dart';
import 'package:bc4f/screens/tags/view/components/tag-view-body.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomepageBody extends StatelessWidget {
  const HomepageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final subtitle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.bold);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: kDefaultPadding / 2),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Add new barcode'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () =>
                Navigator.of(context).pushNamed(BarcodeForm.route),
          ),
        ),
        Row(
          children: [
            Text('Groups', style: subtitle),
            TextButton.icon(
              icon: Icon(Icons.add, color: Colors.green[700]),
              label: Text(
                'Add new group',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onPressed: () =>
                  Navigator.of(context).pushNamed(GroupForm.route),
            ),
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
                      height: 180,
                      child: GroupCard(group: group),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: kDefaultPadding * 2),
        Text('Recently used', style: subtitle),
        Consumer<RecentBarcodeProvider>(
          builder: (ctx, recentProvider, _) =>
              recentProvider.barcodes.isNotEmpty
                  ? SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recentProvider.barcodes.length,
                        itemBuilder: (ctx, index) => SizedBox(
                          width: 200,
                          child: BarcodeCard(
                            barcodes: recentProvider.barcodes,
                            index: index,
                            showName: false,
                          ),
                        ),
                      ),
                    )
                  : const Text('No recent barcodes to show'),
        ),
        const SizedBox(height: kDefaultPadding * 2),
        Row(
          children: [
            Text('Tags', style: subtitle),
            TextButton.icon(
              icon: Icon(Icons.add, color: Colors.green[700]),
              label: Text(
                'Add new tag',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onPressed: () => Navigator.of(context).pushNamed(TagForm.route),
            ),
          ],
        ),
        Consumer<TagProvider>(
          builder: (context, tagProvider, _) =>
              TagViewBody(tags: tagProvider.tags, readOnly: true),
        ),
      ],
    );
  }
}
