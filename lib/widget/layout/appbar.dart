import 'dart:math';

import 'package:bc4f/screens/groups/group-editable-list.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/images.dart';
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
  final String backgroundImage;

  const WrapWithExpandedAppbar(
      {Key key,
      this.child,
      this.onSearch,
      this.onTagFilterChange,
      this.onGroupFilterChange,
      this.subtitle,
      this.tagFilters,
      this.groupFilters,
      this.backgroundImage})
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
          backgroundImage: backgroundImage,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class ExpandedAppbar extends StatelessWidget {
  static const _kDefaultImages = [Images.bc1, Images.bc2, Images.bc3];

  final void Function(String search) onSearch;
  final void Function(List<String> filter) onTagFilterChange;
  final void Function(List<String> filter) onGroupFilterChange;
  final Widget subtitle;
  final List<String> tagFilters;
  final List<String> groupFilters;
  final String backgroundImage;

  const ExpandedAppbar(
      {Key key,
      this.onSearch,
      this.onTagFilterChange,
      this.onGroupFilterChange,
      this.subtitle,
      this.tagFilters,
      this.groupFilters,
      this.backgroundImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String bgImg = backgroundImage ?? _kDefaultImages[Random().nextInt(3)];
    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: size.height * 0.15),
              padding: EdgeInsets.only(
                  bottom: onSearch != null ? kDefaultPadding * 3 : 0),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(25)),
                color: Theme.of(context).primaryColor,
              ),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black,
                      )
                      // offset: Offset(-1, 1))
                    ]),
                child: Stack(
                  children: [
                    Image.asset(
                      bgImg,
                      fit: BoxFit.cover,
                      width: size.width,
                      height: size.height * 0.15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: kDefaultPadding,
                        left: kDefaultPadding,
                        right: kDefaultPadding,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            if (subtitle != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: kDefaultPadding / 2),
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
