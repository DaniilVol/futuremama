import 'package:futuremama/model/counter_model.dart';

abstract class CounterState {}

class FightInProgressState extends CounterState {
  final Duration elapsedTime;

  FightInProgressState({required this.elapsedTime});
}

class FightState extends CounterState {
  final List<FightResult> results;

  FightState({required this.results});
}


  // КАК ЗАГРУЗИТЬ ДАННЫЕ ЧТОБЫ "results" НЕ БЫЛ ПУСТЫМ ПРИ ИНИЦИАЛИЗАЦИИ BLOC ??

//   factory FightState.fromHive() async {
//     // Загружаем данные из Hive и возвращаем FightState
//     List<FightResult> fightResults = await HiveManager.loadResults();
//     return FightState(results: fightResults);
// }

