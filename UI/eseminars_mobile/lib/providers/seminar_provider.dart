import 'package:eseminars_mobile/models/seminars.dart';
import 'package:eseminars_mobile/providers/base_provider.dart';

class SeminarsProvider extends BaseProvider<Seminars>{
  SeminarsProvider():super("Seminari");

  @override
  Seminars fromJson(data) {
    // TODO: implement fromJson
    return Seminars.fromJson(data);
  }
}