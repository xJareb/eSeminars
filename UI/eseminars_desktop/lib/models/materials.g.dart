// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Materials _$MaterialsFromJson(Map<String, dynamic> json) => Materials(
      materijalId: (json['materijalId'] as num?)?.toInt(),
      seminarId: (json['seminarId'] as num?)?.toInt(),
      naziv: json['naziv'] as String?,
      putanja: json['putanja'] as String?,
    );

Map<String, dynamic> _$MaterialsToJson(Materials instance) => <String, dynamic>{
      'materijalId': instance.materijalId,
      'seminarId': instance.seminarId,
      'naziv': instance.naziv,
      'putanja': instance.putanja,
    };
