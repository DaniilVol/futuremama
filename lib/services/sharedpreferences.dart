import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<bool> checkFirstDayLastM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? date = prefs.getString('dateFirstDayLastMKey');
    return date == null;
  }

  static Future<void> saveStartDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("dateFirstDayLastMKey", date.toLocal().toString());
  }

  static Future<DateTime?> loadStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDate = prefs.getString("dateFirstDayLastMKey");

    if (storedDate != null) {
      return DateTime.parse(storedDate);
    }

    return null;
    //DateTime.now();
  }

  static Future<void> deleteStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("dateFirstDayLastMKey");
  }
}
