import 'package:eseminars_mobile/models/roles.dart';
import 'package:json_annotation/json_annotation.dart';

part 'logged_user.g.dart';

@JsonSerializable()
class LoggedUser {
  int? korisnikId;
  String? ime;
  String? prezime;
  String? email;
  String? datumRodjenja;
  Roles? ulogaNavigation;

  LoggedUser({this.korisnikId,this.ime,this.prezime,this.email,this.datumRodjenja,this.ulogaNavigation});

  factory LoggedUser.fromJson(Map<String, dynamic> json) => _$LoggedUserFromJson(json);
  Map<String, dynamic> toJson() => _$LoggedUserToJson(this);

}