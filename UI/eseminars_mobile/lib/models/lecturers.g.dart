// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecturers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lecturers _$LecturersFromJson(Map<String, dynamic> json) => Lecturers(
      predavacId: (json['predavacId'] as num?)?.toInt(),
      ime: json['ime'] as String?,
      prezime: json['prezime'] as String?,
      biografija: json['biografija'] as String?,
      email: json['email'] as String?,
      telefon: json['telefon'] as String?,
    );

Map<String, dynamic> _$LecturersToJson(Lecturers instance) => <String, dynamic>{
      'predavacId': instance.predavacId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'biografija': instance.biografija,
      'email': instance.email,
      'telefon': instance.telefon,
    };
