// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoListModelAdapter extends TypeAdapter<TodoListModel> {
  @override
  final int typeId = 4;

  @override
  TodoListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoListModel(
      complete: fields[0] as bool,
      id: fields[1] as int,
      task: fields[2] as String,
      category: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TodoListModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.complete)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.task)
      ..writeByte(3)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
