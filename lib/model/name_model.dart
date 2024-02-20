import 'package:hive_flutter/hive_flutter.dart';

class NameModel {
  final int id;
  final String name;

  NameModel({required this.id, required this.name});
}

class NameModelAdapter extends TypeAdapter<NameModel> {
  @override
  final typeId = 0;

  @override
  NameModel read(BinaryReader reader) {
    final id = reader.readInt();
    final name = reader.readString();
    return NameModel(id: id, name: name);
  }

  @override
  void write(BinaryWriter writer, NameModel obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
  }
}
