import 'package:eseminars_mobile/models/lecturers.dart';
import 'package:eseminars_mobile/providers/base_provider.dart';

class LecturersProvider extends BaseProvider<Lecturers>{
  LecturersProvider():super("Predavaci");


  @override
  Lecturers fromJson(data) {
    // TODO: implement fromJson
    return Lecturers.fromJson(data);
  }
}