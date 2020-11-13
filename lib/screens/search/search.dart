import 'package:bc4f/provider/barcode-provider.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:provider/provider.dart';

import 'components/search-body.dart';

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
  String search;
  List<String> tagFilters;
  List<String> groupFilters;

  @override
  void initState() {
    search = widget.search ?? '';
    tagFilters = widget.tagFilters ?? [];
    groupFilters = widget.groupFilters ?? [];
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
    final barcodes = Provider.of<BarcodeProvider>(context).barcodes;
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
      body: SearchBody(barcodes: barcodes),
    );
  }
}
