import 'dart:convert';

import 'package:eseminars_mobile/models/seminars.dart';
import 'package:eseminars_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class SeminarsProvider extends BaseProvider<Seminars>{
  SeminarsProvider():super("Seminari");

  @override
  Seminars fromJson(data) {
    // TODO: implement fromJson
    return Seminars.fromJson(data);
  }
  Future<List<Seminars>> recommendedSeminars(int userId) async {
  var url = "${BaseProvider.baseUrl}Korisnici/${userId}/recommended-seminars";
  

  var headers = {
    "Content-Type": "application/json"
  };

  try {
    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Seminars.fromJson(item)).toList();
    } else {
      throw Exception('Greška pri učitavanju preporučenih seminara, status: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception: $e');
    rethrow;
  }
}
Future<void> hideSeminar(int id) async{
    final url = "${BaseProvider.baseUrl}Seminari/${id}/hide";
    var headers = createHeaders();
    var response = await http.put(Uri.parse(url), headers: headers);

    if (!isValidResponse(response)) {
    throw Exception("Failed to hide seminar");
  }
}
}