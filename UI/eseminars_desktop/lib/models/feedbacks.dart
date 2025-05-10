import 'package:eseminars_desktop/models/korisnik.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feedbacks.g.dart';

@JsonSerializable()
class Feedbacks {
  int? dojamId;
  int? seminarId;
  int? korisnikId;
  Korisnik? korisnik;
  int? ocjena;

  Feedbacks({this.dojamId,this.seminarId,this.korisnikId,this.korisnik,this.ocjena});

  factory Feedbacks.fromJson(Map<String, dynamic> json) => _$FeedbacksFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$FeedbacksToJson(this);
}