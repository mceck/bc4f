import 'package:flutter/material.dart';

class ListUtil {
  static List<Widget> separated(List<Widget> list) {
    final List<Widget> ret = [];
    for (int i = 0; i < list.length; i++) {
      if (i < list.length - 1)
        ret.add(
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: 1,
                ),
              ),
            ),
            child: list[i],
          ),
        );
      else
        ret.add(list[i]);
    }
    return ret;
  }
}
