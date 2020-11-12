import 'package:flutter/material.dart';
import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/model/tag.dart';

class TagList extends StatelessWidget {
  final Barcode barcode;

  const TagList({Key key, this.barcode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (barcode.tags == null) return Container();
    final tagList = []; // TODO Provider.of<Tags>(context);
    // if (tagList.loading)
    //   return Padding(
    //     padding: const EdgeInsets.only(left: 10, right: 60),
    //     child: LinearProgressIndicator(),
    //   );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: barcode.tags.map(
          (tagId) {
            final tag = tagList.firstWhere((t) => t.id == tagId);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TagElem(tag: tag),
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
