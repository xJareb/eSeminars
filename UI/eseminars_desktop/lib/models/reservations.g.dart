// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservations _$ReservationsFromJson(Map<String, dynamic> json) => Reservations(
      rezervacijaId: (json['rezervacijaId'] as num?)?.toInt(),
      seminarId: (json['seminarId'] as num?)?.toInt(),
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      stateMachine: json['stateMachine'] as String?,
      datumRezervacije: json['datumRezervacije'] as String?,
    );

Map<String, dynamic> _$ReservationsToJson(Reservations instance) =>
    <String, dynamic>{
      'rezervacijaId': instance.rezervacijaId,
      'seminarId': instance.seminarId,
      'korisnikId': instance.korisnikId,
      'korisnik': instance.korisnik,
      'stateMachine': instance.stateMachine,
      'datumRezervacije': instance.datumRezervacije,
    };
