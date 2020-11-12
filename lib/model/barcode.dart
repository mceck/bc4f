import 'package:barcode/barcode.dart' as bcLib;
import 'package:json_annotation/json_annotation.dart';
part 'barcode.g.dart';

@JsonSerializable()
class Barcode {
  String uid;
  String code;
  @JsonKey(
    fromJson: _BarcodeConv.bcTypeFromJson,
    toJson: _BarcodeConv.bcTypeToJson,
  )
  bcLib.BarcodeType type;
  String group;
  String name;
  String description;
  String imgUrl;
  @JsonKey(defaultValue: <String>[])
  List<String> tags;
  @JsonKey(defaultValue: 0)
  int order;

  Barcode({
    this.code,
    this.group,
    this.description,
    this.type = bcLib.BarcodeType.CodeEAN13,
    this.uid,
    this.imgUrl,
    this.name,
    this.tags,
    this.order = 0,
  }) {
    this.tags = this.tags ?? [];
  }
  factory Barcode.fromJson(Map<String, dynamic> json) =>
      _$BarcodeFromJson(json);
  Map<String, dynamic> toJson() => _$BarcodeToJson(this);
}

class _BarcodeConv {
  static String bcTypeToJson(bcLib.BarcodeType type) {
    return type.toString().split('.')[1];
  }

  static bcLib.BarcodeType bcTypeFromJson(String type) {
    return bcLib.BarcodeType.values.firstWhere(
        (t) => t.toString().split('.')[1] == type,
        orElse: () => bcLib.BarcodeType.CodeEAN13);
  }
}
