import 'package:flutter/material.dart';
import 'package:futuremama/services/hive/name_hive.dart';
import 'package:futuremama/services/hive/todo_list_hive.dart';
import 'package:futuremama/services/hive/weight_hive.dart';
import 'package:futuremama/services/sharedpreferences.dart';

class HealthView extends StatelessWidget {
  const HealthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 85, 189, 110),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () async {
// УДАЛЕНИЕ ВСЕХ ДАННЫХ ИЗ HIVE - окно АНАЛИЗЫ

                      SharedPreferencesService.deleteStartDate();
                      NameHive.clearData();
                      TodoListHive.clearAll();
                      WeightHive.deleteAllWeight();
                    },
                    child: const Text(
                      '(Анализы) \n УДАЛЕНИЕ ВСЕХ ДАННЫХ ИЗ HIVE \n для тестирование',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 244, 193, 92),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/weight');
                    },
                    child: const Text(
                      'Вес',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 86, 160, 216),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Давление',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
