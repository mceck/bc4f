import 'package:bc4f/provider/tag-provider.dart';
import 'package:bc4f/screens/search/search.dart';
import 'package:bc4f/screens/tags/form/tag-form.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/tag.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

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
    final tags = Provider.of<TagProvider>(context).tags;
    return Bc4fScaffold(
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 4 / 2,
            maxCrossAxisExtent: 300,
            crossAxisSpacing: kDefaultPadding,
            mainAxisSpacing: kDefaultPadding,
          ),
          shrinkWrap: true,
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
          }),
      floatAction: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(TagForm.route),
        child: Icon(Icons.add),
      ),
    );
  }
}
