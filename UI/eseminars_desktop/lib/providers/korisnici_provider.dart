import 'dart:convert';
import 'dart:math';
import 'package:eseminars_desktop/models/korisnik.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/providers/auth_provider.dart';
import 'package:eseminars_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class KorisniciProvider extends BaseProvider<Korisnik> {
  KorisniciProvider() : super("Korisnici");

  @override
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }
}