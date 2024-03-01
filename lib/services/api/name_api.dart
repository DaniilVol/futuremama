import 'dart:convert';
import 'package:futuremama/model/name_model.dart';
import 'package:http/http.dart' as http;

class NameApi {
  // final String projectId = "futuremama-app";
  // final String privateKeyId = "c8544b8eaa93bee4038cc05a34513386c183ca69";
  // final String collection = 'name_boy';
  // final String document = 'tfkEjkmFzmH4XpdMkR4i';

  static Future<List<NameModel>> getData() async {
    const url =
        'https://firestore.googleapis.com/v1/projects/futuremama-app/databases/(default)/documents/name_list/uemaj5vELwWjwFCUGoMQ?key=c8544b8eaa93bee4038cc05a34513386c183ca69';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> fields = data['fields'];

      final List<NameModel> result = [];

      fields.forEach((key, value) {
        if (value['arrayValue'] != null) {
          final List<dynamic> names = value['arrayValue']['values'];

          names.forEach((nameData) {
            result.add(NameModel(
              gender: key == "Девочка" ? "Девочка" : "Мальчик",
              name: nameData['stringValue'],
              favorite: false,
            ));
          });
        }
      });

      return result;
    } else {
      throw Exception('Ошибка загрузки');
    }
  }
}
