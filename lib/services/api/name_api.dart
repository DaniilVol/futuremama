import 'dart:convert';
import 'package:futuremama/model/name_model.dart';
import 'package:futuremama/services/hive/name_hive.dart';
import 'package:http/http.dart' as http;

class NameApi {
  final String projectId = "futuremama-app";
  final String privateKeyId = "c8544b8eaa93bee4038cc05a34513386c183ca69";
  final String collection = 'name_boy';
  final String document = 'tfkEjkmFzmH4XpdMkR4i';

  Future<List<NameModel>> getData() async {
    final url =
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$collection/$document?key=$privateKeyId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final fields = data['fields']['name']['mapValue']['fields'];

      final List<NameModel> result = [];
      fields.forEach((key, value) {
        result.add(NameModel(id: int.parse(key), name: value['stringValue']));
      });

      NameHive.saveData(result);
      return result;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
