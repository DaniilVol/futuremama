import 'dart:convert';
import 'package:futuremama/model/todo_list_model.dart';
import 'package:http/http.dart' as http;

class ShoppingListApi {
  // final String projectId = "futuremama-app";
  // final String privateKeyId = "c8544b8eaa93bee4038cc05a34513386c183ca69";
  // final String collection = 'shopping_list';
  // final String document = 'W2cW2vo9tjy4JbS3dg3J';

  static Future<List<TodoListModel>> getDataShopping() async {
    const url =
        'https://firestore.googleapis.com/v1/projects/futuremama-app/databases/(default)/documents/shopping_list/W2cW2vo9tjy4JbS3dg3J?key=c8544b8eaa93bee4038cc05a34513386c183ca69';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<TodoListModel> results = [];

      data['fields'].forEach((categoryKey, categoryValues) {
        if (categoryValues.containsKey('arrayValue')) {
          final List<dynamic> values = categoryValues['arrayValue']['values'];

          results.addAll(values.asMap().entries.map((entry) {
            final int index = DateTime.now().millisecondsSinceEpoch;
            final String task = entry.value['stringValue'];
            final String category = _getCategory(categoryKey);

            return TodoListModel(
              complete: false,
              id: index,
              task: task,
              category: category,
            );
          }));
        }
      });

      return results;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static String _getCategory(String key) {
    if (key == 'transport') {
      return 'Транспорт';
    } else if (key == 'room') {
      return 'Комната';
    } else {
      return key;
    }
  }

  static Future<List<TodoListModel>> getDataNeedTodo() async {
    const url =
        'https://firestore.googleapis.com/v1/projects/futuremama-app/databases/(default)/documents/need_todo_list/UQKxPhsY7XLBdwu1DHVZ?key=c8544b8eaa93bee4038cc05a34513386c183ca69';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final List<dynamic> values =
          data['fields']['default']['arrayValue']['values'];

      final List<TodoListModel> results = values.map((value) {
        return TodoListModel(
          complete: false,
          id: DateTime.now().millisecondsSinceEpoch,
          task: value['stringValue'],
          category: 'Список дел',
        );
      }).toList();

      return results;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
