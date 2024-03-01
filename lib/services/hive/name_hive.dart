import 'package:futuremama/model/name_model.dart';
import 'package:futuremama/services/api/name_api.dart';
import 'package:hive/hive.dart';

class NameHive {
  static Future<List<NameModel>> loadData() async {
    final box = await Hive.openBox<NameModel>('name_list');
    // final box = Hive.box<NameModel>('names_list');

    if (box.isEmpty) {
      List<NameModel> results = await NameApi.getData();
      for (var name in results) {
        await box.add(name);
      }
      return results;
    } else {
      final List<NameModel> results = box.values.toList();
      return results;
    }
  }

  // static List<NameModel> loadData() {
  //   final box = Hive.box<NameModel>('nameBox');
  //   return box.values.toList();
  // }

  static Future<void> clearData() async {
    final box = await Hive.openBox<NameModel>('name_list');
    await box.clear();
    await box.close();
  }
}
