import 'package:flutter/material.dart';
import 'package:futuremama/model/todo_list_model.dart';
import 'package:futuremama/services/hive/todo_list_hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ShoppingListView extends StatefulWidget {
  const ShoppingListView({Key? key}) : super(key: key);

  @override
  _ShoppingListViewState createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  Map<String, List<TodoListModel>> _categoryLists = {};
  Map<String, bool> _isExpanded = {};
  late Box<TodoListModel> todoBox;
  late String taskAlertDialog;
  late String categoryAlertDialog;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  void dispose() async {
    super.dispose();
    await todoBox.close();
  }

  Future<void> loadData() async {
    List<TodoListModel> data = await TodoListHive.loadDataShopping();
    todoBox = Hive.box<TodoListModel>('shopping_list');
    setState(() {
      _categoryLists = categorizeData(data);
      _isExpanded = Map.fromIterable(_categoryLists.keys, value: (_) => false);
    });
  }

  Map<String, List<TodoListModel>> categorizeData(List<TodoListModel> data) {
    Map<String, List<TodoListModel>> categorizedData = {};

    for (var todo in data) {
      if (!categorizedData.containsKey(todo.category)) {
        categorizedData[todo.category] = [];
      }
      categorizedData[todo.category]?.add(todo);
    }
    return categorizedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await todoBox.clear();
              loadData();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Список покупок удален')));
            },
          ),
        ],
        title: const Text('Список покупок'),
      ),
      body: _categoryLists.isEmpty
          ? const Center(child: Text("Список пуст"))
          : ListView.builder(
              itemCount: _categoryLists.length,
              itemBuilder: (context, index) {
                String category = _categoryLists.keys.toList()[index];
                List<TodoListModel> categoryList = _categoryLists[category]!;
                bool isExpanded = _isExpanded[category] ?? false;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded[category] = !isExpanded;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_right,
                            ),
                            Text(
                              category,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isExpanded)
                      ListView.builder(
                        itemCount: categoryList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          TodoListModel todo = categoryList[index];

                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            key: UniqueKey(),
                            onDismissed: (direction) async {
                              int todoTask = todoBox.values.toList().indexWhere(
                                    (element) =>
                                        element.task == todo.task &&
                                        element.id == todo.id,
                                  );

                              if (todoTask != -1) {
                                await todoBox.deleteAt(todoTask);
                                setState(() {
                                  _categoryLists[category]!.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('${todo.task} - удалено')));
                              }
                            },
                            child: ListTile(
                              title: Text(
                                todo.task,
                                style: TextStyle(
                                  decoration: todo.complete
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              leading: todo.complete
                                  ? const Icon(Icons.check_box)
                                  : const Icon(Icons.check_box_outline_blank),
                              onTap: () async {
                                setState(() {
                                  todo.complete = !todo.complete;
                                });

                                int todoTask =
                                    todoBox.values.toList().indexWhere(
                                          (element) =>
                                              element.task == todo.task &&
                                              element.id == todo.id,
                                        );

                                if (todoTask != -1) {
                                  await todoBox.putAt(todoTask, todo);
                                }
                              },
                            ),
                          );
                        },
                      ),
                  ],
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
      title: const Text('Добавление покупки'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            initialValue: '',
            decoration: const InputDecoration(
              labelText: 'Категория',
            ),
            onChanged: (value) {
              setState(() {
                categoryAlertDialog = value;
              });
            },
          ),
          TextFormField(
            autofocus: true,
            initialValue: '',
            decoration: const InputDecoration(
              labelText: 'Купить:',
            ),
            onChanged: (value) {
              setState(() {
                taskAlertDialog = value;
              });
            },
            validator: (val) {
              return (val?.trim().isEmpty ?? true)
                  ? 'Купить не может быть пустым'
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
                  child: const Text('Отменить'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              const SizedBox(
                width: 16,
              ),
              ElevatedButton(
                onPressed: _validateAndSave,
                child: const Text('Добавить'),
              ),
            ],
          )),
        ],
      ),
    );
  }

  void _validateAndSave() async {
    if (taskAlertDialog.isNotEmpty && categoryAlertDialog.isNotEmpty) {
      // Проверяем на пустоту
      TodoListModel newTodo = TodoListModel(
        complete: false,
        id: DateTime.now().millisecondsSinceEpoch,
        task: taskAlertDialog,
        category: categoryAlertDialog,
      );

      try {
        final Box<TodoListModel> todoBox =
            Hive.box<TodoListModel>('shopping_list');
        await todoBox.add(newTodo);
        print('Покупка добавлена');
      } catch (e) {
        print('Ошибка добавления: $e');
      }

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Необходимо заполнить все поля')));
    }
  }
}

// второй вариант с отдельным виджетом _AddTodo

// class ShoppingListView extends StatefulWidget {
//   const ShoppingListView({Key? key}) : super(key: key);

//   @override
//   _ShoppingListViewState createState() => _ShoppingListViewState();
// }

// class _ShoppingListViewState extends State<ShoppingListView> {
//   Map<String, List<TodoListModel>> _categoryLists = {};
//   Map<String, bool> _isExpanded = {};
//   late Box<TodoListModel> todoBox;

