import 'package:bc4f/provider/tag-provider.dart';
import 'package:bc4f/widget/components/select-list.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/tag.dart';
import 'package:provider/provider.dart';

class EditableTagList extends StatefulWidget {
  final void Function(List<String> tags) onTagFilterChange;
  final List<String> tags;

  const EditableTagList({Key key, @required this.onTagFilterChange, this.tags})
      : super(key: key);

  @override
  _EditableTagListState createState() => _EditableTagListState();
}

class _EditableTagListState extends State<EditableTagList> {
  List<String> tags;

  List<String> get notNullTags =>
      tags.where((t) => t != null && t.isNotEmpty).toList();

  @override
  void initState() {
    tags = widget.tags?.sublist(0) ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allTags = Provider.of<TagProvider>(context).tags;
    if (tags == null || allTags.length == 0) return Container();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text('tags: '),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.green,
            ),
            onPressed: () {
              setState(() {
                tags.add(null);
              });
            },
          ),
          ...tags.map(
            (tagId) {
              return Row(
                children: [
                  SelectList(
                    key: ValueKey(tagId),
                    list: allTags.map((t) => t.uid).toList(),
                    onChanged: (val) {
                      final idx = tags.indexOf(tagId);
                      if (idx >= 0)
                        setState(() {
                          tags[idx] = val;
                          widget.onTagFilterChange(notNullTags);
                        });
                    },
                    value: tagId,
                    display: (id) => TagElem(
                        tag: allTags.firstWhere((t) => t.uid == id,
                            orElse: () => null)),
                    showUnderline: false,
                    showIcon: false,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          tags.remove(tagId);
                          widget.onTagFilterChange(notNullTags);
                        });
                      }),
                ],
              );
            },
          ).toList(),
        ],
      ),
    );
  }
}

class TagList extends StatelessWidget {
  final List<String> tags;
  final void Function(Tag) onTap;

  const TagList({Key key, this.tags, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tags == null || tags.length == 0) return Container();
    final tagList = Provider.of<TagProvider>(context).tags;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags.map(
          (tagId) {
            final tag =
                tagList.firstWhere((t) => t.uid == tagId, orElse: () => null);
            return GestureDetector(
              onTap: () => onTap(tag),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: tag == null
                    ? CircularProgressIndicator()
                    : TagElem(tag: tag),
              ),
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
    this.tag,
  }) : super(key: key);

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    if (tag == null) return Container();
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
