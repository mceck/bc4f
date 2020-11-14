import 'package:json_annotation/json_annotation.dart';
part 'group.g.dart';

@JsonSerializable()
class BarcodeGroup {
  String uid;
  String name;
  String description;
  String imgUrl;
  @JsonKey(defaultValue: 0)
  int order;

  BarcodeGroup({
    this.description,
    this.uid,
    this.imgUrl,
    this.name,
    this.order,
  });
  factory BarcodeGroup.fromJson(Map<String, dynamic> json) =>
      _$BarcodeGroupFromJson(json);
  Map<String, dynamic> toJson() => _$BarcodeGroupToJson(this);
}
