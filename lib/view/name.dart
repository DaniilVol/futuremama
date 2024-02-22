import 'package:flutter/material.dart';
import 'package:futuremama/services/name_provider.dart';
import 'package:provider/provider.dart';

class NameView extends StatefulWidget {
  const NameView({super.key});

  @override
  NameViewState createState() => NameViewState();
}

class NameViewState extends State<NameView> {
  bool _isLoading = true; // Добавляем состояние isLoading

  @override
  void initState() {
    super.initState();

    // Добавляем Future.delayed для вызова getData после построения виджета
    Future.delayed(Duration.zero, () {
      Provider.of<NameProvider>(context, listen: false).getData().then((_) {
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
        title: const Text('Name List'),
      ),
      body: _isLoading
          ? const CircularProgressIndicator()
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
