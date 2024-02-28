import 'dart:convert';
import 'package:http/http.dart' as http;

class ShoppingListApi {
  final String projectId = "futuremama-app";
  final String privateKeyId = "c8544b8eaa93bee4038cc05a34513386c183ca69";
  final String collection = 'shopping_list';
  final String document = 'W2cW2vo9tjy4JbS3dg3J';

  static Future<List<String>> getData() async {
    // final url =
    //     'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$collection/$document?key=$privateKeyId';
    const url =
        'https://firestore.googleapis.com/v1/projects/futuremama-app/databases/(default)/documents/shopping_list/W2cW2vo9tjy4JbS3dg3J?key=c8544b8eaa93bee4038cc05a34513386c183ca69';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> values =
          data['fields']['room']['arrayValue']['values'];
      final List<String> results =
          values.map((value) => value['stringValue'] as String).toList();

      // ShoppingListModel shoppingListModel =
      //     ShoppingListModel(shoppingList: results);
      // ShoppingListHive.saveData(shoppingListModel);
      return results; //ShoppingListModel(shoppingList: results);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<String>> loadDataToHive() async {
    final results = await getData();
    return results;
    // ShoppingListModel shoppingListModel =
    //     ShoppingListModel(shoppingList: results);
    // ShoppingListHive.saveData(shoppingListModel);
  }
}
