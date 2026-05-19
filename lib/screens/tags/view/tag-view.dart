import 'package:bc4f/provider/tag-provider.dart';
import 'package:bc4f/screens/tags/form/tag-form.dart';
import 'package:bc4f/utils/images.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/tag-view-body.dart';

class TagView extends StatelessWidget {
  static const route = '/tags/view';

  const TagView({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = Provider.of<TagProvider>(context).tags;
    return Bc4fScaffold(
      title: const Text('Tags'),
      subtitle: const Text('Create labels to tag your barcodes'),
      backgroundImage: Images.tags,
      body: TagViewBody(tags: tags),
      floatAction: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(TagForm.route),
        child: const Icon(Icons.add),
      ),
    );
  }
}
