import 'package:eseminars_desktop/models/korisnik.dart';
import 'package:eseminars_desktop/models/search_result.dart';
import 'package:eseminars_desktop/providers/korisnici_provider.dart';

class LoggedKorisniciProvider extends KorisniciProvider{
@override
  Future<SearchResult<Korisnik>> get({filter}) {

    print("im in logged product provider");
    // TODO: implement get
    return super.get(filter: filter);
  }
}