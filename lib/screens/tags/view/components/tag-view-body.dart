import 'package:bc4f/model/tag.dart';
import 'package:bc4f/screens/search/search.dart';
import 'package:bc4f/screens/tags/form/tag-form.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TagViewBody extends StatelessWidget {
  const TagViewBody({
    Key key,
    @required this.tags,
  }) : super(key: key);

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        primary: false,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 4 / 2,
          maxCrossAxisExtent: kDefaultGridMaxExtent,
          crossAxisSpacing: kDefaultPadding,
          mainAxisSpacing: kDefaultPadding,
        ),
        itemCount: tags.length,
        itemBuilder: (ctx, idx) {
          final tag = tags[idx];
          return GestureDetector(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.label,
                      color: tag.color,
                    ),
                    Text(tag.name ?? 'null'),
                  ],
                ),
                actions: <Widget>[
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () => BarcodeService.deleteTag(tag.uid),
                  ),
                ],
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Edit',
                    color: Colors.blue,
                    icon: Icons.edit,
                    onTap: () => Navigator.of(context)
                        .pushNamed(TagForm.route, arguments: {'tag': tag}),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
