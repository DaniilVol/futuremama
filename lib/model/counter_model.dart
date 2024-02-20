import 'package:hive_flutter/hive_flutter.dart';

class CounterModel {
  final DateTime currentTime;
  final Duration duration;
  final Duration timeSinceLastFight;

  CounterModel({
    required this.currentTime,
    required this.duration,
    required this.timeSinceLastFight,
  });
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
