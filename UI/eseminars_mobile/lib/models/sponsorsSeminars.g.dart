// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sponsorsSeminars.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sponsorsseminars _$SponsorsseminarsFromJson(Map<String, dynamic> json) =>
    Sponsorsseminars(
      sponzoriSeminariId: (json['sponzoriSeminariId'] as num?)?.toInt(),
      seminarId: (json['seminarId'] as num?)?.toInt(),
      sponzorId: (json['sponzorId'] as num?)?.toInt(),
      sponzor: json['sponzor'] == null
          ? null
          : Sponsors.fromJson(json['sponzor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SponsorsseminarsToJson(Sponsorsseminars instance) =>
    <String, dynamic>{
      'sponzoriSeminariId': instance.sponzoriSeminariId,
      'seminarId': instance.seminarId,
      'sponzorId': instance.sponzorId,
      'sponzor': instance.sponzor,
    };
