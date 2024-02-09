import 'dart:convert';
import 'package:http/http.dart' as http;

class NameApi {
//   final String projectId = 'YOUR_PROJECT_ID';
//   final String collectionPath = 'YOUR_COLLECTION_PATH';
//   final String apiKey = 'YOUR_API_KEY';
//   final String apiUrl = 'https://firestore.googleapis.com/v1/projects';
  static Future<List<String>> fetchNames() async {
    final response =
        await http.get(Uri.parse('https://your-api-endpoint/names'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load names');
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