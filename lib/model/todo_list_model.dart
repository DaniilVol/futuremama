import 'package:hive_flutter/hive_flutter.dart';

part 'todo_list_model.g.dart';

@HiveType(typeId: 4)
class TodoListModel extends HiveObject {
  @HiveField(0)
  bool complete;
  @HiveField(1)
  int id;
  @HiveField(2)
  String task;
  @HiveField(3)
  String category;
  TodoListModel(
      {required this.complete,
      required this.id,
      required this.task,
      required this.category});

  TodoListModel copyWith({
    bool? complete,
    int? id,
    String? task,
    String? category,
  }) {
    return TodoListModel(
      complete: complete ?? this.complete,
      id: id ?? this.id,
      task: task ?? this.task,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'TodoListModel(complete: $complete, id: $id, task: $task, category: $category)';
  }

  @override
  bool operator ==(covariant TodoListModel other) {
    if (identical(this, other)) return true;

    return other.complete == complete &&
        other.id == id &&
        other.task == task &&
        other.category == category;
  }

  @override
  int get hashCode {
    return complete.hashCode ^ id.hashCode ^ task.hashCode ^ category.hashCode;
  }
}
