import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class NameModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool isFavorite;

  NameModel(this.name, {this.isFavorite = false});
}
