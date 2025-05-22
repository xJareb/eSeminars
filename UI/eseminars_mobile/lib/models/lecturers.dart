import 'package:json_annotation/json_annotation.dart';

part 'lecturers.g.dart';

@JsonSerializable()
class Lecturers {
  int? predavacId;
  String? ime;
  String? prezime;
  String? biografija;
  String? email;
  String? telefon;

  Lecturers({this.predavacId,this.ime,this.prezime,this.biografija,this.email,this.telefon});

  factory Lecturers.fromJson(Map<String, dynamic> json) => _$LecturersFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LecturersToJson(this);

  
}