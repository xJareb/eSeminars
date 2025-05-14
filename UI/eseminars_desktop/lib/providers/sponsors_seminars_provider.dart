import 'package:eseminars_desktop/models/sponsorsSeminars.dart';
import 'package:eseminars_desktop/providers/base_provider.dart';

class SponsorsSeminarsProvider extends BaseProvider<Sponsorsseminars>{
  SponsorsSeminarsProvider():super("SponzoriSeminari");

 @override
  Sponsorsseminars fromJson(data) {
    // TODO: implement fromJson
    return Sponsorsseminars.fromJson(data);
  }
}