// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedbacks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Feedbacks _$FeedbacksFromJson(Map<String, dynamic> json) => Feedbacks(
      dojamId: (json['dojamId'] as num?)?.toInt(),
      seminarId: (json['seminarId'] as num?)?.toInt(),
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      ocjena: (json['ocjena'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FeedbacksToJson(Feedbacks instance) => <String, dynamic>{
      'dojamId': instance.dojamId,
      'seminarId': instance.seminarId,
      'korisnikId': instance.korisnikId,
      'korisnik': instance.korisnik,
      'ocjena': instance.ocjena,
    };
