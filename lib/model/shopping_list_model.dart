import 'package:hive_flutter/hive_flutter.dart';

class ShoppingListModel {
  final List<dynamic> shoppingList;

  ShoppingListModel({required this.shoppingList});
}

class ShoppingListModelAdapter extends TypeAdapter<ShoppingListModel> {
  @override
  final typeId = 3;

  @override
  ShoppingListModel read(BinaryReader reader) {
    final shoppingList = reader.readList();
    return ShoppingListModel(shoppingList: shoppingList);
  }

  @override
  void write(BinaryWriter writer, ShoppingListModel obj) {
    writer.writeList(obj.shoppingList);
  }
}
