import 'package:futuremama/model/weight_model.dart';

abstract class WeighEvent {}

class AddWeightEvent extends WeighEvent {
  final int weight;
  final int weeks;

  AddWeightEvent({required this.weight, required this.weeks});
}

class DeleteWeightEvent extends WeighEvent {
  final WeightModel result;

  DeleteWeightEvent({required this.result});
}
