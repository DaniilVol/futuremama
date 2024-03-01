import 'package:flutter/material.dart';
import 'package:futuremama/view/fight/fight.dart';
import 'package:futuremama/view/helth/helth.dart';
import 'package:futuremama/view/helth/weight.dart';
import 'package:futuremama/view/home_view.dart';
import 'package:futuremama/view/name/name.dart';
import 'package:futuremama/view/notes/neen_todo_list.dart';
import 'package:futuremama/view/notes/notes.dart';
import 'package:futuremama/view/notes/shopping_list_view.dart';
import 'package:futuremama/view/preload_view.dart';

class FuturemamaApp extends StatelessWidget {
  const FuturemamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Futuremama App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.blue,
          selectedItemColor: Color.fromARGB(255, 52, 74, 107),
          unselectedItemColor: Color.fromARGB(255, 140, 152, 167),
        ),
      ),
      home: const PreloadView(),
      routes: {
        '/health': (context) => const HealthView(),
        '/notes': (context) => const NotesView(),
        '/name': (context) => const NameView(),
        '/counter': (context) => const FightView(),
        '/weight': (context) => const WeightView(),
        '/bottomnavigation': (context) => const BottomNavigation(),
        '/needtodolist': (context) => const NeedTodoListView(),
        '/shoppinglist': (context) => const ShoppingListView(),
      },
    );
  }
}
