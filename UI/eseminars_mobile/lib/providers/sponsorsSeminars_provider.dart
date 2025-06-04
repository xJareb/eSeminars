import 'package:eseminars_mobile/models/sponsorsSeminars.dart';
import 'package:eseminars_mobile/providers/base_provider.dart';

class SponsorsseminarsProvider extends BaseProvider<Sponsorsseminars> {
  SponsorsseminarsProvider():super("SponzoriSeminari");

  @override
  Sponsorsseminars fromJson(data) {
    // TODO: implement fromJson
    return Sponsorsseminars.fromJson(data);
  }
}