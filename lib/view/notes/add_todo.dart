import 'package:flutter/material.dart';
import 'package:futuremama/model/list_todo_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  AddTodoState createState() => AddTodoState();
}

class AddTodoState extends State<AddTodo> {
  late String task;
  late String note;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    initialValue: '',
                    decoration: const InputDecoration(
                      labelText: 'Task',
                    ),
                    onChanged: (value) {
                      setState(() {
                        task = value;
                      });
                    },
                    validator: (val) {
                      return val!.trim().isEmpty
                          ? 'Task name should not be empty'
                          : null;
                    },
                  ),
                  ElevatedButton(
                    child: Text('Add'),
                    onPressed: _validateAndSave,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      _onFormSubmit();
    } else {
      print('form is invalid');
    }
  }

  void _onFormSubmit() async {
    // Box<Todo> contactsBox = Hive.box<Todo>('HiveBoxesToDo');
    final box = await Hive.openBox<Todo>('HiveBoxesToDo');
    await box.add(Todo(task: task));
    box.close();
    Navigator.of(context).pop();
  }
}
