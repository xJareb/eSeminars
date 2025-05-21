// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logged_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoggedUser _$LoggedUserFromJson(Map<String, dynamic> json) => LoggedUser(
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      ime: json['ime'] as String?,
      prezime: json['prezime'] as String?,
      email: json['email'] as String?,
      datumRodjenja: json['datumRodjenja'] as String?,
      ulogaNavigation: json['ulogaNavigation'] == null
          ? null
          : Roles.fromJson(json['ulogaNavigation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoggedUserToJson(LoggedUser instance) =>
    <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'email': instance.email,
      'datumRodjenja': instance.datumRodjenja,
      'ulogaNavigation': instance.ulogaNavigation,
    };
