import 'package:flutter/material.dart';
import 'package:bc4f/model/tag.dart';

class TagForm extends StatefulWidget {
  static const route = '/tags/form';

  final Tag tag;

  const TagForm({Key key, this.tag}) : super(key: key);

  @override
  _TagFormState createState() => _TagFormState();
}

class _TagFormState extends State<TagForm> {
  @override
  Widget build(BuildContext context) {
    return Text('Not implemented');
  }
}
