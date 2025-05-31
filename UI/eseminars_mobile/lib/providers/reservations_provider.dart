import 'package:eseminars_mobile/models/reservations.dart';
import 'package:eseminars_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ReservationsProvider extends BaseProvider<Reservations>{
  ReservationsProvider():super("Rezervacije");

  Future<void> allowReservation(int id) async{
    var url = "${BaseProvider.baseUrl}Rezervacije/${id}/allow";

    var headers = createHeaders();
    var response = await http.put(Uri.parse(url), headers: headers);

     if (!isValidResponse(response)) {
      throw Exception("Failed to allow reservation");
  }
}
Future<void> rejectReservation(int id) async{
    var url = "${BaseProvider.baseUrl}Rezervacije/${id}/reject";

    var headers = createHeaders();
    var response = await http.put(Uri.parse(url), headers: headers);

     if (!isValidResponse(response)) {
      throw Exception("Failed to allow reservation");
  }
}
  @override
  Reservations fromJson(data) {
    // TODO: implement fromJson
    return Reservations.fromJson(data);
  }

}