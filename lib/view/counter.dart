import 'dart:async';
import 'package:flutter/material.dart';
import 'package:futuremama/model/counter_model.dart';
import 'package:futuremama/services/counter_hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  late Box _box;
  bool fightInProgress = false;
  DateTime? startTime;
  late Timer _timer;
  Duration elapsedTime = Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    await CounterHive.initHive();
    _box = CounterHive.box;
  }

  void _startFight() {
    setState(() {
      fightInProgress = true;
      startTime = DateTime.now();
      _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
    });
  }

  void _endFight() {
    if (fightInProgress) {
      _timer.cancel();
      final currentTime = DateTime.now();
      final duration = currentTime.difference(startTime!);
      final timeSinceLastFight = CounterHive.getAllFightResults().isEmpty
          ? Duration(seconds: 0)
          : currentTime
              .difference(CounterHive.getAllFightResults().last.currentTime)
              .abs();

      final result = CounterModel(
        currentTime: currentTime,
        duration: duration,
        timeSinceLastFight: timeSinceLastFight,
      );

      CounterHive.addFightResult(result);

      setState(() {
        fightInProgress = false;
        elapsedTime = Duration(seconds: 0);
      });
    }
  }

  void _updateTimer(Timer timer) {
    setState(() {
      elapsedTime = DateTime.now().difference(startTime!);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Счетчик схваток'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (fightInProgress)
              Text(
                'Прошло: ${elapsedTime.inMinutes}:${(elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 20),
              )
            else
              ElevatedButton(
                onPressed: _startFight,
                child: Text('Схватка началась'),
              ),
            SizedBox(height: 16),
            if (fightInProgress)
              ElevatedButton(
                onPressed: _endFight,
                child: Text('Закончились'),
              ),
            SizedBox(height: 32),
            Expanded(
              child: _buildResultsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    final results = CounterHive.getAllFightResults();

    return results.isEmpty
        ? Center(child: Text('Нет результатов'))
        : ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];

              return ListTile(
                title: Text('Дата: ${result.currentTime.toLocal()}'),
                subtitle: Text(
                    'Продолжительность: ${result.duration.inMinutes}:${(result.duration.inSeconds % 60).toString().padLeft(2, '0')} | '
                    'Время с предыдущей схватки: ${result.timeSinceLastFight.inMinutes}:${(result.timeSinceLastFight.inSeconds % 60).toString().padLeft(2, '0')}'),
              );
            },
          );
  }
}
