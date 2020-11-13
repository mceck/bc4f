import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/model/group.dart';
import 'package:bc4f/provider/barcode-provider.dart';
import 'package:bc4f/screens/barcodes/form/barcode-form.dart';
import 'package:bc4f/screens/groups/detail/components/group-grid.dart';
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
      onTagFilterChange: (filters) {
        setState(() {
          tagFilters = filters;
        });
      },
      icon: Icon(Icons.group_work),
      title: widget.group.name,
      subtitle: widget.group.description,
      actionEdit: () {
        log.info('edit group');
        Navigator.of(context).pushNamed(
          GroupForm.route,
          arguments: {'group': widget.group},
        );
      },
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Consumer<BarcodeProvider>(
          builder: (ctx, barcodeProvider, child) => Column(
            children: [
              Text('Barcodes:'),
              Expanded(
                child:
                    GroupGrid(barcodes: filterList(barcodeProvider.barcodes)),
              ),
            ],
          ),
        ),
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
