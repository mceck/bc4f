// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarcodeGroup _$BarcodeGroupFromJson(Map<String, dynamic> json) {
  return BarcodeGroup(
    description: json['description'] as String,
    uid: json['uid'] as String,
    imgUrl: json['imgUrl'] as String,
    name: json['name'] as String,
    order: json['order'] as int ?? 0,
  );
}

Map<String, dynamic> _$BarcodeGroupToJson(BarcodeGroup instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'description': instance.description,
      'imgUrl': instance.imgUrl,
      'order': instance.order,
    };
