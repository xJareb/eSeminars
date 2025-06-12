import 'package:eseminars_desktop/models/materials.dart';
import 'package:eseminars_desktop/providers/base_provider.dart';

class MaterialsProvider extends BaseProvider<Materials>{
  MaterialsProvider():super("Materijali");

  @override
  Materials fromJson(data) {
    // TODO: implement fromJson
    return Materials.fromJson(data);
  }
}