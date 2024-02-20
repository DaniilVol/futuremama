import 'dart:convert';
import 'package:futuremama/model/name_model.dart';
import 'package:futuremama/services/name_hive.dart';
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


// class FirestoreService {
//   final String projectId = 'YOUR_PROJECT_ID';
//   final String collectionPath = 'YOUR_COLLECTION_PATH';
//   final String apiKey = 'YOUR_API_KEY';
//   final String apiUrl = 'https://firestore.googleapis.com/v1/projects';

//   Future<Map<String, dynamic>> getData(String documentId) async {
//     final response = await http.get(Uri.parse('$apiUrl/$projectId/databases/(default)/documents/$collectionPath/$documentId?key=$apiKey'));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = json.decode(response.body);
//       return data;
//     } else {
//       throw Exception('Failed to load data from Firestore');
//     }
//   }
// }