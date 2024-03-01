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
    return BlocProvider(
      create: (context) => WeightBloc(),
      child:
          BlocBuilder<WeightBloc, WeightState>(builder: (contextBloc, state) {
        if (state is WeightResultsState) {
          Map<String, List<FlSpot>> flSpotWeightAll =
              contextBloc.watch<WeightBloc>().flSpotWeightAll;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Вес'),
            ),
            body: Column(
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Вес ${result.weight}кг - удален')));
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
              ],
            ),
            floatingActionButton: FloatingActionButton(
                tooltip: 'Добавить',
                child: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: contextBloc, // передаем contextBloc
                    builder: (context) {
                      return _buttonAddWeight(contextBloc);
                    },
                  );
                }),
          );
        } else {
          return const CircularProgressIndicator();
        }
      }),
    );
  }

  Widget _buttonAddWeight(BuildContext contextBloc) {
    final TextEditingController weightController = TextEditingController();
    final TextEditingController weeksController = TextEditingController(
        text: contextBloc.watch<WeightBloc>().weeks.toString());
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      title: const Text('Добавление веса'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
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
            Navigator.pop(contextBloc);
            weightController.clear();
          },
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            int enteredWeeks = int.tryParse(weeksController.text) ?? 0;
            int enteredWeight = int.tryParse(weightController.text) ?? 0;
            contextBloc.read<WeightBloc>().add(
                  AddWeightEvent(weight: enteredWeight, weeks: enteredWeeks),
                );
            Navigator.pop(contextBloc);
            weightController.clear();
            weeksController.clear();
          },
          child: const Text('Добавить'),
        ),
      ],
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
