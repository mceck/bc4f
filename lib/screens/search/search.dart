import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/components/tags.dart';
import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart' as bcLib;
import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/screens/barcodes/view/barcode-view.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/widget/components/barcode-image.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:bc4f/model/group.dart';
import 'package:bc4f/model/tag.dart';

class SearchScreen extends StatefulWidget {
  static const route = '/search';

  final String search;
  final List<String> tagFilters;
  final List<String> groupFilters;

  const SearchScreen({Key key, this.search, this.tagFilters, this.groupFilters})
      : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Barcode> barcodes = [];
  String search;
  List<String> tagFilters;
  List<String> groupFilters;

  @override
  void initState() {
    search = widget.search ?? '';
    tagFilters = widget.tagFilters ?? [];
    groupFilters = widget.groupFilters ?? [];
    BarcodeService.getBarcodes().then((list) => setState(() {
          barcodes = list;
        }));
    super.initState();
  }

  bool _filterFunc(Barcode barcode) {
    bool check = true;
    //tag filter
    check = tagFilters.every((tf) => barcode.tags.contains(tf));
    if (!check) return false;
    //group filter
    check = groupFilters.isEmpty;
    check = check || groupFilters.any((gf) => barcode.group == gf);
    if (!check) return false;
    //word filter
    check = search.isEmpty;
    check = check ||
        (barcode.code?.toLowerCase()?.contains(search.toLowerCase()) ?? false);
    check = check ||
        (barcode.name?.toLowerCase()?.contains(search.toLowerCase()) ?? false);
    check = check ||
        (barcode.description?.toLowerCase()?.contains(search.toLowerCase()) ??
            false);
    if (!check) return false;

    return true;
  }

  List<Barcode> get filteredBarcodes {
    return barcodes.where(_filterFunc).toList();
  }

  @override
  Widget build(BuildContext context) {
    final barcodes = filteredBarcodes;
    return Bc4fScaffold(
      onSearch: (String str) {
        setState(() {
          search = str;
        });
      },
      onTagFilterChange: (List<String> filters) {
        setState(() {
          tagFilters = filters;
        });
      },
      tagFilters: tagFilters,
      onGroupFilterChange: (List<String> filters) {
        setState(() {
          groupFilters = filters;
        });
      },
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            // childAspectRatio: 4 / 3,
            maxCrossAxisExtent: 400,
            crossAxisSpacing: kDefaultPadding,
            mainAxisSpacing: kDefaultPadding,
          ),
          itemCount: barcodes.length,
          itemBuilder: (ctx, index) {
            final barcode = barcodes[index];
            return GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                BarcodeView.route,
                arguments: {'barcodes': barcodes, 'startIdx': index},
              ),
              child: Card(
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Image.network(
                        barcode.imgUrl ?? '',
                        errorBuilder: (ctx, err, stack) {
                          return BarcodeImage(
                            barcode.code ?? '',
                            barcode.type ?? bcLib.BarcodeType.CodeEAN13,
                            width: 200,
                          );
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ListTile(
                        title: Text(barcode.code ?? 'null'),
                        subtitle: Column(
                          children: [
                            Text(barcode.description ?? 'null'),
                            Text('group: ' + (barcode.group ?? 'null')),
                            TagList(tags: barcode.tags),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
