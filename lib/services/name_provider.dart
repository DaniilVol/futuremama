import 'package:flutter/material.dart';
import 'package:futuremama/model/name_model.dart';
import 'package:futuremama/services/api/name_api.dart';
import 'package:futuremama/services/hive/name_hive.dart';

class NameProvider extends ChangeNotifier {
  List<NameModel> names = [];

  Future<void> getData() async {
    names = NameHive.loadData();
    if (names.isEmpty) {
      names = await NameApi().getData();
    }
    notifyListeners();
  }
}
