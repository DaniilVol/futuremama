import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futuremama/bloc/counter/event.dart';
import 'package:futuremama/bloc/counter/state.dart';
import 'package:futuremama/model/fight_model.dart';
import 'package:futuremama/services/fight_hive.dart';

class FightBloc extends Bloc<FightEvent, FightState> {
  FightBloc() : super(FightResultsState(results: [])) {
    Future.delayed(Duration.zero, () {
      _loadResultsFromHive();
    });
    on<StartFightEvent>(_onStartFight);
    on<EndFightEvent>(_onEndFight);
    on<UpdateTimerEvent>(_onUpdateTimer);
    on<RemoveFightEvent>(_onRemoveFight);
    on<RemoveAllFightEvent>(_onRemoveAllFight);
  }
  bool _isLoading = false;
  late int index;
  DateTime? startTime;
  late Timer _timer;
  Duration elapsedTime = const Duration(seconds: 0);

  bool get isLoading {
    return _isLoading;
  }

  void _updateTimer(Timer timer) {
    add(UpdateTimerEvent());
  }

  void _onStartFight(StartFightEvent event, Emitter<FightState> emit) {
    startTime = DateTime.now();
    elapsedTime = const Duration(seconds: 0);
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
    emit(FightInProgressState(elapsedTime: elapsedTime));
  }

  Future<void> _loadResultsFromHive() async {
    _isLoading = true;
    List<FightModel> fightResults = await FightHive.loadResults();
    emit(FightResultsState(results: fightResults));
  }

  Future<void> _onEndFight(
      EndFightEvent event, Emitter<FightState> emit) async {
    _timer.cancel();
    List<FightModel> fightResults = await FightHive.loadResults();
    final currentTime = DateTime.now();
    final duration = currentTime.difference(startTime!);
    final timeSinceLastFight = fightResults.isEmpty
        ? const Duration(seconds: 0)
        : currentTime.difference(fightResults.first.currentTime).abs();

    final result = FightModel(
      currentTime: currentTime,
      duration: duration,
      timeSinceLastFight: timeSinceLastFight,
    );
    await FightHive.addResults(result);
    _loadResultsFromHive();
  }

  void _onUpdateTimer(UpdateTimerEvent event, Emitter<FightState> emit) {
    elapsedTime = DateTime.now().difference(startTime!);
    emit(FightInProgressState(elapsedTime: elapsedTime));
  }

  Future<void> _onRemoveFight(
      RemoveFightEvent event, Emitter<FightState> emit) async {
    await FightHive.removeResult(event.result);
    await _loadResultsFromHive();
  }

  Future<void> _onRemoveAllFight(
      RemoveAllFightEvent event, Emitter<FightState> emit) async {
    await FightHive.removeAllResults();
    await _loadResultsFromHive();
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}
