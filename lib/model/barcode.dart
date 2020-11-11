import 'package:barcode/barcode.dart' as bcLib;
import 'package:json_annotation/json_annotation.dart';
part 'barcode.g.dart';

@JsonSerializable()
class Barcode {
  String id;
  String code;
  @JsonKey(
    fromJson: _BarcodeConv.bcTypeFromJson,
    toJson: _BarcodeConv.bcTypeToJson,
    defaultValue: bcLib.BarcodeType.CodeEAN13,
  )
  bcLib.BarcodeType type;
  String name;
  String description;
  String imgUrl;
  @JsonKey(defaultValue: [])
  List<String> tags;
  @JsonKey(defaultValue: 0)
  int order;

  Barcode({
    this.code,
    this.description,
    this.type,
    this.id,
    this.imgUrl,
    this.name,
    this.tags,
    this.order,
  });
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
        orElse: () => null);
  }
}
