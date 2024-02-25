import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futuremama/bloc/weight/event.dart';
import 'package:futuremama/bloc/weight/state.dart';
import 'package:futuremama/model/weight_model.dart';
import 'package:futuremama/services/sharedpreferences.dart';
import 'package:futuremama/services/weight_hive.dart';

class WeightBloc extends Bloc<WeighEvent, WeightState> {
  WeightBloc() : super(WeightResultsState(results: [])) {
    _onLoadWeight();
    on<AddWeightEvent>(_onAddWeight);
    on<DeleteWeightEvent>(_onDeleteWeight);
  }

  Future<void> _onLoadWeight() async {
    List<WeightModel> weightResults = await WeightHive.loadWeight();
    emit(WeightResultsState(results: weightResults));
  }

  Future<void> _onAddWeight(
      AddWeightEvent event, Emitter<WeightState> emit) async {
    final currentTime = DateTime.now();
    final startDate = await SharedPreferencesService.loadStartDate() ??
        currentTime; // проработать отсутствие стартовой даты
    final differenceInDays = currentTime.difference(startDate).inDays;
    final weeks = (differenceInDays / 7).ceil();
    final int weight = event.result.toInt();
    final results =
        WeightModel(weight: weight, currentTime: currentTime, weeks: weeks);
    await WeightHive.addWeight(results);
    await _onLoadWeight();
  }

  Future<void> _onDeleteWeight(
      DeleteWeightEvent event, Emitter<WeightState> emit) async {
    await WeightHive.deleteWeight(event.result);
    await _onLoadWeight();
  }

  Future<List<FlSpot>> _onLineChartWeight() async {
    List<WeightModel> weightResults = await WeightHive.loadWeight();
    //final lenghtWeightResults = weightResults.length;

    List<FlSpot> flSpotWeight = weightResults
        .map((e) => FlSpot(e.weeks.toDouble(), e.weight.toDouble()))
        .toList();
    return flSpotWeight;
  }
}
