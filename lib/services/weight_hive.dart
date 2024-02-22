import 'package:futuremama/model/weight_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WeightHive {
  static Future<List<WeightModel>> loadWeight() async {
    final box = await Hive.openBox<WeightModel>('weight_results');
    final List<WeightModel> savedResults = box.values.toList();
    return savedResults;
  }

  static Future<void> addWeight(WeightModel weight) async {
    final box = await Hive.openBox<WeightModel>('weight_results');
    await box.add(weight);
    print(weight);
    await box.close();
  }

  static Future<void> deleteWeight(WeightModel weight) async {
    final box = await Hive.openBox<WeightModel>('weight_results');
    final List<WeightModel> savedResults = box.values.toList();
    savedResults.remove(weight);
    await box.clear();
    await box.addAll(savedResults);
    await box.close();
  }

  static Future<void> deleteAllWeight() async {
    final box = await Hive.openBox('weight_results');
    box.clear();
    box.close();
  }
}
