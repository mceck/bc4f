import 'package:flutter/material.dart';

class SelectList extends StatelessWidget {
  final List<String> list;
  final String? value;
  final Function(String?)? onChanged;
  final Widget Function(String)? display;
  final bool showUnderline;
  final bool showIcon;
  final Widget? hint;
  final TextStyle? textStyle;

  const SelectList({
    super.key,
    required this.list,
    this.value,
    this.onChanged,
    this.display,
    this.showUnderline = true,
    this.showIcon = true,
    this.hint,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final displayFn = display ?? (val) => Text(val);
    return DropdownButton<String>(
      key: key,
      value: value,
      icon: Icon(
        Icons.arrow_downward,
        color: primaryColor,
        size: showIcon ? 20 : 0,
      ),
      hint: hint ?? const Text('Choose'),
      iconSize: 24,
      elevation: 16,
      style: textStyle,
      underline: showUnderline
          ? Container(height: 2, color: primaryColor)
          : Container(),
      onChanged: onChanged,
      items: list.map<DropdownMenuItem<String>>((val) {
        return DropdownMenuItem<String>(
          value: val,
          child: displayFn(val),
        );
      }).toList(),
    );
  }
}
