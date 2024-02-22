import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futuremama/bloc/weight/event.dart';
import 'package:futuremama/bloc/weight/state.dart';
import 'package:futuremama/model/weight_model.dart';
import 'package:futuremama/services/weight_hive.dart';

class WeightBloc extends Bloc<WeighEvent, WeightState> {
  WeightBloc() : super(WeightResultsState(results: [])) {
    _onLoadWeight();
    on<AddWeightEvent>(_onAddWeight);
    on<DeleteWeightEvent>(_deleteWeight);
  }

  Future<void> _onLoadWeight() async {
    List<WeightModel> weightResults = await WeightHive.loadWeight();
    emit(WeightResultsState(results: weightResults));
  }

  Future<void> _onAddWeight(
      AddWeightEvent event, Emitter<WeightState> emit) async {
    final currentTime = DateTime.now();
    final int weight = event.result.toInt();
    final results = WeightModel(weight: weight, currentTime: currentTime);
    print('результаты $results');
    await WeightHive.addWeight(results);
    await _onLoadWeight();
  }

  Future<void> _deleteWeight(
      DeleteWeightEvent event, Emitter<WeightState> emit) async {
    await WeightHive.deleteWeight(event.result);
    await _onLoadWeight();
  }
}
