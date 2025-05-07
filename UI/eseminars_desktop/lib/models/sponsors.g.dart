// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sponsors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sponsors _$SponsorsFromJson(Map<String, dynamic> json) => Sponsors(
      sponzorId: (json['sponzorId'] as num?)?.toInt(),
      naziv: json['naziv'] as String?,
      email: json['email'] as String?,
      telefon: json['telefon'] as String?,
      kontaktOsoba: json['kontaktOsoba'] as String?,
    );

Map<String, dynamic> _$SponsorsToJson(Sponsors instance) => <String, dynamic>{
      'sponzorId': instance.sponzorId,
      'naziv': instance.naziv,
      'email': instance.email,
      'telefon': instance.telefon,
      'kontaktOsoba': instance.kontaktOsoba,
    };
