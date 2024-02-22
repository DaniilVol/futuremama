import 'package:flutter/material.dart';
import 'package:futuremama/model/fight_model.dart';
import 'package:futuremama/model/name_model.dart';
import 'package:futuremama/model/weight_model.dart';
import 'package:futuremama/services/name_hive.dart';
import 'package:futuremama/services/name_provider.dart';
import 'package:futuremama/view/counter.dart';
import 'package:futuremama/view/helth/helth.dart';
import 'package:futuremama/view/helth/weight.dart';
import 'package:futuremama/view/name.dart';
import 'package:futuremama/view/notes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<NameModel>(NameModelAdapter());
  Hive.registerAdapter<FightModel>(FightModelAdapter());
  Hive.registerAdapter<WeightModel>(WeightModelAdapter());
  await Hive.openBox<NameModel>(NameHive.boxName);

  //await Hive.openBox<FightResult>('fight_results');

  runApp(const FuturemamaApp());
}

class FuturemamaApp extends StatelessWidget {
  const FuturemamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NameProvider(),
      child: MaterialApp(
        title: 'Futuremama App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // visualDensity: VisualDensity.adaptivePlatformDensity,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.blue,
            selectedItemColor: Color.fromARGB(255, 52, 74, 107),
            unselectedItemColor: Color.fromARGB(255, 140, 152, 167),
          ),
        ),
        home: const BottomNavigation(),
        routes: {
          '/health': (context) => const HealthView(),
          '/notes': (context) => const NotesView(),
          '/name': (context) => const NameView(),
          '/counter': (context) => const CounterView(),
          '/weight': (context) => WeightView(),
        },
      ),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HealthView(),
    const NotesView(),
    const NameView(),
    const CounterView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Future mama'),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
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
