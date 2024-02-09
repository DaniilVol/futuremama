import 'package:futuremama/model/counter_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class CounterHive {
  static late Box _box;

  static Future<void> initHive() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter(CounterModelAdapter());
    _box = await Hive.openBox('fight_results');
  }

  static Box get box => _box;

  static List<CounterModel> getAllFightResults() {
    return _box.values.toList().cast<CounterModel>();
  }

  static void addFightResult(CounterModel result) {
    _box.add(result);
  }
}

class CounterModelAdapter extends TypeAdapter<CounterModel> {
  @override
  final int typeId = 1;

  @override
  CounterModel read(BinaryReader reader) {
    return CounterModel(
      currentTime: DateTime.parse(reader.read()),
      duration: Duration(seconds: reader.read()),
      timeSinceLastFight: Duration(seconds: reader.read()),
    );
  }

  @override
  void write(BinaryWriter writer, CounterModel obj) {
    writer.write(obj.currentTime.toIso8601String());
    writer.write(obj.duration.inSeconds);
    writer.write(obj.timeSinceLastFight.inSeconds);
  }
}
