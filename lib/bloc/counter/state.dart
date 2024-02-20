abstract class CounterState {}

class InitialState extends CounterState {}

class FightInProgressState extends CounterState {
  final Duration elapsedTime;

  FightInProgressState({required this.elapsedTime});
}

class FightEndedState extends CounterState {
  final List<FightResult> results;

  FightEndedState({required this.results});
}

class FightResult {
  final DateTime currentTime;
  final Duration duration;
  final Duration timeSinceLastFight;

  FightResult({
    required this.currentTime,
    required this.duration,
    required this.timeSinceLastFight,
  });

  @override
  String toString() {
    return '{currentTime: $currentTime, duration: $duration, timeSinceLastFight: $timeSinceLastFight}';
  }
}

// class RemoveFightEvent {
//   int index;

//   RemoveFightEvent({
//     required this.index,
//   });
// }
