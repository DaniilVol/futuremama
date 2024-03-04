import 'package:fl_chart/fl_chart.dart';

class FlSpotWeight {
  double firstWeight;
  FlSpotWeight({required this.firstWeight});

  List<FlSpot> get flSpotWeightMin => [
        FlSpot(0, firstWeight),
        FlSpot(2, firstWeight + 0.3),
        FlSpot(4, firstWeight + 0.5),
        FlSpot(6, firstWeight + 0.6),
        FlSpot(8, firstWeight + 0.7),
        FlSpot(10, firstWeight + 0.8),
        FlSpot(12, firstWeight + 0.9),
        FlSpot(14, firstWeight + 1.0),
        FlSpot(16, firstWeight + 1.4),
        FlSpot(18, firstWeight + 2.3),
        FlSpot(20, firstWeight + 2.9),
        FlSpot(22, firstWeight + 3.4),
        FlSpot(24, firstWeight + 3.9),
        FlSpot(26, firstWeight + 5.0),
        FlSpot(28, firstWeight + 5.4),
        FlSpot(30, firstWeight + 5.9),
        FlSpot(32, firstWeight + 6.4),
        FlSpot(34, firstWeight + 7.3),
        FlSpot(36, firstWeight + 7.9),
        FlSpot(38, firstWeight + 8.5),
        FlSpot(40, firstWeight + 9.0),
      ];

  List<FlSpot> get flSpotWeightMax => [
        FlSpot(0, firstWeight),
        FlSpot(2, firstWeight + 0.5),
        FlSpot(4, firstWeight + 0.9),
        FlSpot(6, firstWeight + 1.5),
        FlSpot(8, firstWeight + 1.7),
        FlSpot(10, firstWeight + 1.9),
        FlSpot(12, firstWeight + 2),
        FlSpot(14, firstWeight + 2.6),
        FlSpot(16, firstWeight + 3.2),
        FlSpot(18, firstWeight + 4.5),
        FlSpot(20, firstWeight + 5.4),
        FlSpot(22, firstWeight + 6.8),
        FlSpot(24, firstWeight + 7.7),
        FlSpot(26, firstWeight + 8.6),
        FlSpot(28, firstWeight + 9.8),
        FlSpot(30, firstWeight + 10.3),
        FlSpot(32, firstWeight + 11.3),
        FlSpot(34, firstWeight + 12.5),
        FlSpot(36, firstWeight + 13.6),
        FlSpot(38, firstWeight + 14.5),
        FlSpot(40, firstWeight + 15.0),
      ];
}
