import 'package:flutter/material.dart';

class SelectList extends StatelessWidget {
  final List<String> list;
  final String value;
  final Function(String) onChanged;
  final Widget Function(String) display;
  final bool showUnderline;
  final bool showIcon;
  final Widget hint;
  final TextStyle textStyle;

  const SelectList(
      {Key key,
      this.list,
      this.value,
      this.onChanged,
      this.display,
      this.showUnderline = true,
      this.showIcon = true,
      this.hint,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final _display = display ?? (val) => Text(val);
    return DropdownButton<String>(
      key: key,
      value: value,
      icon: Icon(
        Icons.arrow_downward,
        color: primaryColor,
        size: showIcon ? 20 : 0,
      ),
      hint: hint ?? Text('Choose'),
      iconSize: 24,
      elevation: 16,
      style: textStyle,
      underline: showUnderline
          ? Container(
              height: 2,
              color: primaryColor,
            )
          : Container(),
      onChanged: onChanged,
      items: list.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: _display(value),
        );
      }).toList(),
    );
  }
}
