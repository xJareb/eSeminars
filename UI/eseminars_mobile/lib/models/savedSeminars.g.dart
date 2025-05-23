// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savedSeminars.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Savedseminars _$SavedseminarsFromJson(Map<String, dynamic> json) =>
    Savedseminars(
      sacuvaniSeminarId: (json['sacuvaniSeminarId'] as num?)?.toInt(),
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      seminar: json['seminar'] == null
          ? null
          : Seminars.fromJson(json['seminar'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SavedseminarsToJson(Savedseminars instance) =>
    <String, dynamic>{
      'sacuvaniSeminarId': instance.sacuvaniSeminarId,
      'korisnikId': instance.korisnikId,
      'seminar': instance.seminar,
    };
