import 'dart:convert';
import 'package:eseminars_desktop/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class KorisniciProvider {

  static String? _baseUrl;
  KorisniciProvider(){
    _baseUrl = const String.fromEnvironment("baseUrl",defaultValue: "http://localhost:5106/");
  }

  Future<dynamic> get() async{
    var url = "${_baseUrl}Korisnici";
    var uri = Uri.parse(url);
    var response = await http.get(uri,headers: createHeaders());

    if(isValidResponse(response)){
      var data = jsonDecode(response.body);
      return data;
    }else{
      throw new Exception("Unknown exception");
    }
  }
  bool isValidResponse(Response response){
    if(response.statusCode < 299){
      return true;
    }
    else if(response.statusCode == 401){
      throw new Exception("Unauthorized");
    }else{
      throw new Exception("Something bad happend, please try again");
    }
  }

  Map<String,String> createHeaders(){
    String email = AuthProvider.email!;
    String password = AuthProvider.password!;

    String basicAuth = "Basic ${base64Encode(utf8.encode('$email:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    return headers;
  }
}