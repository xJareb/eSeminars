import 'package:json_annotation/json_annotation.dart';

part 'materials.g.dart';

@JsonSerializable()
class Materials {
  int? materijalId;
  int? seminarId;
  String? naziv;
  String? putanja;

  Materials({this.materijalId,this.seminarId,this.naziv,this.putanja});

  factory Materials.fromJson(Map<String, dynamic> json) => _$MaterialsFromJson(json);
  Map<String, dynamic> toJson() => _$MaterialsToJson(this);
}