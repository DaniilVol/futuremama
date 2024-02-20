import 'package:futuremama/model/name_model.dart';
import 'package:hive/hive.dart';

class NameHive {
  static const String boxName = 'nameBox';

  static Future<void> saveData(List<NameModel> data) async {
    final box = await Hive.openBox<NameModel>(boxName);

    try {
      await box.clear();
      await box.addAll(data);
    } finally {
      await box.close();
    }
  }

  static List<NameModel> loadData() {
    final box = Hive.box<NameModel>(boxName);
    return box.values.toList();
  }
}
