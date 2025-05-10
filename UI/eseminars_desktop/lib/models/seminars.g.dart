// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seminars.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Seminars _$SeminarsFromJson(Map<String, dynamic> json) => Seminars(
      seminarId: (json['seminarId'] as num?)?.toInt(),
      naslov: json['naslov'] as String?,
      opis: json['opis'] as String?,
      datumVrijeme: json['datumVrijeme'] as String?,
      lokacija: json['lokacija'] as String?,
      kapacitet: (json['kapacitet'] as num?)?.toInt(),
      stateMachine: json['stateMachine'] as String?,
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      predavac: json['predavac'] == null
          ? null
          : Lecturers.fromJson(json['predavac'] as Map<String, dynamic>),
      kategorija: json['kategorija'] == null
          ? null
          : Categories.fromJson(json['kategorija'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SeminarsToJson(Seminars instance) => <String, dynamic>{
      'seminarId': instance.seminarId,
      'naslov': instance.naslov,
      'opis': instance.opis,
      'datumVrijeme': instance.datumVrijeme,
      'lokacija': instance.lokacija,
      'kapacitet': instance.kapacitet,
      'stateMachine': instance.stateMachine,
      'korisnik': instance.korisnik,
      'predavac': instance.predavac,
      'kategorija': instance.kategorija,
    };
