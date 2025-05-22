// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notifications _$NotificationsFromJson(Map<String, dynamic> json) =>
    Notifications(
      obavijestId: (json['obavijestId'] as num?)?.toInt(),
      naslov: json['naslov'] as String?,
      sadrzaj: json['sadrzaj'] as String?,
      datumObavijesti: json['datumObavijesti'] as String?,
    );

Map<String, dynamic> _$NotificationsToJson(Notifications instance) =>
    <String, dynamic>{
      'obavijestId': instance.obavijestId,
      'naslov': instance.naslov,
      'sadrzaj': instance.sadrzaj,
      'datumObavijesti': instance.datumObavijesti,
    };
