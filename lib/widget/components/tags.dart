import 'package:bc4f/provider/tag-provider.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/model/tag.dart';
import 'package:provider/provider.dart';

class TagList extends StatelessWidget {
  final Barcode barcode;

  const TagList({Key key, this.barcode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (barcode.tags == null) return Container();
    final tagList = Provider.of<TagProvider>(context).tags;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: barcode.tags.map(
          (tagId) {
            final tag =
                tagList.firstWhere((t) => t.uid == tagId, orElse: () => null);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child:
                  tag == null ? CircularProgressIndicator() : TagElem(tag: tag),
            );
          },
        ).toList(),
      ),
    );
  }
}

class TagElem extends StatelessWidget {
  const TagElem({
    Key key,
    @required this.tag,
  }) : super(key: key);

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tag?.color,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Text(
        tag?.name,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
