import 'package:eseminars_desktop/models/categories.dart';
import 'package:eseminars_desktop/providers/base_provider.dart';

class CategoriesProvider extends BaseProvider<Categories>{
  CategoriesProvider():super("Kategorije");

  @override
  Categories fromJson(data) {
    // TODO: implement fromJson
    return Categories.fromJson(data);
  }
}