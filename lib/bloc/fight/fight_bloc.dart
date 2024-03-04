import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futuremama/bloc/fight/fight_event.dart';
import 'package:futuremama/bloc/fight/fight_state.dart';
import 'package:futuremama/model/fight_model.dart';
import 'package:futuremama/services/hive/fight_hive.dart';

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
  late Timer? _timer = null;
  Duration elapsedTime = const Duration(seconds: 0);

  bool get isLoading {
    return _isLoading;
  }

  void _updateTimer(Timer timer) {
    add(UpdateTimerEvent());
  }

// старт таймера
  void _onStartFight(StartFightEvent event, Emitter<FightState> emit) {
    startTime = DateTime.now();
    elapsedTime = const Duration(seconds: 0);
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
    emit(FightInProgressState(elapsedTime: elapsedTime));
  }

// загрузка результатов из HIVE
  Future<void> _loadResultsFromHive() async {
    _isLoading = true;
    List<FightModel> fightResults = await FightHive.loadResults();
    emit(FightResultsState(results: fightResults));
  }

// конец таймера
  Future<void> _onEndFight(
      EndFightEvent event, Emitter<FightState> emit) async {
    _timer?.cancel();
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

// обновления таймера
  void _onUpdateTimer(UpdateTimerEvent event, Emitter<FightState> emit) {
    elapsedTime = DateTime.now().difference(startTime!);
    emit(FightInProgressState(elapsedTime: elapsedTime));
  }

// очистить результат Таймера
  Future<void> _onRemoveFight(
      RemoveFightEvent event, Emitter<FightState> emit) async {
    await FightHive.removeResult(event.result);
    await _loadResultsFromHive();
  }

// очистить все
  Future<void> _onRemoveAllFight(
      RemoveAllFightEvent event, Emitter<FightState> emit) async {
    await FightHive.removeAllResults();
    await _loadResultsFromHive();
  }

// при закрытии экрана закрываем таймер
  @override
  Future<void> close() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
    return super.close();
  }
}
