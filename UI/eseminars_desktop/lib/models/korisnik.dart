import 'package:json_annotation/json_annotation.dart';

part 'korisnik.g.dart';

@JsonSerializable()
class Korisnik{
    String? ime;
    String? prezime;
    String? email;
    String? datumRodjenja;

    Korisnik({this.ime, this.prezime, this.email,this.datumRodjenja});


  factory Korisnik.fromJson(Map<String, dynamic> json) => _$KorisnikFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}