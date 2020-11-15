import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/model/group.dart';
import 'package:bc4f/provider/barcode-provider.dart';
import 'package:bc4f/screens/barcodes/form/barcode-form.dart';
import 'package:bc4f/screens/groups/detail/components/group-detail-body.dart';
import 'package:bc4f/screens/groups/form/group-form.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupDetail extends StatefulWidget {
  static const route = '/groups/detail';

  final BarcodeGroup group;

  const GroupDetail({Key key, this.group}) : super(key: key);

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  List<String> tagFilters = [];

  void onTagFilterChange(filters) {
    setState(() {
      tagFilters = filters;
    });
  }

  List<Barcode> filterList(List<Barcode> barcodes) {
    return barcodes
        .where(
          (bar) =>
              bar.group == widget.group.uid &&
              tagFilters.every(
                (filter) => bar.tags.contains(filter),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Bc4fScaffold(
      onTagFilterChange: onTagFilterChange,
      title: Text('Group: ${widget.group.name}'),
      subtitle: Column(
        children: [
          Text(widget.group.description),
          SizedBox(height: kDefaultPadding),
          Text(
            'View, add, edit or delete barcodes for this group',
            textAlign: TextAlign.center,
          )
        ],
      ),
      actionEdit: () {
        log.info('edit group');
        Navigator.of(context).pushNamed(
          GroupForm.route,
          arguments: {'group': widget.group},
        );
      },
      body: Consumer<BarcodeProvider>(
        builder: (ctx, barcodeProvider, child) =>
            GroupDetailBody(barcodes: filterList(barcodeProvider.barcodes)),
      ),
      floatAction: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          log.info('new barcode for group');
          Navigator.of(context).pushNamed(BarcodeForm.route, arguments: {
            'barcode': Barcode(
              group: widget.group.uid,
            )
          });
        },
      ),
    );
  }
}
