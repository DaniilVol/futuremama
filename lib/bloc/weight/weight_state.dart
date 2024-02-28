import 'package:futuremama/model/weight_model.dart';

abstract class WeightState {}

class WeightResultsState extends WeightState {
  final List<WeightModel> results;

  WeightResultsState({required this.results});
}
