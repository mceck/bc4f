import 'package:flutter/material.dart';
import 'package:bc4f/model/tag.dart';

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
    return Text('Not implemented');
  }
}
