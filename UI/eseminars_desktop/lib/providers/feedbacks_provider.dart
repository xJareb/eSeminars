import 'package:eseminars_desktop/models/feedbacks.dart';
import 'package:eseminars_desktop/providers/base_provider.dart';

class FeedbacksProvider extends BaseProvider<Feedbacks>{
  FeedbacksProvider():super("Dojmovi");

  @override
  Feedbacks fromJson(data) {
    // TODO: implement fromJson
    return Feedbacks.fromJson(data);
  }
}