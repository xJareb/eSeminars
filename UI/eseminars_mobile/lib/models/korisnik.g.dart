// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnik _$KorisnikFromJson(Map<String, dynamic> json) => Korisnik(
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      ime: json['ime'] as String?,
      prezime: json['prezime'] as String?,
      email: json['email'] as String?,
      datumRodjenja: json['datumRodjenja'] as String?,
      lozinka: json['lozinka'] as String?,
      lozinkaPotvrda: json['lozinkaPotvrda'] as String?,
    );

Map<String, dynamic> _$KorisnikToJson(Korisnik instance) => <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'email': instance.email,
      'datumRodjenja': instance.datumRodjenja,
      'lozinka': instance.lozinka,
      'lozinkaPotvrda': instance.lozinkaPotvrda,
    };
