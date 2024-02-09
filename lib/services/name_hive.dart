import 'package:futuremama/model/name_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class NameHive {
  static late Box _box;

  static Future<void> initHive() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter(NameModelAdapter());
    _box = await Hive.openBox('names');
  }

  static Box get box => _box;

  static List<NameModel> getAllNames() {
    return _box.values.toList().cast<NameModel>();
  }

  static void addName(NameModel name) {
    _box.add(name);
  }

  static void updateName(NameModel name) {
    _box.putAt(_box.keys.toList().indexOf(name.key), name);
  }
}

class NameModelAdapter extends TypeAdapter<NameModel> {
  @override
  final int typeId = 0;

  @override
  NameModel read(BinaryReader reader) {
    return NameModel(reader.read(), isFavorite: reader.read());
  }

  @override
  void write(BinaryWriter writer, NameModel obj) {
    writer.write(obj.name);
    writer.write(obj.isFavorite);
  }
}
