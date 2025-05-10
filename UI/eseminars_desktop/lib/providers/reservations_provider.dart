import 'package:eseminars_desktop/models/reservations.dart';
import 'package:eseminars_desktop/providers/base_provider.dart';

class ReservationsProvider extends BaseProvider<Reservations>{
  ReservationsProvider():super("Rezervacije");

  @override
  Reservations fromJson(data) {
    // TODO: implement fromJson
    return Reservations.fromJson(data);
  }
}