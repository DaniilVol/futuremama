import 'package:hive_flutter/hive_flutter.dart';

class NameModel extends HiveObject {
  String gender;
  String name;
  bool favorite;

  NameModel({required this.gender, required this.name, required this.favorite});
}

class NameModelAdapter extends TypeAdapter<NameModel> {
  @override
  final typeId = 0;

  @override
  NameModel read(BinaryReader reader) {
    final gender = reader.readString();
    final name = reader.readString();
    final favorite = reader.readBool();
    return NameModel(gender: gender, name: name, favorite: favorite);
  }

  @override
  void write(BinaryWriter writer, NameModel obj) {
    writer.writeString(obj.gender);
    writer.writeString(obj.name);
    writer.writeBool(obj.favorite);
  }
}
