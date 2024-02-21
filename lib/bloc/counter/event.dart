import 'package:futuremama/model/counter_model.dart';

abstract class CounterEvent {}

class StartFightEvent extends CounterEvent {}

class EndFightEvent extends CounterEvent {}

class UpdateTimerEvent extends CounterEvent {}

class RemoveFightEvent extends CounterEvent {
  final FightResult result;

  RemoveFightEvent({required this.result});
}
