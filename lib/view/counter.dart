import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futuremama/bloc/counter/bloc.dart';
import 'package:futuremama/bloc/counter/event.dart';
import 'package:futuremama/bloc/counter/state.dart';
import 'package:intl/intl.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({Key? key}) : super(key: key);
  // final CounterBloc _counterBloc = CounterBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(), // _counterBloc,
      child: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          if (state is InitialState) {
            return _buildInitialScreen(context);
          } else if (state is FightInProgressState) {
            return _buildFightInProgressScreen(context, state.elapsedTime);
          } else if (state is FightEndedState) {
            return _buildFightEndedScreen(context, state.results);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildInitialScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Счетчик схваток'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            context.read<CounterBloc>().add(StartFightEvent());
            // _counterBloc.add(StartFightEvent());
          },
          child: Text('Схватка началась'),
        ),
      ),
    );
  }

  Widget _buildFightInProgressScreen(
      BuildContext context, Duration elapsedTime) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Счетчик схваток'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Прошло: ${elapsedTime.inMinutes}:${(elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<CounterBloc>().add(EndFightEvent());
                // _counterBloc.add(EndFightEvent());
              },
              child: Text('Закончились'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFightEndedScreen(
      BuildContext context, List<FightResult> results) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Счетчик схваток'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<CounterBloc>().add(StartFightEvent());
                // _counterBloc.add(StartFightEvent());
              },
              child: Text('Начать новую схватку'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _buildResultsList(context, results),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(BuildContext context, List<FightResult> results) {
    return results.isEmpty
        ? Center(child: Text('Нет результатов'))
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
                    // setState(() {
                    //   items.removeAt(index);
                    // );
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
                        'Дата: $formattedDate'), // ${result.currentTime.toLocal()}'),
                    subtitle: Text(
                        'Продолжительность: ${result.duration.inMinutes}:${(result.duration.inSeconds % 60).toString().padLeft(2, '0')} \n'
                        'Время с предыдущей схватки: ${result.timeSinceLastFight.inMinutes}:${(result.timeSinceLastFight.inSeconds % 60).toString().padLeft(2, '0')}'),
                  ));
            },
          );
  }
}

// class CounterScreen extends StatefulWidget {
//   @override
//   _CounterScreenState createState() => _CounterScreenState();
// }

// class _CounterScreenState extends State<CounterScreen> {
//   late Box _box;
//   bool fightInProgress = false;
//   DateTime? startTime;
//   late Timer _timer;
//   Duration elapsedTime = Duration(seconds: 0);

//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer(Duration(seconds: 0), () {});
//     _initHive();
//   }

//   Future<void> _initHive() async {
//     await Hive.initFlutter();
//     // await CounterHive.initHive();
//     _box = CounterHive.box;
//   }

//   void _startFight() {
//     setState(() {
//       fightInProgress = true;
//       startTime = DateTime.now();
//       _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
//     });
//   }

//   void _endFight() {
//     if (fightInProgress) {
//       _timer.cancel();
//       final currentTime = DateTime.now();
//       final duration = currentTime.difference(startTime!);
//       final timeSinceLastFight = CounterHive.getAllFightResults().isEmpty
//           ? Duration(seconds: 0)
//           : currentTime
//               .difference(CounterHive.getAllFightResults().last.currentTime)
//               .abs();

//       final result = CounterModel(
//         currentTime: currentTime,
//         duration: duration,
//         timeSinceLastFight: timeSinceLastFight,
//       );

//       CounterHive.addFightResult(result);

//       setState(() {
//         fightInProgress = false;
//         elapsedTime = Duration(seconds: 0);
//       });
//     }
//   }

//   void _updateTimer(Timer timer) {
//     setState(() {
//       elapsedTime = DateTime.now().difference(startTime!);
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Счетчик схваток'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (fightInProgress)
//               Text(
//                 'Прошло: ${elapsedTime.inMinutes}:${(elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
//                 style: TextStyle(fontSize: 20),
//               )
//             else
//               ElevatedButton(
//                 onPressed: _startFight,
//                 child: Text('Схватка началась'),
//               ),
//             SizedBox(height: 16),
//             if (fightInProgress)
//               ElevatedButton(
//                 onPressed: _endFight,
//                 child: Text('Закончились'),
//               ),
//             SizedBox(height: 32),
//             Expanded(
//               child: _buildResultsList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildResultsList() {
//     final results = CounterHive.getAllFightResults();

//     return results.isEmpty
//         ? Center(child: Text('Нет результатов'))
//         : ListView.builder(
//             itemCount: results.length,
//             itemBuilder: (context, index) {
//               final result = results[index];

//               return ListTile(
//                 title: Text('Дата: ${result.currentTime.toLocal()}'),
//                 subtitle: Text(
//                     'Продолжительность: ${result.duration.inMinutes}:${(result.duration.inSeconds % 60).toString().padLeft(2, '0')} | '
//                     'Время с предыдущей схватки: ${result.timeSinceLastFight.inMinutes}:${(result.timeSinceLastFight.inSeconds % 60).toString().padLeft(2, '0')}'),
//               );
//             },
//           );
//   }
// }
