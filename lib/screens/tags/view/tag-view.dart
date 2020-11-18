import 'package:bc4f/provider/tag-provider.dart';
import 'package:bc4f/screens/tags/form/tag-form.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/images.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/tag.dart';
import 'package:provider/provider.dart';

import 'components/tag-view-body.dart';

class TagView extends StatefulWidget {
  static const route = '/tags/view';

  final List<Tag> tags;

  const TagView({Key key, this.tags}) : super(key: key);

  @override
  _TagViewState createState() => _TagViewState();
}

class _TagViewState extends State<TagView> {
  @override
  Widget build(BuildContext context) {
    final tags = Provider.of<TagProvider>(context).tags;
    return Bc4fScaffold(
      title: Text('Tags'),
      subtitle: Text('Create labels to tag your barcodes'),
      backgroundImage: Images.tags,
      body: TagViewBody(tags: tags),
      floatAction: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(TagForm.route),
        child: Icon(Icons.add),
      ),
    );
  }
}
