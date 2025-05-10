import 'package:eseminars_desktop/models/korisnik.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservations.g.dart';

@JsonSerializable()
class Reservations {
  int? rezervacijaId;
  int? seminarId;
  int? korisnikId;
  Korisnik? korisnik;
  String? stateMachine;
  String? datumRezervacije;

  Reservations({this.rezervacijaId,this.seminarId,this.korisnikId,this.korisnik,this.stateMachine,this.datumRezervacije});

   factory Reservations.fromJson(Map<String, dynamic> json) => _$ReservationsFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ReservationsToJson(this);
}