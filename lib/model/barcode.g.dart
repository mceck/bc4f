// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Barcode _$BarcodeFromJson(Map<String, dynamic> json) => Barcode(
      code: json['code'] as String?,
      group: json['group'] as String?,
      description: json['description'] as String?,
      type: json['type'] == null
          ? bcLib.BarcodeType.CodeEAN13
          : _BarcodeConv.bcTypeFromJson(json['type'] as String),
      uid: json['uid'] as String?,
      imgUrl: json['imgUrl'] as String?,
      name: json['name'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$BarcodeToJson(Barcode instance) => <String, dynamic>{
      'uid': instance.uid,
      'code': instance.code,
      'type': _BarcodeConv.bcTypeToJson(instance.type),
      'group': instance.group,
      'name': instance.name,
      'description': instance.description,
      'imgUrl': instance.imgUrl,
      'tags': instance.tags,
      'order': instance.order,
    };
