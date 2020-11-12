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
    final r = val['r'];
    final g = val['g'];
    final b = val['b'];
    final opacity = val['opacity'] ?? 1;
    return Color.fromRGBO(r, g, b, opacity);
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
