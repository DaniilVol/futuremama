// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class WeightModel {
  final int weight;
  final DateTime currentTime;

  WeightModel({
    required this.weight,
    required this.currentTime,
  });

  WeightModel copyWith({
    int? weight,
    DateTime? currentTime,
  }) {
    return WeightModel(
      weight: weight ?? this.weight,
      currentTime: currentTime ?? this.currentTime,
    );
  }

  @override
  String toString() =>
      'WeightModel(weight: $weight, currentTime: $currentTime)';

  @override
  bool operator ==(covariant WeightModel other) {
    if (identical(this, other)) return true;

    return other.weight == weight && other.currentTime == currentTime;
  }

  @override
  int get hashCode => weight.hashCode ^ currentTime.hashCode;
}

class WeightModelAdapter extends TypeAdapter<WeightModel> {
  @override
  final int typeId = 2;

  @override
  WeightModel read(BinaryReader reader) {
    final currentTimeMillis = reader.readInt();
    final weight = reader.readInt();
    final currentTime = DateTime.fromMillisecondsSinceEpoch(currentTimeMillis);

    return WeightModel(weight: weight, currentTime: currentTime);
  }

  @override
  void write(BinaryWriter writer, WeightModel obj) {
    writer.writeInt(obj.weight);
    writer.writeInt(obj.currentTime.millisecondsSinceEpoch);
  }
}
