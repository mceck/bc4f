import 'package:bc4f/provider/tag-provider.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/widget/components/select-list.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/tag.dart';
import 'package:provider/provider.dart';

class EditableTagList extends StatefulWidget {
  final void Function(List<String> tags) onTagFilterChange;
  final List<String>? tags;
  final TextStyle? textStyle;

  const EditableTagList({
    super.key,
    required this.onTagFilterChange,
    this.tags,
    this.textStyle,
  });

  @override
  State<EditableTagList> createState() => _EditableTagListState();
}

class _EditableTagListState extends State<EditableTagList> {
  late List<String?> tags;

  List<String> get notNullTags =>
      tags.whereType<String>().where((t) => t.isNotEmpty).toList();

  @override
  void initState() {
    tags = List<String?>.from(widget.tags ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allTags = Provider.of<TagProvider>(context).tags;
    if (allTags.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Text('Tags: '),
            IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white54,
                ),
                child: Icon(Icons.add, color: Colors.green[600]),
              ),
              onPressed: () {
                setState(() {
                  tags.add(null);
                });
              },
            ),
            ...tags.map(
              (tagId) => Row(
                children: [
                  SelectList(
                    key: ValueKey(tagId),
                    hint: Text('tag', style: widget.textStyle),
                    list: allTags.map((t) => t.uid ?? '').toList(),
                    onChanged: (val) {
                      final idx = tags.indexOf(tagId);
                      if (idx >= 0) {
                        setState(() {
                          tags[idx] = val;
                          widget.onTagFilterChange(notNullTags);
                        });
                      }
                    },
                    value: tagId,
                    display: (id) => TagElem(
                      tag: allTags.firstWhere(
                        (t) => t.uid == id,
                        orElse: () => Tag(),
                      ),
                    ),
                    showUnderline: false,
                    showIcon: false,
                  ),
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white54,
                      ),
                      child: Icon(Icons.cancel_outlined, color: Colors.red[700]),
                    ),
                    onPressed: () {
                      setState(() {
                        tags.remove(tagId);
                        widget.onTagFilterChange(notNullTags);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TagList extends StatelessWidget {
  final List<String>? tags;
  final void Function(Tag)? onTap;

  const TagList({super.key, this.tags, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (tags == null || tags!.isEmpty) return const SizedBox.shrink();
    final tagList = Provider.of<TagProvider>(context).tags;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags!.map((tagId) {
          final tag = tagList.firstWhere(
            (t) => t.uid == tagId,
            orElse: () => Tag(),
          );
          return GestureDetector(
            onTap: () => onTap?.call(tag),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: tag.uid == null
                  ? const CircularProgressIndicator()
                  : TagElem(tag: tag),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TagElem extends StatelessWidget {
  const TagElem({super.key, required this.tag});

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    if (tag.uid == null && tag.name == null) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        color: tag.color,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: 3),
      child: Text(
        tag.name ?? '',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
