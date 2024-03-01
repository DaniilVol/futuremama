import 'package:futuremama/model/todo_list_model.dart';
import 'package:futuremama/services/api/shopping_list_api.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoListHive {
// КАК СДЕЛАТЬ ЧТОБЫ ДАННЫЕ ГРУЗИЛИСЬ ОДИН РАЗ  ???

  // загрузка данных из HIVE для СПИСКА ПОКУПОК
  static Future<List<TodoListModel>> loadDataShopping() async {
    final box = await Hive.openBox<TodoListModel>('shopping_list');

    if (box.isEmpty) {
      List<TodoListModel> results = await ShoppingListApi.getDataShopping();
      for (var todo in results) {
        await box.add(todo);
      }
      return results;
    } else {
      final List<TodoListModel> shoppingList = box.values.toList();
      return shoppingList;
    }
  }

// очищаем оба бокса Покупки и Дела
  static Future<void> clearAll() async {
    final box1 = await Hive.openBox<TodoListModel>('need_todo_list');
    final box2 = await Hive.openBox<TodoListModel>('shopping_list');
    await box1.clear();
    await box2.clear();
    await box1.close();
    await box2.close();
  }

  // загрузка данных из HIVE для СПИСКА ДЕЛ
  static Future<List<TodoListModel>> loadDataNeedTodo() async {
    final box = await Hive.openBox<TodoListModel>('need_todo_list');

    try {
      if (box.isEmpty) {
        List<TodoListModel> results = await ShoppingListApi.getDataNeedTodo();
        for (var todo in results) {
          await box.add(todo);
        }
        return results;
      } else {
        final List<TodoListModel> shoppingList = box.values.toList();
        return shoppingList;
      }
    } finally {
      // await box.close();
    }
  }
}
