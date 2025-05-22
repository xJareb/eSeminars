import 'package:json_annotation/json_annotation.dart';

part 'categories.g.dart';

@JsonSerializable()
class Categories {
  int? kategorijaId;
  String? naziv;
  String? opis;


  Categories({this.kategorijaId,this.naziv,this.opis});

  
  factory Categories.fromJson(Map<String, dynamic> json) => _$CategoriesFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CategoriesToJson(this);

  

}