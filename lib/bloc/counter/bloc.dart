import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futuremama/bloc/counter/event.dart';
import 'package:futuremama/bloc/counter/state.dart';
import 'package:futuremama/services/counter_hive.dart';
import 'package:futuremama/model/counter_model.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(FightState(results: [])) {
    _loadResultsFromHive();
    on<StartFightEvent>(_onStartFight);
    on<EndFightEvent>(_onEndFight);
    on<UpdateTimerEvent>(_onUpdateTimer);
    on<RemoveFightEvent>(_onRemoveFight);
  }

  late int index;
  DateTime? startTime;
  late Timer _timer;
  Duration elapsedTime = const Duration(seconds: 0);

  void _updateTimer(Timer timer) {
    add(UpdateTimerEvent());
  }

  void _onStartFight(StartFightEvent event, Emitter<CounterState> emit) {
    startTime = DateTime.now();
    elapsedTime = const Duration(seconds: 0);
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
    emit(FightInProgressState(elapsedTime: elapsedTime));
  }

  Future<void> _loadResultsFromHive() async {
    List<FightResult> fightResults = await HiveManager.loadResults();
    emit(FightState(results: fightResults));
  }

  void _onEndFight(EndFightEvent event, Emitter<CounterState> emit) async {
    _timer.cancel();
    List<FightResult> fightResults = await HiveManager.loadResults();
    final currentTime = DateTime.now();
    final duration = currentTime.difference(startTime!);
    final timeSinceLastFight = fightResults.isEmpty
        ? const Duration(seconds: 0)
        : currentTime.difference(fightResults.first.currentTime).abs();

    final result = FightResult(
      currentTime: currentTime,
      duration: duration,
      timeSinceLastFight: timeSinceLastFight,
    );
    await HiveManager.addResults(result);
    _loadResultsFromHive();
  }

  void _onUpdateTimer(UpdateTimerEvent event, Emitter<CounterState> emit) {
    elapsedTime = DateTime.now().difference(startTime!);
    emit(FightInProgressState(elapsedTime: elapsedTime));
  }

  void _onRemoveFight(
      RemoveFightEvent event, Emitter<CounterState> emit) async {
    await HiveManager.removeResult(event.result);
    await _loadResultsFromHive();
  }
}
