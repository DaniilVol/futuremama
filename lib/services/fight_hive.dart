import 'package:futuremama/model/fight_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FightHive {
  static Future<void> saveResults(List<FightModel> results) async {
    final box = await Hive.openBox<FightModel>('fight_results');
    await box.clear();
    await box.addAll(results);
    await box.close();
  }

  static Future<List<FightModel>> loadResults() async {
    final box = await Hive.openBox<FightModel>('fight_results');
    final List<FightModel> savedResults = box.values.toList();
    await box.close();
    return savedResults.reversed.toList();
  }

  static Future<void> addResults(FightModel fight) async {
    final box = await Hive.openBox<FightModel>('fight_results');
    await box.add(fight);
    await box.close();
  }

  static Future<void> removeResult(FightModel fight) async {
    final box = await Hive.openBox<FightModel>('fight_results');
    final List<FightModel> savedResults = box.values.toList();
    savedResults.remove(fight);
    await box.clear();
    await box.addAll(savedResults);
    await box.close();
  }

  // КАК УДАЛИТЬ ЭЛЕМЕНТ ИЗ HIVE НЕ ПРИБЕГАЯ К МЕТОДУ ПОЛНОЙ ЕГО ОЧИСТКИ
  // пытался найти и по хэшкоду и по ключам, находит, но не удалял

  // static Future<void> removeResults(FightResult results) async {
  //   final box = await Hive.openBox<FightResult>('fight_results');
  // final int hashCode = results.hashCode;
  // await box.delete(hashCode);
  //   await box.close();
  // }

  static Future<void> removeAllResults() async {
    final box = await Hive.openBox<FightModel>('fight_results');
    await box.clear();
    await box.close();
  }
}
