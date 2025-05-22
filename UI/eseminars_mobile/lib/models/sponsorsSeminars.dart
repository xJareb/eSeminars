import 'package:eseminars_mobile/models/sponsors.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sponsorsSeminars.g.dart';

@JsonSerializable()
class Sponsorsseminars {
  int? sponzoriSeminariId;
  int? seminarId;
  int? sponzorId;
  Sponsors? sponzor;

  Sponsorsseminars({this.sponzoriSeminariId,this.seminarId,this.sponzorId,this.sponzor});

  factory Sponsorsseminars.fromJson(Map<String, dynamic> json) => _$SponsorsseminarsFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SponsorsseminarsToJson(this);
}