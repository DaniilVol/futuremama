import 'package:futuremama/model/shopping_list_model.dart';
import 'package:futuremama/services/api/shopping_list_api.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ShoppingListHive {
  static Future<void> saveData(ShoppingListModel shoppingListModel) async {
    final box = await Hive.openBox<ShoppingListModel>('shopping_list');
    await box.clear();
    await box.add(shoppingListModel);
    await box.close();
  }

  static Future<List<String>> loadData() async {
    final box = await Hive.openBox<ShoppingListModel>('shopping_list');
    if (box.values.isEmpty) {
      final results = await ShoppingListApi.getData();
      await box.add(ShoppingListModel(shoppingList: results));
      await box.close();
      return results;
    } else {
      final shoppingList = box.values.first;
      await box.close();
      final results = shoppingList.shoppingList.cast<String>().toList();
      return results;
    }
  }

  static Future<void> deleteData(String string) async {
    final box = await Hive.openBox<ShoppingListModel>('shopping_list');
    final boxShoppingList = box.values.toList();
    boxShoppingList.removeWhere((item) => item.shoppingList.contains(string));
    await box.clear();
    await box.addAll(boxShoppingList);
    await box.close();
  }

  static Future<void> deleteAllData() async {
    final box = await Hive.openBox<ShoppingListModel>('shopping_list');
    await box.clear();
    await box.close();
  }

  static Future<void> addData(String string) async {
    final box = await Hive.openBox<ShoppingListModel>('shopping_list');
    final boxShoppingList = box.values.toList();

    // проверка элемента в списке
    if (!boxShoppingList.any((item) => item.shoppingList.contains(string))) {
      boxShoppingList.add(ShoppingListModel(shoppingList: [string]));
      await box.clear();
      await box.addAll(boxShoppingList);
    }
    await box.close();
  }
}

// class ShoppingListHive {
//   static const String boxShoppingList = 'shopping_list';

//   static Future<void> saveData(Map<String, List<String>> data) async {
//     final box = await Hive.openBox<Map<String, List<String>>>(boxShoppingList);

//     try {
//       await box.clear();
//       await box.add(data);
//     } finally {
//       await box.close();
//     }
//   }

//   static Map<String, List<String>> loadData() {
//     final box = Hive.box<Map<String, List<String>>>(boxShoppingList);
//     return box.getAt(0) ?? {};
//   }

//   static Future<void> addItem(String key, String value) async {
//     final box = await Hive.openBox<Map<String, List<String>>>(boxShoppingList);
//     final Map<String, List<String>> currentData = box.getAt(0) ?? {};

//     if (currentData.containsKey(key)) {
//       currentData[key]!.add(value);
//     } else {
//       currentData[key] = [value];
//     }

//     try {
//       await box.clear();
//       await box.add(currentData);
//     } finally {
//       await box.close();
//     }
//   }

//   static Future<void> removeItem(String key, String value) async {
//     final box = await Hive.openBox<Map<String, List<String>>>(boxShoppingList);
//     final Map<String, List<String>> currentData = box.getAt(0) ?? {};

//     if (currentData.containsKey(key)) {
//       currentData[key]!.remove(value);

//       try {
//         await box.clear();
//         await box.add(currentData);
//       } finally {
//         await box.close();
//       }
//     }
//   }

//   static Future<void> removeAllItems() async {
//     final box = await Hive.openBox<Map<String, List<String>>>(boxShoppingList);

//     try {
//       await box.clear();
//     } finally {
//       await box.close();
//     }
//   }
// }
