import 'package:eseminars_mobile/models/notifications.dart';
import 'package:eseminars_mobile/providers/base_provider.dart';

class NotificationsProvider extends BaseProvider<Notifications>{
  NotificationsProvider():super("Obavijesti");

  @override
  Notifications fromJson(data) {
    // TODO: implement fromJson
    return Notifications.fromJson(data);
  }
}