import 'package:bc4f/provider/barcode-provider.dart';
import 'package:bc4f/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:provider/provider.dart';

import 'components/search-body.dart';

class SearchScreen extends StatefulWidget {
  static const route = '/search';

  final String? search;
  final List<String>? tagFilters;
  final List<String>? groupFilters;

  const SearchScreen({
    super.key,
    this.search,
    this.tagFilters,
    this.groupFilters,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String search;
  late List<String> tagFilters;
  late List<String> groupFilters;

  @override
  void initState() {
    search = widget.search ?? '';
    tagFilters = widget.tagFilters ?? [];
    groupFilters = widget.groupFilters ?? [];
    super.initState();
  }

  bool _filterFunc(Barcode barcode) {
    // tag filter
    if (!tagFilters.every((tf) => barcode.tags.contains(tf))) return false;
    // group filter
    if (groupFilters.isNotEmpty &&
        !groupFilters.any((gf) => barcode.group == gf)) return false;
    // word filter
    if (search.isNotEmpty) {
      final q = search.toLowerCase();
      final inCode = barcode.code?.toLowerCase().contains(q) ?? false;
      final inName = barcode.name?.toLowerCase().contains(q) ?? false;
      final inDesc =
          barcode.description?.toLowerCase().contains(q) ?? false;
      if (!inCode && !inName && !inDesc) return false;
    }
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
        setState(() => search = str);
      },
      onTagFilterChange: (List<String> filters) {
        setState(() => tagFilters = filters);
      },
      tagFilters: tagFilters,
      groupFilters: groupFilters,
      onGroupFilterChange: (List<String> filters) {
        setState(() => groupFilters = filters);
      },
      title: const Text('Search barcodes'),
      backgroundImage: Images.bc1,
      body: SearchBody(barcodes: barcodes),
    );
  }
}
