import 'package:hive/hive.dart';

part 'list_todo_model.g.dart';

@HiveType(typeId: 4)
class Todo extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  bool complete;
  @HiveField(2)
  String task;
  Todo({this.id, this.complete = false, required this.task});
}
