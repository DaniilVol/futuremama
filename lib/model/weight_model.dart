// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/hive_flutter.dart';

class WeightModel {
  final int weight;
  final DateTime currentTime;
  final int weeks;

  WeightModel({
    required this.weight,
    required this.currentTime,
    required this.weeks,
  });

  WeightModel copyWith({
    int? weight,
    DateTime? currentTime,
    int? weeks,
  }) {
    return WeightModel(
      weight: weight ?? this.weight,
      currentTime: currentTime ?? this.currentTime,
      weeks: weeks ?? this.weeks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'weight': weight,
      'currentTime': currentTime.millisecondsSinceEpoch,
      'week': weeks,
    };
  }

  @override
  String toString() =>
      'WeightModel(weight: $weight, currentTime: $currentTime, week: $weeks)';

  @override
  bool operator ==(covariant WeightModel other) {
    if (identical(this, other)) return true;

    return other.weight == weight &&
        other.currentTime == currentTime &&
        other.weeks == weeks;
  }

  @override
  int get hashCode => weight.hashCode ^ currentTime.hashCode ^ weeks.hashCode;
}

class WeightModelAdapter extends TypeAdapter<WeightModel> {
  @override
  final int typeId = 2;

  @override
  WeightModel read(BinaryReader reader) {
    final weight = reader.readInt();
    final currentTimeMillis = reader.readInt();
    final currentTime = DateTime.fromMillisecondsSinceEpoch(currentTimeMillis);
    final weeks = reader.readInt();

    return WeightModel(weight: weight, currentTime: currentTime, weeks: weeks);
  }

  @override
  void write(BinaryWriter writer, WeightModel obj) {
    writer.writeInt(obj.weight);
    writer.writeInt(obj.currentTime.millisecondsSinceEpoch);
    writer.writeInt(obj.weeks);
  }
}
