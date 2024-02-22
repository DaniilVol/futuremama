import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futuremama/bloc/weight/bloc.dart';
import 'package:futuremama/bloc/weight/event.dart';
import 'package:futuremama/bloc/weight/state.dart';
import 'package:futuremama/model/weight_model.dart';
import 'package:intl/intl.dart';

// class WeightView extends StatelessWidget {
//   final TextEditingController weightController = TextEditingController();

//   WeightView({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Счетчик схваток'),
//       ),
//       body: BlocProvider(
//         create: (context) => WeightBloc(),
//         child: BlocBuilder<WeightBloc, WeightState>(
//           builder: (context, state) {
//             if (state is WeightResultsState) {
//               return Column(
//                 children: [
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: state.results.length,
//                       itemBuilder: (context, index) {
//                         WeightModel weight = state.results[index];
//                         return Dismissible(
//                           key: Key('$index'),
//                           onDismissed: (direction) {
//                             context.read<WeightBloc>().add(
//                                   DeleteWeightEvent(result: weight),
//                                 );
//                           },
//                           background: Container(
//                             color: Colors.red,
//                             child: Icon(Icons.delete, color: Colors.white),
//                             alignment: Alignment.centerRight,
//                             padding: EdgeInsets.only(right: 20.0),
//                           ),
//                           child: ListTile(
//                             title: Text('Вес $index: ${weight.weight}'),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) {
//                           return AlertDialog(
//                             title: Text('Введите результат веса:'),
//                             content: TextField(
//                               controller: weightController,
//                               keyboardType: TextInputType.number,
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text('Отмена'),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   int enteredWeight =
//                                       int.tryParse(weightController.text) ?? 0;
//                                   context.read<WeightBloc>().add(
//                                         AddWeightEvent(result: enteredWeight),
//                                       );
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text('Добавить'),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                     child: Text('Добавить вес'),
//                   ),
//                 ],
//               );
//             } else {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

class WeightView extends StatelessWidget {
  final TextEditingController weightController = TextEditingController();

  WeightView({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Счетчик схваток'),
      ),
      body: BlocProvider(
        create: (context) => WeightBloc(),
        child: Builder(
          builder: (contextBloc) {
            return Column(
              children: [
                Expanded(
                  child: BlocBuilder<WeightBloc, WeightState>(
                    builder: (context, state) {
                      if (state is WeightResultsState) {
                        return ListView.builder(
                          itemCount: state.results.length,
                          itemBuilder: (context, index) {
                            final result = state.results[index];
                            final formattedDate = DateFormat('dd.MM.yy')
                                .format(result.currentTime.toLocal());
                            return Dismissible(
                              key: Key(result.toString()),
                              onDismissed: (direction) {
                                contextBloc.read<WeightBloc>().add(
                                      DeleteWeightEvent(result: result),
                                    );
                              },
                              background: Container(
                                color: Colors.red,
                                child: Icon(Icons.delete, color: Colors.white),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20.0),
                              ),
                              child: ListTile(
                                title:
                                    Text('${formattedDate}: ${result.weight}'),
                              ),
                            );
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: contextBloc, // передаем contextBloc
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Введите результат веса:'),
                          content: TextField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Отмена'),
                            ),
                            TextButton(
                              onPressed: () {
                                int enteredWeight =
                                    int.tryParse(weightController.text) ?? 0;
                                contextBloc.read<WeightBloc>().add(
                                      AddWeightEvent(result: enteredWeight),
                                    );
                                Navigator.pop(context);
                              },
                              child: Text('Добавить'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Добавить вес'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}




// class WeightView extends StatelessWidget {
//   const WeightView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => WeightBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Счетчик схваток'),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: BlocBuilder<WeightBloc, WeightState>(
//                 builder: (context, state) {
//                   if (state is WeightResultsState) {
//                     return ListView.builder(
//                       itemCount: state.results.length,
//                       itemBuilder: (context, index) {
//                         final weight = state.results[index];
//                         return Dismissible(
//                           key: Key('$index'),
//                           onDismissed: (direction) {
//                             context.read<WeightBloc>().add(
//                                   DeleteWeightEvent(result: weight),
//                                 );
//                           },
//                           background: Container(
//                             color: Colors.red,
//                             child: Icon(Icons.delete, color: Colors.white),
//                             alignment: Alignment.centerRight,
//                             padding: EdgeInsets.only(right: 20.0),
//                           ),
//                           child: ListTile(
//                             title: Text('Вес ${weight.weight}'),
//                           ),
//                         );
//                       },
//                     );
//                   }
//                   return Container(); // Возможно, здесь нужно показать заглушку или индикатор загрузки
//                 },
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final result = await showDialog(
//                   context: context,
//                   builder: (context) =>
//                       AddWeightDialog(weightBloc: context.read<WeightBloc>()),
//                 );

//                 if (result != null) {
//                   context.read<WeightBloc>().add(
//                         AddWeightEvent(result: result),
//                       );
//                 }
//               },
//               child: Text('Добавить вес'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AddWeightDialog extends StatefulWidget {
//   final WeightBloc weightBloc;

//   const AddWeightDialog({Key? key, required this.weightBloc}) : super(key: key);

//   @override
//   AddWeightDialogState createState() => AddWeightDialogState();
// }

// class AddWeightDialogState extends State<AddWeightDialog> {
//   final TextEditingController _weightController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Введите вес'),
//       content: TextField(
//         controller: _weightController,
//         keyboardType: TextInputType.number,
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('Отмена'),
//         ),
//         TextButton(
//           onPressed: () {
//             final weight = int.tryParse(_weightController.text);
//             if (weight != null) {
//               widget.weightBloc.add(AddWeightEvent(result: weight));
//               Navigator.of(context).pop();
//             } else {
//               // Можно добавить обработку ошибки
//             }
//           },
//           child: Text('Добавить'),
//         ),
//       ],
//     );
//   }
// }
