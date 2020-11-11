import 'package:flutter/material.dart';
import 'package:bc4f/model/group.dart';
import 'package:bc4f/model/tag.dart';

class SearchScreen extends StatefulWidget {
  static const route = '/search';

  final String search;
  final List<Tag> tagFilters;
  final List<BarcodeGroup> groupFilters;

  const SearchScreen({Key key, this.search, this.tagFilters, this.groupFilters})
      : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Text('Not implemented');
  }
}
