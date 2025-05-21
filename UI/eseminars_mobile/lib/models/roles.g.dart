// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Roles _$RolesFromJson(Map<String, dynamic> json) => Roles(
      ulogaId: (json['ulogaId'] as num?)?.toInt(),
      naziv: json['naziv'] as String?,
    );

Map<String, dynamic> _$RolesToJson(Roles instance) => <String, dynamic>{
      'ulogaId': instance.ulogaId,
      'naziv': instance.naziv,
    };
