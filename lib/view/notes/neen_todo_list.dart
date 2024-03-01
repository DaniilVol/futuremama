import 'package:flutter/material.dart';
import 'package:futuremama/model/todo_list_model.dart';
import 'package:futuremama/services/hive/todo_list_hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NeedTodoListView extends StatefulWidget {
  const NeedTodoListView({super.key});

  @override
  _NeedTodoListViewState createState() => _NeedTodoListViewState();
}

class _NeedTodoListViewState extends State<NeedTodoListView> {
  List<TodoListModel> _todoList = [];
  late String task;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<TodoListModel> data = await TodoListHive.loadDataNeedTodo();
    setState(() {
      _todoList = data;
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await Hive.box<TodoListModel>('need_todo_list').close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список дел'),
      ),
      body: _todoList.isEmpty
          ? const Center(child: Text("Список пуст"))
          : ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                TodoListModel todo = _todoList[index];
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  key: UniqueKey(),
                  onDismissed: (direction) async {
                    await Hive.box<TodoListModel>('need_todo_list')
                        .deleteAt(index);
                    setState(() {
                      _todoList.removeAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${todo.task} - удалено')));
                    });
                  },
                  child: ListTile(
                    title: Text(
                      todo.task ?? '',
                      style: TextStyle(
                        decoration:
                            todo.complete ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    leading: todo.complete
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                    onTap: () async {
                      setState(() {
                        todo.complete = !todo.complete;
                      });
                      await Hive.box<TodoListModel>('need_todo_list')
                          .putAt(index, todo);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => _addTodo(),
          );
          loadData();
        },
        tooltip: 'Добавить',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _addTodo() {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      title: const Text('Добавление дел'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            initialValue: '',
            decoration: const InputDecoration(
              labelText: 'Сделать:',
            ),
            onChanged: (value) {
              setState(() {
                task = value ?? '';
              });
            },
            validator: (val) {
              return (val?.trim()?.isEmpty ?? true)
                  ? 'Сделать не может быть пустым'
                  : null;
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
              child: Row(
            children: [
              ElevatedButton(
                  child: Text('Отменить'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              SizedBox(
                width: 16,
              ),
              ElevatedButton(
                child: Text('Добавить'),
                onPressed: _validateAndSave,
              ),
            ],
          )),
        ],
      ),
    );
  }

  void _validateAndSave() async {
    if (task != null) {
      TodoListModel newTodo = TodoListModel(
        complete: false,
        id: DateTime.now().millisecondsSinceEpoch,
        task: task,
        category: 'Список дел',
      );

      try {
        final Box<TodoListModel> todoBox =
            Hive.box<TodoListModel>('need_todo_list');
        await todoBox.add(newTodo);
        print('покупка добавлена');
      } catch (e) {
        print('Ошибка добавления: $e');
      }

      Navigator.of(context).pop();
    }
  }
}


// второй вариант с отдельным виджетом _AddTodo

// class NeedTodoListView extends StatefulWidget {
//   const NeedTodoListView({super.key});

//   @override
//   _NeedTodoListViewState createState() => _NeedTodoListViewState();
// }

// class _NeedTodoListViewState extends State<NeedTodoListView> {
//   List<TodoListModel> _todoList = [];

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   Future<void> loadData() async {
//     List<TodoListModel> data = await TodoListHive.loadDataNeedTodo();
//     setState(() {
//       _todoList = data;
//     });
//   }

//   @override
//   void dispose() async {
//     super.dispose();
//     await Hive.box<TodoListModel>('need_todo_list').close();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Список дел'),
//       ),
//       body: _todoList.isEmpty
//           ? const Center(child: Text("Список пуст"))
//           : ListView.builder(
//               itemCount: _todoList.length,
//               itemBuilder: (context, index) {
//                 TodoListModel todo = _todoList[index];
//                 return Dismissible(
//                   background: Container(color: Colors.red),
//                   key: UniqueKey(),
//                   onDismissed: (direction) async {
//                     await Hive.box<TodoListModel>('need_todo_list')
//                         .deleteAt(index);
//                     setState(() {
//                       _todoList.removeAt(index);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('${todo.task} - удалено')));
//                     });
//                   },
//                   child: ListTile(
//                     title: Text(
//                       todo.task ?? '',
//                       style: TextStyle(
//                         decoration:
//                             todo.complete ? TextDecoration.lineThrough : null,
//                       ),
//                     ),
//                     leading: todo.complete
//                         ? const Icon(Icons.check_box)
//                         : const Icon(Icons.check_box_outline_blank),
//                     onTap: () async {
//                       setState(() {
//                         todo.complete = !todo.complete;
//                       });
//                       await Hive.box<TodoListModel>('need_todo_list')
//                           .putAt(index, todo);
//                     },
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => _AddTodo(),
//           ));
//           loadData();
//         },
//         tooltip: 'Добавить',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class _AddTodo extends StatefulWidget {
//   @override
//   _AddTodoState createState() => _AddTodoState();
// }

// class _AddTodoState extends State<_AddTodo> {
//   late String task;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Form(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: AlertDialog(
//                 title: const Text('Добавление дел'),
//                 content: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     TextFormField(
//                       autofocus: true,
//                       initialValue: '',
//                       decoration: const InputDecoration(
//                         labelText: 'Сделать:',
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           task = value ?? '';
//                         });
//                       },
//                       validator: (val) {
//                         return (val?.trim()?.isEmpty ?? true)
//                             ? 'Сделать не может быть пустым'
//                             : null;
//                       },
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     Center(
//                         child: Row(
//                       children: [
//                         ElevatedButton(
//                             child: Text('Отменить'),
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             }),
//                         SizedBox(
//                           width: 16,
//                         ),
//                         ElevatedButton(
//                           child: Text('Добавить'),
//                           onPressed: _validateAndSave,
//                         ),
//                       ],
//                     )),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _validateAndSave() async {
//     if (task != null) {
//       TodoListModel newTodo = TodoListModel(
//         complete: false,
//         id: DateTime.now().millisecondsSinceEpoch,
//         task: task,
//         category: 'Список дел',
//       );

//       try {
//         final Box<TodoListModel> todoBox =
//             Hive.box<TodoListModel>('need_todo_list');
//         await todoBox.add(newTodo);
//         print('покупка добавлена');
//       } catch (e) {
//         print('Ошибка добавления: $e');
//       }

//       Navigator.of(context).pop();
//     }
//   }
// }
