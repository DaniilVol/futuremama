import 'package:flutter/material.dart';
import 'package:futuremama/model/name_model.dart';
import 'package:futuremama/services/name_api.dart';
import 'package:futuremama/services/name_hive.dart';

class NameProvider extends ChangeNotifier {
  List<NameModel> names = [];

  Future<void> fetchData() async {
    names = NameHive.loadData();
    if (names.isEmpty) {
      names = await NameApi().getData();
    }
    notifyListeners();
  }
}