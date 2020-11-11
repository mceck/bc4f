// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) {
  return Tag(
    id: json['id'] as String,
    tag: json['tag'] as String,
    color: _TagConv.colorFromJson(json['color'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'color': _TagConv.colorToJson(instance.color),
    };
