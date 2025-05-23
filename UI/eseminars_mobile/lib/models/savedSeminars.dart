import 'package:eseminars_mobile/models/seminars.dart';
import 'package:json_annotation/json_annotation.dart';

part 'savedSeminars.g.dart';

@JsonSerializable()
class Savedseminars {
  int? sacuvaniSeminarId;
  int? korisnikId;
  Seminars? seminar;

  Savedseminars({this.sacuvaniSeminarId,this.korisnikId,this.seminar});

  factory Savedseminars.fromJson(Map<String, dynamic> json) => _$SavedseminarsFromJson(json);
  Map<String, dynamic> toJson() => _$SavedseminarsToJson(this);
}