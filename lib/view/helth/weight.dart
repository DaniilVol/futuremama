import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futuremama/bloc/weight/bloc.dart';
import 'package:futuremama/bloc/weight/event.dart';
import 'package:futuremama/bloc/weight/state.dart';
import 'package:futuremama/model/weight_model.dart';
import 'package:intl/intl.dart';

class WeightView extends StatelessWidget {
  final TextEditingController weightController = TextEditingController();

  WeightView({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вес'),
      ),
      body: BlocProvider(
        create: (context) => WeightBloc(),
        child:
            BlocBuilder<WeightBloc, WeightState>(builder: (contextBloc, state) {
          if (state is WeightResultsState) {
            return Column(
              children: [
                _weightLineChartWidget(contextBloc),
                Expanded(
                  child: ListView.builder(
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
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          title: Text(
                              'неделя ${result.weeks} \n$formattedDate: ${result.weight} кг'),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: contextBloc, // передаем contextBloc
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Введите результат веса:'),
                          content: TextField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                weightController.clear();
                              },
                              child: const Text('Отмена'),
                            ),
                            TextButton(
                              onPressed: () {
                                int enteredWeight =
                                    int.tryParse(weightController.text) ?? 0;
                                contextBloc.read<WeightBloc>().add(
                                      AddWeightEvent(result: enteredWeight),
                                    );
                                Navigator.pop(context);
                                weightController.clear();
                              },
                              child: const Text('Добавить'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Добавить вес'),
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}

Widget _weightLineChartWidget(BuildContext contextBloc,){ 
  // List<WeightModel> results) {
  context
  return LineChart(
    LineChartData(
      titlesData: FlTitlesData(show: true),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: 0,
      maxX: results.length.toDouble(), // Количество точек по оси X
      minY: 40, //(results.first.weight - 5).toDouble(),
      maxY:
          100, //(results.last.weight + 10).toDouble(), // Максимальное значение на оси Y
      lineBarsData: [
        _buildLineChartBarData(results, Colors.blue),
        // _buildLineChartBarData(results, Colors.green),
        // _buildLineChartBarData(results, Colors.red),
      ],
    ),
  );
}

LineChartBarData _buildLineChartBarData(
    List<WeightModel> results, Color color) {
  return LineChartBarData(
    spots: results
        .asMap()
        .entries
        .map((entry) =>
            FlSpot(entry.key.toDouble(), entry.value.weight.toDouble()))
        .toList(),
    isCurved: true,
    color: color,
    dotData: FlDotData(show: false),
  );
}


// class WeightChartWidget extends StatelessWidget {
//   final List<double> weights1; // данные для первой линии
//   final List<double> weights2; // данные для второй линии
//   final List<double> weights3; // данные для третьей линии
//   final List<DateTime> dates; // даты для оси Y

//   WeightChartWidget({
//     required this.weights1,
//     required this.weights2,
//     required this.weights3,
//     required this.dates,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return LineChart(
//       LineChartData(
//         lineBarsData: [
//           // Первая линия
//           LineChartBarData(
//             spots: List.generate(
//               weights1.length,
//               (index) => FlSpot(weights1[index],
//                   dates[index].millisecondsSinceEpoch.toDouble()),
//             ),
//             isCurved: true,
//             color: Colors.blue,
//             dotData: FlDotData(show: false),
//             belowBarData: BarAreaData(show: false),
//           ),
//           // Вторая линия
//           LineChartBarData(
//             spots: List.generate(
//               weights2.length,
//               (index) => FlSpot(weights2[index],
//                   dates[index].millisecondsSinceEpoch.toDouble()),
//             ),
//             isCurved: true,
//             color: Colors.red,
//             dotData: FlDotData(show: false),
//             belowBarData: BarAreaData(show: false),
//           ),
//           // Третья линия
//           LineChartBarData(
//             spots: List.generate(
//               weights3.length,
//               (index) => FlSpot(weights3[index],
//                   dates[index].millisecondsSinceEpoch.toDouble()),
//             ),
//             isCurved: true,
//             color: Colors.green,
//             dotData: FlDotData(show: false),
//             belowBarData: BarAreaData(show: false),
//           ),
//         ],
//         titlesData: FlTitlesData(
//             //leftTitles: SideTitles(showTitles: false),
//             // bottomTitles: SideTitles(
//             //   showTitles: true,
//             //   reservedSize: 22,
//             //   getTextStyles: (value) => const TextStyle(color: Colors.black, fontSize: 10),
//             //   getTitles: (value) {
//             //     // Здесь вы можете настроить метки для оси X, используя value
//             //     return value.toInt().toString();
//             //   },
//             // ),
//             ),
//         borderData: FlBorderData(
//           show: true,
//           border: Border.all(color: const Color(0xff37434d), width: 1),
//         ),
//         gridData: FlGridData(show: false),
//         //lineBarsData: [
//         // Ваши линии здесь
//         // ],
//       ),
//     );
//   }
// }

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
