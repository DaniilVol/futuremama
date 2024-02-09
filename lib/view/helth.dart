import 'package:flutter/material.dart';

class HealthScreen extends StatelessWidget {
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
                  color: Colors.blue, // Цвет первой кнопки
                  borderRadius:
                      BorderRadius.circular(10.0), // Закругленные края
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // Действие при нажатии на первую кнопку
                    },
                    child: Text(
                      'Анализы',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16), // Отступ между кнопками
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green, // Цвет второй кнопки
                  borderRadius:
                      BorderRadius.circular(10.0), // Закругленные края
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // Действие при нажатии на вторую кнопку
                    },
                    child: Text(
                      'Вес',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16), // Отступ между кнопками
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange, // Цвет третьей кнопки
                  borderRadius:
                      BorderRadius.circular(10.0), // Закругленные края
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // Действие при нажатии на третью кнопку
                    },
                    child: Text(
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
