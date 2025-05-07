import 'package:eseminars_desktop/models/sponsors.dart';
import 'package:eseminars_desktop/providers/base_provider.dart';

class SponsorsProvider extends BaseProvider<Sponsors>{
  SponsorsProvider():super("Sponzori");

  @override
  Sponsors fromJson(data) {
    // TODO: implement fromJson
    return Sponsors.fromJson(data);
  }
}