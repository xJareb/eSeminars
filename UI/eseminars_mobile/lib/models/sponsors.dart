import 'package:json_annotation/json_annotation.dart';

part 'sponsors.g.dart';

@JsonSerializable()
class Sponsors {
  int? sponzorId;
  String? naziv;
  String? email;
  String? telefon;
  String? kontaktOsoba;

  Sponsors({this.sponzorId,this.naziv,this.email,this.telefon,this.kontaktOsoba});

  factory Sponsors.fromJson(Map<String, dynamic> json) => _$SponsorsFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SponsorsToJson(this);
}