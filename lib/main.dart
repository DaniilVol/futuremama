import 'package:flutter/material.dart';
import 'package:futuremama/model/fight_model.dart';
import 'package:futuremama/model/name_model.dart';
import 'package:futuremama/model/todo_list_model.dart';
import 'package:futuremama/model/weight_model.dart';
import 'package:futuremama/view/futuremama_app.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<NameModel>(NameModelAdapter());
  Hive.registerAdapter<FightModel>(FightModelAdapter());
  Hive.registerAdapter<TodoListModel>(TodoListModelAdapter());
  Hive.registerAdapter<WeightModel>(WeightModelAdapter());

  runApp(const FuturemamaApp());
}
