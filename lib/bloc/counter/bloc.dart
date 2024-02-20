import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futuremama/bloc/counter/event.dart';
import 'package:futuremama/bloc/counter/state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(InitialState()) {
    on<StartFightEvent>(_onStartFight);
    on<EndFightEvent>(_onEndFight);
    on<UpdateTimerEvent>(_onUpdateTimer);
    on<RemoveFightEvent>(_onRemoveFight);
  }
  late int index;
  DateTime? startTime;
  late Timer _timer;
  Duration elapsedTime = Duration(seconds: 0);
  List<FightResult> fightResults = [];

  // @override
  // Stream<CounterState> mapEventToState(CounterEvent event) async* {
  //   if (event is StartFightEvent) {
  //     startTime = DateTime.now();
  //     _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
  //     yield FightInProgressState(elapsedTime: elapsedTime);
  //   } else if (event is EndFightEvent) {
  //     _timer.cancel();
  //     final currentTime = DateTime.now();
  //     final duration = currentTime.difference(startTime!);
  //     final timeSinceLastFight = fightResults.isEmpty
  //         ? Duration(seconds: 0)
  //         : currentTime.difference(fightResults.last.currentTime).abs();

  //     final result = FightResult(
  //       currentTime: currentTime,
  //       duration: duration,
  //       timeSinceLastFight: timeSinceLastFight,
  //     );

  //     fightResults.add(result);

  //     yield FightEndedState(results: fightResults);
  //   } else if (event is UpdateTimerEvent) {
  //     elapsedTime = DateTime.now().difference(startTime!);
  //     yield FightInProgressState(elapsedTime: elapsedTime);
  //   }
  // }

  void _updateTimer(Timer timer) {
    add(UpdateTimerEvent());
  }

  void _onStartFight(StartFightEvent event, Emitter<CounterState> emit) {
    startTime = DateTime.now();
    elapsedTime = Duration(seconds: 0);
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
    emit(FightInProgressState(elapsedTime: elapsedTime));
  }

  void _onEndFight(EndFightEvent event, Emitter<CounterState> emit) {
    _timer.cancel();
    final currentTime = DateTime.now();
    final duration = currentTime.difference(startTime!);
    final timeSinceLastFight = fightResults.isEmpty
        ? Duration(seconds: 0)
        : currentTime.difference(fightResults.last.currentTime).abs();

    final result = FightResult(
      currentTime: currentTime,
      duration: duration,
      timeSinceLastFight: timeSinceLastFight,
    );

    fightResults.add(result);
    emit(FightEndedState(results: fightResults.reversed.toList()));
  }

  void _onUpdateTimer(UpdateTimerEvent event, Emitter<CounterState> emit) {
    elapsedTime = DateTime.now().difference(startTime!);
    emit(FightInProgressState(elapsedTime: elapsedTime));
  }

  void _onRemoveFight(RemoveFightEvent event, Emitter<CounterState> emit) {
    fightResults.remove(event.result);
    emit(FightEndedState(results: fightResults.reversed.toList()));
  }
}
