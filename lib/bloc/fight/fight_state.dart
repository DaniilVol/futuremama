import 'package:futuremama/model/fight_model.dart';

abstract class FightState {}

class FightInProgressState extends FightState {
  final Duration elapsedTime;

  FightInProgressState({required this.elapsedTime});
}

class FightResultsState extends FightState {
  final List<FightModel> results;

  FightResultsState({required this.results});
}


  // КАК ЗАГРУЗИТЬ ДАННЫЕ ЧТОБЫ "results" НЕ БЫЛ ПУСТЫМ ПРИ ИНИЦИАЛИЗАЦИИ BLOC ??

//   factory FightState.fromHive() async {
//     // Загружаем данные из Hive и возвращаем FightState
//     List<FightResult> fightResults = await HiveManager.loadResults();
//     return FightState(results: fightResults);
// }

