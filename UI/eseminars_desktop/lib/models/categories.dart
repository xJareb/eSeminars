import 'package:json_annotation/json_annotation.dart';

part 'categories.g.dart';

@JsonSerializable()
class Categories {
  int? kategorijaId;
  String? naziv;


  Categories({this.kategorijaId,this.naziv});


  factory Categories.fromJson(Map<String, dynamic> json) => _$CategoriesFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CategoriesToJson(this);
}