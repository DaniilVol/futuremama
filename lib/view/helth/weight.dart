import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futuremama/bloc/weight/weight_bloc.dart';
import 'package:futuremama/bloc/weight/weight_event.dart';
import 'package:futuremama/bloc/weight/weight_state.dart';
import 'package:intl/intl.dart';

class WeightView extends StatelessWidget {
  const WeightView({super.key});

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
            Map<String, List<FlSpot>> flSpotWeightAll =
                contextBloc.watch<WeightBloc>().flSpotWeightAll;
            return Column(
              children: [
                const Center(
                  child: Text('График'),
                ),
                _weightLineChartWidget(contextBloc, flSpotWeightAll),
                const SizedBox(
                  height: 15,
                ),
                const Center(
                  child: Text('Список'),
                ),
                state.results.isEmpty
                    ? const Expanded(child: Center(child: Text('Список пуст')))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: state.results.length,
                          itemBuilder: (context, index) {
                            final result = state.results[index];
                            final formattedDate = DateFormat('dd.MM.yy')
                                .format(result.currentTime.toLocal());
                            final backgroundColor = index % 2 == 0
                                ? Colors.grey[200]
                                : Colors.white;
                            return Dismissible(
                              direction: DismissDirection.endToStart,
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
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: ListTile(
                                  tileColor: backgroundColor,
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(formattedDate),
                                      Text('неделя ${result.weeks}'),
                                      Text('${result.weight} кг')
                                    ],
                                  )),
                            );
                          },
                        ),
                      ),
                _buttonAddWeight(contextBloc),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        }),
      ),
    );
  }

  ElevatedButton _buttonAddWeight(BuildContext contextBloc) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: contextBloc, // передаем contextBloc
          builder: (context) {
            final TextEditingController weightController =
                TextEditingController();
            final TextEditingController weeksController = TextEditingController(
                text: contextBloc.watch<WeightBloc>().weeks.toString());
            return AlertDialog(
              title: const Text('Добавление веса'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ваша неделя:'),
                  TextField(
                    controller: weeksController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Введите ваш вес:'),
                  TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                  ),
                ],
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
                    int enteredWeeks = int.tryParse(weeksController.text) ?? 0;
                    int enteredWeight =
                        int.tryParse(weightController.text) ?? 0;
                    contextBloc.read<WeightBloc>().add(
                          AddWeightEvent(
                              weight: enteredWeight, weeks: enteredWeeks),
                        );
                    Navigator.pop(context);
                    weightController.clear();
                    weeksController.clear();
                  },
                  child: const Text('Добавить'),
                ),
              ],
            );
          },
        );
      },
      child: const Text('Добавить вес'),
    );
  }

  Widget _weightLineChartWidget(
      BuildContext contextBloc, Map<String, List<FlSpot>> flSpotWeightAll) {
    List<FlSpot> flSpotWeight = flSpotWeightAll['flSpotWeight'] ?? [];
    List<FlSpot> flSpotWeightMin = flSpotWeightAll['flSpotWeightMin'] ?? [];
    List<FlSpot> flSpotWeightMax = flSpotWeightAll['flSpotWeightMax'] ?? [];
    double flFirstWeight = flSpotWeight.isEmpty ? 50 : flSpotWeight.first.y;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            titlesData: const FlTitlesData(
                rightTitles: AxisTitles(
                  sideTitles:
                      SideTitles(showTitles: false), // обозначения справа
                ),
                topTitles: AxisTitles(
                  sideTitles:
                      SideTitles(showTitles: false), // обозначения сверху
                ),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: 2,
                )),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    interval: 4,
                    showTitles: true,
                    reservedSize: 22,
                  ),
                )),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              drawHorizontalLine: true,
              verticalInterval: 2, // Шаг по вертикали
              horizontalInterval: 2,
              getDrawingHorizontalLine: (value) {
                // линии горизонтальной сетки
                return const FlLine(
                  color: Color(0xff37434d),
                  strokeWidth: 0.2,
                );
              },
              getDrawingVerticalLine: (value) {
                // линии вертикальной сетки
                return const FlLine(
                  color: Color(0xff37434d),
                  strokeWidth: 0.2,
                );
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: const Color(0xff37434d),
                width: 1,
              ),
            ),
            minX: 0,
            maxX: 40, // Количество точек по оси X
            minY: flFirstWeight - 2.0,
            maxY: flFirstWeight + 17.0,
            lineBarsData: [
              LineChartBarData(
                spots: flSpotWeightMax,
                color: Colors.red[300],
                isCurved: true,
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: flSpotWeight,
                color: const Color.fromARGB(255, 31, 165, 24),
                isCurved: true,
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: flSpotWeightMin,
                color: Colors.red[300],
                isCurved: true,
                dotData: const FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
