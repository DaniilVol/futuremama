import 'package:flutter/material.dart';
import 'package:futuremama/model/name_model.dart';
import 'package:futuremama/services/name_api.dart';
import 'package:futuremama/services/name_hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NameScreen extends StatefulWidget {
  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  late Box _box;
  late List<String> _names;

  @override
  void initState() {
    super.initState();
    _initHive();
    _loadNames();
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    await NameHive.initHive();
    _box = NameHive.box;
  }

  Future<void> _loadNames() async {
    try {
      _names = await NameApi.fetchNames();
      setState(() {});
    } catch (e) {
      print('Error loading names: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Имена'),
      ),
      body: FutureBuilder<void>(
        // Используем FutureBuilder для ожидания завершения инициализации Hive
        future: Hive.openBox('names'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildNameList();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildNameList() {
    return ListView.builder(
      itemCount: _names.length,
      itemBuilder: (context, index) {
        final name = _names[index];
        final isFavorite =
            _box.containsKey(name) ? _box.get(name)!.isFavorite : false;

        return ListTile(
          title: Text(name),
          trailing: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              if (_box.containsKey(name)) {
                _box.delete(name);
              } else {
                NameHive.addName(NameModel(name));
              }

              setState(() {});
            },
          ),
        );
      },
    );
  }
}
