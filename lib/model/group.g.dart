// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarcodeGroup _$BarcodeGroupFromJson(Map<String, dynamic> json) {
  return BarcodeGroup(
    barcodes:
        _GroupConv.groupJsonToList(json['barcodes'] as Map<String, dynamic>) ??
            [],
    description: json['description'] as String,
    id: json['id'] as String,
    imgUrl: json['imgUrl'] as String,
    name: json['name'] as String,
    order: json['order'] as int ?? 0,
  );
}

Map<String, dynamic> _$BarcodeGroupToJson(BarcodeGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'barcodes': _GroupConv.groupListToJson(instance.barcodes),
      'name': instance.name,
      'description': instance.description,
      'imgUrl': instance.imgUrl,
      'order': instance.order,
    };
