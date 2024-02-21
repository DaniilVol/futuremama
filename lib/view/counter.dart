import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futuremama/bloc/counter/bloc.dart';
import 'package:futuremama/bloc/counter/event.dart';
import 'package:futuremama/bloc/counter/state.dart';
import 'package:futuremama/model/counter_model.dart';
import 'package:intl/intl.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Счетчик схваток'),
        ),
        body: BlocProvider(
          create: (context) => CounterBloc(),
          child: BlocBuilder<CounterBloc, CounterState>(
            builder: (context, state) {
              if (state is FightInProgressState) {
                return _buildFightInProgressScreen(context, state.elapsedTime);
              } else if (state is FightState) {
                return _buildFightEndedScreen(context, state.results);
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ));
  }

  Widget _buildFightInProgressScreen(
      BuildContext context, Duration elapsedTime) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Expanded(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Прошло: ${elapsedTime.inMinutes}:${(elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  context.read<CounterBloc>().add(EndFightEvent());
                },
                customBorder: const CircleBorder(), // Делает кнопку круглой
                child: Ink(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 126, 25, 7), // Цвет кнопки
                    shape: BoxShape.circle, // Устанавливает форму круглой
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.3), // Цвет и прозрачность тени
                        spreadRadius: 2, // Распространение тени
                        blurRadius: 5, // Размытие тени
                        offset:
                            const Offset(0, 3), // Смещение тени по осям X и Y
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(100.0),
                    child: Text(
                      'Закончилась',
                      style: TextStyle(
                        color: Colors.white, // Цвет текста
                        fontSize: 18.0,
                      ),
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

  Widget _buildFightEndedScreen(
      BuildContext context, List<FightResult> results) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Expanded(
        child: Column(
          children: [
            Expanded(
              child: _buildResultsList(context, results),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  context.read<CounterBloc>().add(StartFightEvent());
                },
                customBorder: const CircleBorder(), // Делает кнопку круглой
                child: Ink(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 10, 88, 10), // Цвет кнопки
                    shape: BoxShape.circle, // Устанавливает форму круглой
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.3), // Цвет и прозрачность тени
                        spreadRadius: 2, // Распространение тени
                        blurRadius: 5, // Размытие тени
                        offset:
                            const Offset(0, 3), // Смещение тени по осям X и Y
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(100.0),
                    child: Text(
                      'Схватка началась',
                      style: TextStyle(
                        color: Colors.white, // Цвет текста
                        fontSize: 18.0,
                      ),
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

  Widget _buildResultsList(BuildContext context, List<FightResult> results) {
    return results.isEmpty
        ? const Center(child: Text('Нет результатов'))
        : ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];

              final formattedDate = DateFormat('dd.MM.yy HH:mm:ss')
                  .format(result.currentTime.toLocal());

              return Dismissible(
                key: Key(result.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  context
                      .read<CounterBloc>()
                      .add(RemoveFightEvent(result: result));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Схватка удалена - $formattedDate')));
                },
                background: Container(
                  color: Colors.red,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    'Дата: $formattedDate',
                  ),
                  subtitle: Text(
                      'Продолжительность: ${result.duration.inMinutes}:${(result.duration.inSeconds % 60).toString().padLeft(2, '0')} \n'
                      'Время с предыдущей схватки: ${result.timeSinceLastFight.inMinutes}:${(result.timeSinceLastFight.inSeconds % 60).toString().padLeft(2, '0')}'),
                ),
              );
            },
          );
  }
}

// class CounterScreen extends StatelessWidget {
//   const CounterScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: BlocBuilder<CounterBloc, CounterState>(
//         builder: (context, state) {
//           if (state is FightInProgressState) {
//             return _buildFightInProgressScreen(context, state.elapsedTime);
//           } else if (state is FightState) {
//             return _buildFightEndedScreen(context, state.results);
//           } else {
//             return const CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildFightInProgressScreen(
//       BuildContext context, Duration elapsedTime) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Счетчик схваток'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Прошло: ${elapsedTime.inMinutes}:${(elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
//               style: const TextStyle(fontSize: 20),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 context.read<CounterBloc>().add(EndFightEvent());
//               },
//               child: const Text('Закончились'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFightEndedScreen(
//       BuildContext context, List<FightResult> results) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Счетчик схваток'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 context.read<CounterBloc>().add(StartFightEvent());
//               },
//               child: const Text('Схватка началась'),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: _buildResultsList(context, results),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildResultsList(BuildContext context, List<FightResult> results) {
//     return results.isEmpty
//         ? const Center(child: Text('Нет результатов'))
//         : ListView.builder(
//             itemCount: results.length,
//             itemBuilder: (context, index) {
//               final result = results[index];

//               final formattedDate = DateFormat('dd.MM.yy HH:mm:ss')
//                   .format(result.currentTime.toLocal());

//               return Dismissible(
//                 key: Key(result.toString()),
//                 direction: DismissDirection.endToStart,
//                 onDismissed: (direction) {
//                   context
//                       .read<CounterBloc>()
//                       .add(RemoveFightEvent(result: result));
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       content: Text('Схватка удалена - $formattedDate')));
//                 },
//                 background: Container(
//                   color: Colors.red,
//                   child: const Align(
//                     alignment: Alignment.centerRight,
//                     child: Padding(
//                       padding: EdgeInsets.only(right: 20.0),
//                       child: Icon(
//                         Icons.delete,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//                 child: ListTile(
//                   title: Text(
//                     'Дата: $formattedDate',
//                   ),
//                   subtitle: Text(
//                       'Продолжительность: ${result.duration.inMinutes}:${(result.duration.inSeconds % 60).toString().padLeft(2, '0')} \n'
//                       'Время с предыдущей схватки: ${result.timeSinceLastFight.inMinutes}:${(result.timeSinceLastFight.inSeconds % 60).toString().padLeft(2, '0')}'),
//                 ),
//               );
//             },
//           );
//   }
// }
