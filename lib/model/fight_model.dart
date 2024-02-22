import 'package:hive_flutter/hive_flutter.dart';

class FightModel {
  final DateTime currentTime;
  final Duration duration;
  final Duration timeSinceLastFight;

  FightModel({
    required this.currentTime,
    required this.duration,
    required this.timeSinceLastFight,
  });

  FightModel copyWith({
    DateTime? currentTime,
    Duration? duration,
    Duration? timeSinceLastFight,
  }) {
    return FightModel(
      currentTime: currentTime ?? this.currentTime,
      duration: duration ?? this.duration,
      timeSinceLastFight: timeSinceLastFight ?? this.timeSinceLastFight,
    );
  }

  @override
  String toString() =>
      'FightResult(currentTime: $currentTime, duration: $duration, timeSinceLastFight: $timeSinceLastFight)';

  @override
  bool operator ==(covariant FightModel other) {
    if (identical(this, other)) return true;

    return other.currentTime == currentTime &&
        other.duration == duration &&
        other.timeSinceLastFight == timeSinceLastFight;
  }

  @override
  int get hashCode =>
      currentTime.hashCode ^ duration.hashCode ^ timeSinceLastFight.hashCode;
}

class FightModelAdapter extends TypeAdapter<FightModel> {
  @override
  final int typeId = 1;

  @override
  FightModel read(BinaryReader reader) {
    final currentTimeMillis = reader
        .readInt(); // Используем readInt для записи времени в миллисекундах
    final durationMillis = reader.readInt();
    final timeSinceLastFightMillis = reader.readInt();

    final currentTime = DateTime.fromMillisecondsSinceEpoch(currentTimeMillis);
    final duration = Duration(milliseconds: durationMillis);
    final timeSinceLastFight = Duration(milliseconds: timeSinceLastFightMillis);

    return FightModel(
      currentTime: currentTime,
      duration: duration,
      timeSinceLastFight: timeSinceLastFight,
    );
  }

  @override
  void write(BinaryWriter writer, FightModel obj) {
    writer.writeInt(obj.currentTime.millisecondsSinceEpoch);
    writer.writeInt(obj.duration.inMilliseconds);
    writer.writeInt(obj.timeSinceLastFight.inMilliseconds);
  }
}
