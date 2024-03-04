import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futuremama/bloc/weight/weight_event.dart';
import 'package:futuremama/bloc/weight/weight_state.dart';
import 'package:futuremama/model/flSpotWeight_model.dart';
import 'package:futuremama/model/weight_model.dart';
import 'package:futuremama/services/sharedpreferences.dart';
import 'package:futuremama/services/hive/weight_hive.dart';

class WeightBloc extends Bloc<WeighEvent, WeightState> {
  WeightBloc() : super(WeightResultsState(results: [])) {
    _onInitialize();
    on<AddWeightEvent>(_onAddWeight);
    on<DeleteWeightEvent>(_onDeleteWeight);
  }

  Map<String, List<FlSpot>> _flSpotWeightAll = {};
  int _weeks = 2;

  Future<void> _onInitialize() async {
    await _onLineChartWeight();
    await _onWeeksFromStartData();
    await _onLoadWeight();
  }

// загрузка из HIVE
  Future<void> _onLoadWeight() async {
    List<WeightModel> weightResults = await WeightHive.loadWeight();
    emit(WeightResultsState(results: weightResults));
  }

// добавить вес
  Future<void> _onAddWeight(
      AddWeightEvent event, Emitter<WeightState> emit) async {
    final currentTime = DateTime.now();
    final int weight = event.weight.toInt();
    final int weeksFromState = event.weeks.toInt();
    final results = WeightModel(
        weight: weight, currentTime: currentTime, weeks: weeksFromState);
    await WeightHive.addWeight(results);
    await _onLineChartWeight();
    await _onLoadWeight();
  }

// удалить вес
  Future<void> _onDeleteWeight(
      DeleteWeightEvent event, Emitter<WeightState> emit) async {
    await WeightHive.deleteWeight(event.result);
    await _onLineChartWeight();
    await _onLoadWeight();
  }

// высчитываем недели от даты начала беременности и записываем в _weeks для инициализации в textField
  Future<void> _onWeeksFromStartData() async {
    final currentTime = DateTime.now();
    final startDate = await SharedPreferencesService.loadStartDate();
    final differenceInDays =
        currentTime.difference(startDate ?? currentTime).inDays;
    _weeks = (differenceInDays / 7).ceil();
  }

// get
  int get weeks => _weeks;

// get
  Map<String, List<FlSpot>> get flSpotWeightAll {
    return _flSpotWeightAll;
  }

// формируем список координат для построения графиков
  Future<void> _onLineChartWeight() async {
    List<WeightModel> weightResults = await WeightHive.loadWeight();
    double firstWeight;
    List<FlSpot> flSpotWeight;

    if (weightResults.isEmpty) {
      firstWeight = 50;
      flSpotWeight = [];
    } else {
      firstWeight = weightResults.first.weight.toDouble();
      flSpotWeight = weightResults
          .map((e) => FlSpot(e.weeks.toDouble(), e.weight.toDouble()))
          .toList();
    }

    _flSpotWeightAll = {
      'flSpotWeight': flSpotWeight,
      'flSpotWeightMin': FlSpotWeight(firstWeight: firstWeight).flSpotWeightMin,
      'flSpotWeightMax': FlSpotWeight(firstWeight: firstWeight).flSpotWeightMax
    };
  }
}
