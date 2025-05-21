import 'dart:convert';
import 'dart:math';
import 'package:eseminars_mobile/models/korisnik.dart';
import 'package:eseminars_mobile/models/logged_user.dart';
import 'package:eseminars_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class KorisniciProvider extends BaseProvider<Korisnik> {
  KorisniciProvider() : super("Korisnici");

  Future<LoggedUser?> login(String email,String password) async{
    var url = "${BaseProvider.baseUrl}Korisnici/login?username=$email&password=$password";

    var headers = {
    "Content-Type": "application/json"
    };
    var response = await http.post(Uri.parse(url), headers: headers);

    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      return LoggedUser.fromJson(data);
    }else{
      return null;
    }
  }
  
  @override
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }
}
