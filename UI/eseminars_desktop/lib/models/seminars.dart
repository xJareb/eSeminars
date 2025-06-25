import 'package:eseminars_desktop/models/categories.dart';
import 'package:eseminars_desktop/models/feedbacks.dart';
import 'package:eseminars_desktop/models/korisnik.dart';
import 'package:eseminars_desktop/models/lecturers.dart';
import 'package:eseminars_desktop/models/sponsorsSeminars.dart';
import 'package:flutter/material.dart';
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
  int? zauzeti;
  String? stateMachine;
  Korisnik? korisnik;
  Lecturers? predavac;
  Categories? kategorija;
  List<Feedbacks>? dojmovis;
  List<Sponsorsseminars>? sponzoriSeminaris;

  Seminars({this.seminarId,this.naslov,this.opis,this.datumVrijeme,this.lokacija,this.kapacitet,this.zauzeti,this.stateMachine,this.korisnik,this.predavac,this.kategorija,this.dojmovis,this.sponzoriSeminaris});

  factory Seminars.fromJson(Map<String, dynamic> json) => _$SeminarsFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SeminarsToJson(this);
}