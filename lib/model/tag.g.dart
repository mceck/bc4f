// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      uid: json['uid'] as String?,
      name: json['name'] as String?,
      color: _TagConv.colorFromJson(json['color'] as Map<String, dynamic>?),
      order: (json['order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'color': _TagConv.colorToJson(instance.color),
      'order': instance.order,
    };
