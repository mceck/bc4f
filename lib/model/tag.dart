import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'tag.g.dart';

@JsonSerializable()
class Tag {
  String uid;
  String name;
  @JsonKey(toJson: _TagConv.colorToJson, fromJson: _TagConv.colorFromJson)
  Color color;

  Tag({
    this.uid,
    this.name,
    this.color,
  });
  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);
}

class _TagConv {
  static Color colorFromJson(Map<String, dynamic> val) {
    if (val == null) return Colors.white;
    final r = val['r'] as int;
    final g = val['g'] as int;
    final b = val['b'] as int;
    final opacity = val['opacity'];
    return Color.fromRGBO(r, g, b, opacity * 1.0);
  }

  static Map<String, dynamic> colorToJson(Color color) {
    if (color == null) return null;
    return {
      'r': color.red,
      'g': color.green,
      'b': color.blue,
      'opacity': color.opacity,
    };
  }
}
