import 'package:eseminars_desktop/models/categories.dart';
import 'package:eseminars_desktop/models/korisnik.dart';
import 'package:eseminars_desktop/models/lecturers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'seminars.g.dart';

@JsonSerializable()
class Seminars {
  int? seminarId;
  String? naslov;
  String? opis;
  String? datumVrijeme;
  String? lokacija;
  int? kapacitet;
  String? stateMachine;
  Korisnik? korisnik;
  Lecturers? predavac;
  Categories? kategorija;

  Seminars({this.seminarId,this.naslov,this.opis,this.datumVrijeme,this.lokacija,this.kapacitet,this.stateMachine,this.korisnik,this.predavac,this.kategorija});

  factory Seminars.fromJson(Map<String, dynamic> json) => _$SeminarsFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SeminarsToJson(this);
}