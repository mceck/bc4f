import 'package:json_annotation/json_annotation.dart';
import 'package:bc4f/model/barcode.dart';
part 'group.g.dart';

@JsonSerializable()
class BarcodeGroup {
  String id;
  @JsonKey(
      toJson: _GroupConv.groupListToJson,
      fromJson: _GroupConv.groupJsonToList,
      defaultValue: [])
  List<Barcode> barcodes;
  String name;
  String description;
  String imgUrl;
  @JsonKey(defaultValue: 0)
  int order;

  BarcodeGroup({
    this.barcodes,
    this.description,
    this.id,
    this.imgUrl,
    this.name,
    this.order,
  });
  factory BarcodeGroup.fromJson(Map<String, dynamic> json) =>
      _$BarcodeGroupFromJson(json);
  Map<String, dynamic> toJson() => _$BarcodeGroupToJson(this);
}

class _GroupConv {
  static Map<String, dynamic> groupListToJson(List<Barcode> list) {
    final Map<String, dynamic> map = {};
    list.forEach((bc) {
      map.putIfAbsent(bc.id, () => bc.toJson());
    });
    return map;
  }

  static List<Barcode> groupJsonToList(Map<String, dynamic> map) {
    if (map == null) return [];
    return map.values.map((e) => Barcode.fromJson(e)).toList()
      ..sort((a, b) => a.order - b.order);
  }
}
