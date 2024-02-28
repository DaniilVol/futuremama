import 'package:flutter/material.dart';
import 'package:futuremama/services/sharedpreferences.dart';
import 'package:futuremama/view/fight/fight.dart';
import 'package:futuremama/view/helth/helth.dart';
import 'package:futuremama/view/name/name.dart';
import 'package:futuremama/view/notes/notes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SharedPreferencesService.checkFirstDayLastM(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != true) {
            // Если "dateFirstDayLastMKey" пустой, показать AlertDialog
            return const BottomNavigation();
          } else {
            DateTime selectedDate = DateTime.now();
            return Scaffold(
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Выберите дату начала беременности",
                      style: TextStyle(fontSize: 20),
                    ),
                    Center(
                      child: Expanded(
                        child: CalendarDatePicker(
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          onDateChanged: (date) {
                            selectedDate = date;
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await SharedPreferencesService.saveStartDate(
                            selectedDate);
                        Navigator.pushReplacementNamed(
                            context, '/bottomnavigation');
                      },
                      child: const Text("Сохранить"),
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HealthView(),
    const NotesView(),
    const NameView(),
    const FightView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Future mama'),
      // ),
      body: SafeArea(child: _screens[_currentIndex]),
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







//   Future<void> _loadPreferences() async {
//     final storedDate = await SharedPreferencesService.loadStartDate();

//     if (storedDate == null) {
//       _showDatePickerDialog();
//     } else {
//       const FuturemamaApp();
//     }
//   }

//   Future<void> _showDatePickerDialog() async {
//     DateTime selectedDate = DateTime.now();

//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Выберите дату начала беременности"),
//           content: SizedBox(
//             height: 200,
//             child: Column(
//               children: [
//                 Expanded(
//                   child: CalendarDatePicker(
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime.now(),
//                     onDateChanged: (date) {
//                       selectedDate = date;
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () async {
//                 await SharedPreferencesService.saveStartDate(selectedDate);
//                 Navigator.of(context).pop();
//               },
//               child: Text("Сохранить"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Ваш виджет"),
//       ),
//       body: Center(
//         child: Text("Ваш основной контент"),
//       ),
//     );
//   }
// }
