import 'dart:convert';
import 'dart:math';
import 'package:eseminars_mobile/models/korisnik.dart';
import 'package:eseminars_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class KorisniciProvider extends BaseProvider<Korisnik> {
  KorisniciProvider() : super("Korisnici");

  @override
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }
}
