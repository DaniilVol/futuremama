import 'package:flutter/material.dart';
import 'package:futuremama/services/name_provider.dart';
import 'package:futuremama/view/fight/fight.dart';
import 'package:futuremama/view/helth/helth.dart';
import 'package:futuremama/view/helth/weight.dart';
import 'package:futuremama/view/home_view.dart';
import 'package:futuremama/view/name/name.dart';
import 'package:futuremama/view/notes/notes.dart';
import 'package:futuremama/view/notes/shopping_list_view.dart';
import 'package:provider/provider.dart';

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
        home: const HomeView(),
        routes: {
          '/health': (context) => const HealthView(),
          '/notes': (context) => const NotesView(),
          '/name': (context) => const NameView(),
          '/counter': (context) => const FightView(),
          '/weight': (context) => const WeightView(),
          '/bottomnavigation': (context) => const BottomNavigation(),
          '/shoppingListView': (context) => const ShoppingListView(),
        },
      ),
    );
  }
}
