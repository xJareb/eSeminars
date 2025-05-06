import 'package:json_annotation/json_annotation.dart';

part 'notifications.g.dart';

@JsonSerializable()
class Notifications {
  int? obavijestId;
  String? naslov;
  String? sadrzaj;
  String? datumObavijesti;

  Notifications({this.obavijestId,this.naslov,this.sadrzaj,this.datumObavijesti});

  factory Notifications.fromJson(Map<String, dynamic> json) => _$NotificationsFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$NotificationsToJson(this);
}