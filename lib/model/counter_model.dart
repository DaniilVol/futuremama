import 'package:hive_flutter/hive_flutter.dart';

class FightResult {
  final DateTime currentTime;
  final Duration duration;
  final Duration timeSinceLastFight;

  FightResult({
    required this.currentTime,
    required this.duration,
    required this.timeSinceLastFight,
  });

  FightResult copyWith({
    DateTime? currentTime,
    Duration? duration,
    Duration? timeSinceLastFight,
  }) {
    return FightResult(
      currentTime: currentTime ?? this.currentTime,
      duration: duration ?? this.duration,
      timeSinceLastFight: timeSinceLastFight ?? this.timeSinceLastFight,
    );
  }

  @override
  String toString() =>
      'FightResult(currentTime: $currentTime, duration: $duration, timeSinceLastFight: $timeSinceLastFight)';

  @override
  bool operator ==(covariant FightResult other) {
    if (identical(this, other)) return true;

    return other.currentTime == currentTime &&
        other.duration == duration &&
        other.timeSinceLastFight == timeSinceLastFight;
  }

  @override
  int get hashCode =>
      currentTime.hashCode ^ duration.hashCode ^ timeSinceLastFight.hashCode;
}

class FightResultAdapter extends TypeAdapter<FightResult> {
  @override
  final int typeId = 1;

  @override
  FightResult read(BinaryReader reader) {
    final currentTimeMillis = reader
        .readInt(); // Используем readInt для записи времени в миллисекундах
    final durationMillis = reader.readInt();
    final timeSinceLastFightMillis = reader.readInt();

    final currentTime = DateTime.fromMillisecondsSinceEpoch(currentTimeMillis);
    final duration = Duration(milliseconds: durationMillis);
    final timeSinceLastFight = Duration(milliseconds: timeSinceLastFightMillis);

    return FightResult(
      currentTime: currentTime,
      duration: duration,
      timeSinceLastFight: timeSinceLastFight,
    );
  }

  @override
  void write(BinaryWriter writer, FightResult obj) {
    writer.writeInt(obj.currentTime.millisecondsSinceEpoch);
    writer.writeInt(obj.duration.inMilliseconds);
    writer.writeInt(obj.timeSinceLastFight.inMilliseconds);
  }
}
