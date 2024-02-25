import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futuremama/bloc/counter/bloc.dart';
import 'package:futuremama/bloc/counter/event.dart';
import 'package:futuremama/bloc/counter/state.dart';
import 'package:futuremama/model/fight_model.dart';
import 'package:intl/intl.dart';

class FightView extends StatelessWidget {
  const FightView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FightBloc(),
      child: BlocBuilder<FightBloc, FightState>(
        builder: (context, state) {
          if (state is FightInProgressState) {
            return _buildFightInProgressScreen(context, state.elapsedTime);
          } else if (state is FightResultsState) {
            return _buildFightEndedScreen(context, state.results);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget _buildFightInProgressScreen(
      BuildContext context, Duration elapsedTime) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Счетчик схваток'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Прошло: ${elapsedTime.inMinutes}:${(elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildInkWell('Закончилась', Colors.red, () {
                context.read<FightBloc>().add(EndFightEvent());
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFightEndedScreen(
      BuildContext context, List<FightModel> results) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Счетчик схваток'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              context.read<FightBloc>().add(RemoveAllFightEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Все схватки удалены')));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: context.watch<FightBloc>().isLoading
                  ? results.isEmpty
                      ? const Center(child: Text('Нет результатов'))
                      : _buildResultsList(context, results)
                  : const Center(child: CircularProgressIndicator()),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildInkWell(
                'Схватка началась',
                Colors.green,
                () {
                  context.read<FightBloc>().add(StartFightEvent());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(BuildContext context, List<FightModel> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];

        final formattedDate = DateFormat('dd.MM.yy HH:mm:ss')
            .format(result.currentTime.toLocal());

        return Dismissible(
          key: Key(result.toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            context.read<FightBloc>().add(RemoveFightEvent(result: result));
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Схватка удалена - $formattedDate')));
          },
          background: Container(
            color: Colors.red,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          child: ListTile(
            title: Text(
              'Дата: $formattedDate',
            ),
            subtitle: Text(
                'Продолжительность: ${result.duration.inMinutes}:${(result.duration.inSeconds % 60).toString().padLeft(2, '0')} \n'
                'Время с предыдущей схватки: ${result.timeSinceLastFight.inMinutes}:${(result.timeSinceLastFight.inSeconds % 60).toString().padLeft(2, '0')}'),
          ),
        );
      },
    );
  }

  Widget _buildInkWell(String text, Color color, VoidCallback onTap) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(80.0),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
