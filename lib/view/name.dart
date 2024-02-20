import 'package:flutter/material.dart';
import 'package:futuremama/services/name_provider.dart';
import 'package:provider/provider.dart';

class NameScreen extends StatefulWidget {
  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  bool _isLoading = true; // Добавлено состояние isLoading

  @override
  void initState() {
    super.initState();

    // Добавляем Future.delayed для вызова fetchData после построения виджета
    Future.delayed(Duration.zero, () {
      Provider.of<NameProvider>(context, listen: false).fetchData().then((_) {
        setState(() {
          _isLoading = false; // Устанавливаем состояние загрузки в false
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final nameProvider = Provider.of<NameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Name List'),
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: nameProvider.names.length,
              itemBuilder: (context, index) {
                final name = nameProvider.names[index];
                return ListTile(
                  title: Text(name.name),
                );
              },
            ),
    );
  }
}