//   @override
//   void initState() {
//     super.initState();

//     loadData();
//   }

//   Future<void> loadData() async {
//     List<TodoListModel> data = await TodoListHive.loadDataShopping();
//     todoBox = Hive.box<TodoListModel>('shopping_list');
//     setState(() {
//       _categoryLists = categorizeData(data);
//       _isExpanded = Map.fromIterable(_categoryLists.keys, value: (_) => false);
//     });
//   }

//   Map<String, List<TodoListModel>> categorizeData(List<TodoListModel> data) {
//     Map<String, List<TodoListModel>> categorizedData = {};

//     for (var todo in data) {
//       if (!categorizedData.containsKey(todo.category)) {
//         categorizedData[todo.category] = [];
//       }

//       categorizedData[todo.category]?.add(todo);
//     }

//     return categorizedData;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () async {
//               await todoBox.clear();
//               loadData();
//               ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Список покупок удален')));
//             },
//           ),
//         ],
//         title: const Text('Список покупок'),
//       ),
//       body: _categoryLists.isEmpty
//           ? const Center(child: Text("Список пуст"))
//           : ListView.builder(
//               itemCount: _categoryLists.length,
//               itemBuilder: (context, index) {
//                 String category = _categoryLists.keys.toList()[index];
//                 List<TodoListModel> categoryList = _categoryLists[category]!;
//                 bool isExpanded = _isExpanded[category] ?? false;

//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _isExpanded[category] = !isExpanded;
//                         });
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: [
//                             Icon(
//                               isExpanded
//                                   ? Icons.keyboard_arrow_down
//                                   : Icons.keyboard_arrow_right,
//                             ),
//                             Text(
//                               category,
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     if (isExpanded)
//                       ListView.builder(
//                         itemCount: categoryList.length,
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemBuilder: (context, index) {
//                           TodoListModel todo = categoryList[index];

//                           return Dismissible(
//                             background: Container(color: Colors.red),
//                             key: UniqueKey(),
//                             onDismissed: (direction) async {
//                               int todoTask = todoBox.values.toList().indexWhere(
//                                     (element) =>
//                                         element.task == todo.task &&
//                                         element.id == todo.id,
//                                   );

//                               if (todoTask != -1) {
//                                 await todoBox.deleteAt(todoTask);
//                                 setState(() {
//                                   _categoryLists[category]!.removeAt(index);
//                                 });
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                         content:
//                                             Text('${todo.task} - удалено')));
//                               }
//                             },
//                             child: ListTile(
//                               title: Text(
//                                 todo.task ?? '',
//                                 style: TextStyle(
//                                   decoration: todo.complete
//                                       ? TextDecoration.lineThrough
//                                       : null,
//                                 ),
//                               ),
//                               leading: todo.complete
//                                   ? const Icon(Icons.check_box)
//                                   : const Icon(Icons.check_box_outline_blank),
//                               onTap: () async {
//                                 setState(() {
//                                   todo.complete = !todo.complete;
//                                 });

//                                 int todoTask =
//                                     todoBox.values.toList().indexWhere(
//                                           (element) =>
//                                               element.task == todo.task &&
//                                               element.id == todo.id,
//                                         );

//                                 if (todoTask != -1) {
//                                   await todoBox.putAt(todoTask, todo);
//                                 }
//                               },
//                             ),
//                           );
//                         },
//                       ),
//                   ],
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => _AddTodo(),
//           ));

//           // Обновляем данные после возвращения из AddTodo
//           loadData();
//         },
//         tooltip: 'Добавить',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class _AddTodo extends StatefulWidget {
//   const _AddTodo({super.key});

//   @override
//   _AddTodoState createState() => _AddTodoState();
// }

// class _AddTodoState extends State<_AddTodo> {
//   late String task = '';
//   late String category = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Form(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: AlertDialog(
//                 title: const Text('Добавление покупки'),
//                 content: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     TextFormField(
//                       initialValue: '',
//                       decoration: const InputDecoration(
//                         labelText: 'Категория',
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           category = value ?? '';
//                         });
//                       },
//                     ),
//                     TextFormField(
//                       autofocus: true,
//                       initialValue: '',
//                       decoration: const InputDecoration(
//                         labelText: 'Купить:',
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           task = value ?? '';
//                         });
//                       },
//                       validator: (val) {
//                         return (val?.trim()?.isEmpty ?? true)
//                             ? 'Купить не может быть пустым'
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
//     if (task.isNotEmpty && category.isNotEmpty) {
//       // Проверяем на пустоту
//       TodoListModel newTodo = TodoListModel(
//         complete: false,
//         id: DateTime.now().millisecondsSinceEpoch,
//         task: task,
//         category: category,
//       );

//       try {
//         final Box<TodoListModel> todoBox =
//             Hive.box<TodoListModel>('shopping_list');
//         await todoBox.add(newTodo);
//         print('Покупка добавлена');
//       } catch (e) {
//         print('Ошибка добавления: $e');
//       }

//       Navigator.of(context).pop();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Необходимо заполнить все поля')));
//     }
//   }
// }
