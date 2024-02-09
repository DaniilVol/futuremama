class CounterModel {
  final DateTime currentTime;
  final Duration duration;
  final Duration timeSinceLastFight;

  CounterModel({
    required this.currentTime,
    required this.duration,
    required this.timeSinceLastFight,
  });
}
