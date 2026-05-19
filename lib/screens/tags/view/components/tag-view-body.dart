import 'package:bc4f/model/tag.dart';
import 'package:bc4f/screens/search/search.dart';
import 'package:bc4f/screens/tags/form/tag-form.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reorderables/reorderables.dart';

class TagViewBody extends StatelessWidget {
  final bool readOnly;

  const TagViewBody({
    super.key,
    required this.tags,
    this.readOnly = false,
  });

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    return ReorderableWrap(
      runSpacing: kDefaultPadding / 2,
      spacing: kDefaultPadding / 2,
      children: tags
          .map(
            (tag) => SizedBox(
              width: MediaQuery.of(context).size.width >= 410
                  ? 185
                  : (MediaQuery.of(context).size.width - kDefaultPadding * 3) /
                      2,
              child: GestureDetector(
                onTap: () {
                  if (tag.uid == null) return;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    SearchScreen.route,
                    (route) => false,
                    arguments: {
                      'tagFilters': [tag.uid!],
                    },
                  );
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Slidable(
                    startActionPane: readOnly
                        ? null
                        : ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.25,
                            children: [
                              SlidableAction(
                                onPressed: (_) =>
                                    BarcodeService.deleteTag(tag.uid!),
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                    endActionPane: readOnly
                        ? null
                        : ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.25,
                            children: [
                              SlidableAction(
                                onPressed: (_) => Navigator.of(context)
                                    .pushNamed(TagForm.route,
                                        arguments: {'tag': tag}),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                            ],
                          ),
                    child: Center(
                      child: ListTile(
                        leading: Icon(Icons.label, color: tag.color),
                        title: Text(tag.name ?? 'null'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
      onReorder: (from, to) {
        log.info('from $from to $to');
        BarcodeService.reorderTag(tags, from, to);
      },
    );
  }
}
