import 'package:eseminars_mobile/models/savedSeminars.dart';
import 'package:eseminars_mobile/providers/base_provider.dart';

class WishlistProvider extends BaseProvider<Savedseminars>{
  WishlistProvider():super("SacuvaniSeminari");

  @override
  Savedseminars fromJson(data) {
    // TODO: implement fromJson
    return Savedseminars.fromJson(data);
  }
}