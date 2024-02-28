import 'package:flutter/material.dart';
import 'package:futuremama/model/list_todo_model.dart';
import 'package:futuremama/view/notes/add_todo.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ShoppingTodoView extends StatefulWidget {
  const ShoppingTodoView({Key? key}) : super(key: key);

  @override
  State<ShoppingTodoView> createState() => _ShoppingTodoViewState();
}

class _ShoppingTodoViewState extends State<ShoppingTodoView> {
  late Future<Box<Todo>> _boxFuture;

  @override
  void initState() {
    super.initState();
    _boxFuture = _initializeHive();
  }

  Future<Box<Todo>> _initializeHive() async {
    await Hive.openBox<Todo>('HiveBoxesToDo');
    return Hive.box<Todo>('HiveBoxesToDo');
  }

  // if (box.isEmpty) {
  //   try {
  //     List<Todo> data = await ShoppingListApi.getData();
  //     box.addAll(data);
  //   } catch (error) {
  //     print('Error loading data: $error');
  //   }
  // }
  // }

  void dispose() async {
    await Hive.box<Todo>('HiveBoxesToDo').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список покупок'),
      ),
      body: FutureBuilder(
        future: _boxFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Box<Todo> box = snapshot.data as Box<Todo>;
            if (box.values.isEmpty) {
              return Center(
                child: Text("Todo list is empty"),
              );
            }
            return ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<Todo> box, _) {
                return ListView.builder(
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    Todo res = box.getAt(index)!;
                    return Dismissible(
                      background: Container(color: Colors.red),
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        res.delete();
                      },
                      child: ListTile(
                        title: Text(res.task),
                        leading: res.complete
                            ? Icon(Icons.check_box)
                            : Icon(Icons.check_box_outline_blank),
                        onTap: () {
                          res.complete = !res.complete;
                          res.save();
                        },
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddTodo())),
        tooltip: 'Add todo',
        child: Icon(Icons.add),
      ),
    );
  }
}
