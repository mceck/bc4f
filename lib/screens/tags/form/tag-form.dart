import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/tag.dart';

import 'components/tag-form-body.dart';

class TagForm extends StatelessWidget {
  static const route = '/tags/form';

  final Tag tag;

  const TagForm({Key key, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isNew = tag?.uid == null;
    return Bc4fScaffold(
      title: Text(isNew ? 'Add tag' : 'Edit tag'),
      subtitle: isNew
          ? Text('Add a new tag')
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.filled(
                      3,
                      Icon(
                        Icons.label,
                        color: tag.color,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: kDefaultPadding / 2),
                  child: Text(
                    tag.name,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
      body: TagFormBody(tag: tag),
    );
  }
}
