import 'package:futuremama/model/fight_model.dart';

abstract class FightEvent {}

class StartFightEvent extends FightEvent {}

class EndFightEvent extends FightEvent {}

class UpdateTimerEvent extends FightEvent {}

class RemoveAllFightEvent extends FightEvent {}

class RemoveFightEvent extends FightEvent {
  final FightModel result;

  RemoveFightEvent({required this.result});
}
