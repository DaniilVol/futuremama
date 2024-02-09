import 'package:flutter/material.dart';
import 'package:futuremama/view/counter.dart';
import 'package:futuremama/view/helth.dart';
import 'package:futuremama/view/name.dart';
import 'package:futuremama/view/notes.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  // Hive.registerAdapter(NameModelAdapter());
  runApp(FuturemamaApp());
}

class FuturemamaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Futuremama App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.blue,
          selectedItemColor: Color.fromARGB(255, 52, 74, 107),
          unselectedItemColor: Color.fromARGB(255, 140, 152, 167),
        ),
      ),
      home: BottomNavigation(),
      routes: {
        '/health': (context) => HealthScreen(),
        '/notes': (context) => NotesScreen(),
        '/name': (context) => NameScreen(),
        '/counter': (context) => CounterScreen(),
      },
    );
  }
}

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HealthScreen(),
    NotesScreen(),
    NameScreen(),
    CounterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Future mama'),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Здоровье',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Заметки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Имена',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Счетчик схваток',
          ),
        ],
      ),
    );
  }
}
