import 'package:futuremama/model/weight_model.dart';

abstract class WeighEvent {}

class AddWeightEvent extends WeighEvent {
  final int result;

  AddWeightEvent({required this.result});
}

class DeleteWeightEvent extends WeighEvent {
  final WeightModel result;

  DeleteWeightEvent({required this.result});
}
