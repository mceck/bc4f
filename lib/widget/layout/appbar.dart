import 'package:bc4f/screens/groups/group-editable-list.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/widget/components/tags.dart';
import 'package:flutter/material.dart';

class WrapWithExpandedAppbar extends StatelessWidget {
  final Widget child;
  final void Function(String search) onSearch;
  final void Function(List<String> filter) onTagFilterChange;
  final void Function(List<String> filter) onGroupFilterChange;
  final Widget subtitle;
  final List<String> tagFilters;
  final List<String> groupFilters;

  const WrapWithExpandedAppbar(
      {Key key,
      this.child,
      this.onSearch,
      this.onTagFilterChange,
      this.onGroupFilterChange,
      this.subtitle,
      this.tagFilters,
      this.groupFilters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpandedAppbar(
          onGroupFilterChange: onGroupFilterChange,
          onSearch: onSearch,
          onTagFilterChange: onTagFilterChange,
          subtitle: subtitle,
          tagFilters: tagFilters,
          groupFilters: groupFilters,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                left: kDefaultPadding,
                top: kDefaultPadding,
                right: kDefaultPadding,
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class ExpandedAppbar extends StatelessWidget {
  final void Function(String search) onSearch;
  final void Function(List<String> filter) onTagFilterChange;
  final void Function(List<String> filter) onGroupFilterChange;
  final Widget subtitle;
  final List<String> tagFilters;
  final List<String> groupFilters;

  const ExpandedAppbar(
      {Key key,
      this.onSearch,
      this.onTagFilterChange,
      this.onGroupFilterChange,
      this.subtitle,
      this.tagFilters,
      this.groupFilters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: size.height * 0.15),
              padding: EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                bottom: onSearch != null ? kDefaultPadding * 3 : 0,
              ),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(25)),
                color: Theme.of(context).primaryColor,
              ),
              child: DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.white),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: kDefaultPadding / 2),
                      child: subtitle,
                    ),
                    if (onGroupFilterChange != null)
                      EditableGroupList(
                        onGroupFilterChange: onGroupFilterChange,
                        groups: groupFilters,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                    if (onTagFilterChange != null)
                      EditableTagList(
                        onTagFilterChange: onTagFilterChange,
                        tags: tagFilters,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (onSearch != null)
            Positioned(
              bottom: 8,
              child: Container(
                width: size.width - (kDefaultPadding * 2),
                height: 50,
                padding: const EdgeInsets.only(left: kDefaultPadding * 2),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        offset: Offset(2, 4),
                        spreadRadius: 1,
                        color: Colors.black26,
                      )
                    ],
                    color: Colors.white,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                    ),
                    onChanged: onSearch,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
