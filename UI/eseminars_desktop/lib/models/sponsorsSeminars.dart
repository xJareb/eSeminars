import 'package:json_annotation/json_annotation.dart';

part 'sponsorsSeminars.g.dart';

@JsonSerializable()
class Sponsorsseminars {
  int? sponzoriSeminariId;
  int? seminarId;
  int? sponzorId;

  Sponsorsseminars({this.sponzoriSeminariId,this.seminarId,this.sponzorId});

  factory Sponsorsseminars.fromJson(Map<String, dynamic> json) => _$SponsorsseminarsFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SponsorsseminarsToJson(this);
}