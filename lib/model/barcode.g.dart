// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Barcode _$BarcodeFromJson(Map<String, dynamic> json) {
  return Barcode(
    code: json['code'] as String,
    description: json['description'] as String,
    type: _BarcodeConv.bcTypeFromJson(json['type'] as String) ??
        bcLib.BarcodeType.CodeEAN13,
    id: json['id'] as String,
    imgUrl: json['imgUrl'] as String,
    name: json['name'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList() ?? [],
    order: json['order'] as int ?? 0,
  );
}

Map<String, dynamic> _$BarcodeToJson(Barcode instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'type': _BarcodeConv.bcTypeToJson(instance.type),
      'name': instance.name,
      'description': instance.description,
      'imgUrl': instance.imgUrl,
      'tags': instance.tags,
      'order': instance.order,
    };
