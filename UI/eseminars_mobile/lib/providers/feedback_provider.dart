import 'package:eseminars_mobile/models/feedbacks.dart';
import 'package:eseminars_mobile/providers/base_provider.dart';

class FeedbackProvider extends BaseProvider<Feedbacks>{
  FeedbackProvider():super("Dojmovi");

  @override
  Feedbacks fromJson(data) {
    // TODO: implement fromJson
    return Feedbacks.fromJson(data);
  }
}