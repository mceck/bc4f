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
  final readOnly;
  const TagViewBody({
    Key key,
    @required this.tags,
    this.readOnly = false,
  }) : super(key: key);

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return ReorderableWrap(
        runSpacing: kDefaultPadding / 2,
        spacing: kDefaultPadding / 2,
        children: tags
            .map((tag) => SizedBox(
                  width: MediaQuery.of(context).size.width >= 410
                      ? 185
                      : (MediaQuery.of(context).size.width -
                              kDefaultPadding * 3) /
                          2,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      SearchScreen.route,
                      (route) => false,
                      arguments: {
                        'tagFilters': [tag.uid]
                      },
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: Center(
                          child: ListTile(
                            leading: Icon(
                              Icons.label,
                              color: tag.color,
                            ),
                            title: Text(tag.name ?? 'null'),
                          ),
                        ),
                        actions: readOnly
                            ? null
                            : [
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () =>
                                      BarcodeService.deleteTag(tag.uid),
                                ),
                              ],
                        secondaryActions: readOnly
                            ? null
                            : [
                                IconSlideAction(
                                  caption: 'Edit',
                                  color: Colors.blue,
                                  icon: Icons.edit,
                                  onTap: () => Navigator.of(context).pushNamed(
                                      TagForm.route,
                                      arguments: {'tag': tag}),
                                ),
                              ],
                      ),
                    ),
                  ),
                ))
            .toList(),
        onReorder: (from, to) {
          log.info('from $from to $to');
          BarcodeService.reorderTag(tags, from, to);
        });
  }
}
