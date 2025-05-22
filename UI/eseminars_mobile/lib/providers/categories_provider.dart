import 'package:eseminars_mobile/models/categories.dart';
import 'package:eseminars_mobile/providers/base_provider.dart';

class CategoriesProvider extends BaseProvider<Categories>{
  CategoriesProvider():super("Kategorije");

  @override
  Categories fromJson(data) {
    // TODO: implement fromJson
    return Categories.fromJson(data);
  }
}