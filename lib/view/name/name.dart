import 'package:flutter/material.dart';
import 'package:futuremama/model/name_model.dart';
import 'package:futuremama/services/hive/name_hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NameView extends StatefulWidget {
  const NameView({Key? key}) : super(key: key);

  @override
  _NameViewState createState() => _NameViewState();
}

class _NameViewState extends State<NameView> {
  late Box<NameModel> nameBox;
  late String nameAlertDialog;
  String selectedGender = "Мальчик";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<NameModel> data = await NameHive.loadData();
    nameBox = Hive.box<NameModel>('name_list');
    setState(() {});
  }

  @override
  void dispose() async {
    super.dispose();
    await nameBox.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: selectedGender == "Мальчик"
                ? const Icon(
                    Icons.boy,
                    color: Color.fromARGB(255, 71, 160, 232),
                  )
                : const Icon(
                    Icons.girl,
                    color: Color.fromARGB(255, 230, 121, 236),
                  ),
            onPressed: () {
              setState(() {
                selectedGender =
                    selectedGender == "Мальчик" ? "Девочка" : "Мальчик";
              });
            },
          ),
        ],
        title: selectedGender == "Мальчик"
            ? const Text('Мужские имена')
            : Text('Женские имена'),
      ),
      body: _buildNameList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => _addName(),
          );
          loadData();
        },
        tooltip: 'Добавить',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNameList() {
    List<NameModel> data = nameBox.values.toList();
    List<NameModel> genderList =
        data.where((name) => name.gender == selectedGender).toList();

    // Сортировка списка, сначала по параметру favorite
    genderList.sort((a, b) {
      if (a.favorite && !b.favorite) {
        return -1;
      } else if (!a.favorite && b.favorite) {
        return 1;
      } else {
        return 0;
      }
    });

    return ListView.builder(
      itemCount: genderList.length,
      itemBuilder: (context, index) {
        NameModel nameIndex = genderList[index];

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
            int nameCheck = nameBox.values
                .toList()
                .indexWhere((element) => element.name == nameIndex.name);

            if (nameCheck != -1) {
              await nameBox.deleteAt(nameCheck);
              loadData();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${nameIndex.name} - удалено')));
            }
          },
          child: ListTile(
            title: Text(
              nameIndex.name ?? '',
            ),
            leading: nameIndex.favorite
                ? const Icon(
                    Icons.favorite,
                    color: Color.fromARGB(255, 240, 107, 98),
                  )
                : const Icon(
                    Icons.favorite,
                  ),
            onTap: () async {
              setState(() {
                nameIndex.favorite = !nameIndex.favorite;
              });

              int nameCheck = nameBox.values
                  .toList()
                  .indexWhere((element) => element.name == nameIndex.name);

              if (nameCheck != -1) {
                await nameBox.putAt(nameCheck, nameIndex);
              }
            },
          ),
        );
      },
    );
  }

  Widget _addName() {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      title: const Text('Добавление имени'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            initialValue: '',
            decoration: const InputDecoration(
              labelText: 'Имя:',
            ),
            onChanged: (value) {
              setState(() {
                nameAlertDialog = value ?? '';
              });
            },
            validator: (val) {
              return (val?.trim()?.isEmpty ?? true)
                  ? 'Имя не может быть пустым'
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
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndSave() async {
    if (nameAlertDialog.isNotEmpty) {
      // Проверяем на пустоту
      NameModel newName = NameModel(
        favorite: true,
        name: nameAlertDialog,
        gender: selectedGender, // Используем выбранный пол
      );

      try {
        await nameBox.add(newName);
      } catch (e) {}

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Необходимо заполнить все поля')));
    }
  }
}
