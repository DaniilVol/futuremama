import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:futuremama/view/home_view.dart';

class PreloadView extends StatelessWidget {
  const PreloadView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _delayedFuture(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const HomeView();
        } else {
          return const Scaffold(body: Center(child: CustomLoadingIndicator()));
        }
      },
    );
  }

  Future<bool> _delayedFuture() async {
    await Future.delayed(Duration(seconds: 7));
    return true;
  }
}

class CustomLoadingIndicator extends StatefulWidget {
  const CustomLoadingIndicator({super.key});

  @override
  _CustomLoadingIndicatorState createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();
    // forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: CustomLoadingPainter(_animation.value),
            child: Container(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CustomLoadingPainter extends CustomPainter {
  final double value;

  CustomLoadingPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 9, 137, 176)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 30.0;

    Paint paintRed = Paint()
      ..color = const Color.fromARGB(255, 217, 142, 187)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 250.0;

    double width = size.width;
    double height = size.height;

    // линия
    double lineEndY = height * (1 - value * 2);

    canvas.drawLine(
      Offset(15, height + 50),
      Offset(15, lineEndY),
      paint,
    );

    //  круг верхней верхней части
    if (lineEndY <= height / 50) {
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(width / 15, height / 12), radius: width / 5),
        pi,
        value * 2 * pi,
        false,
        paint,
      );
    }

    //  круг верхней части
    if (lineEndY <= height / 14) {
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(width / 40, height / 5), radius: width / 10),
        pi,
        value * 1.5 * pi,
        false,
        paint,
      );
    }

    // круг средней части
    if (lineEndY <= height / 4) {
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(width / 6.5, height / 3), radius: width / 4),
        pi,
        value * 2 * pi,
        false,
        paint,
      );
    }

    // круг нижней части
    if (lineEndY <= height / 2.2) {
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(width / 4, 3 * height / 4), radius: width / 1.5),
        -pi,
        value * 2 * pi,
        false,
        paint,
      );
    }

    if (value >= 0.8) {
      canvas.drawPoints(
        PointMode.points,
        [Offset(width / 2, 3 * height / 4)],
        paintRed,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
