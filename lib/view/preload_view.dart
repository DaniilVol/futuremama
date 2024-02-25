import 'package:flutter/material.dart';
import 'package:futuremama/view/home_view.dart';

class PreloadView extends StatelessWidget {
  const PreloadView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Future.delayed(const Duration(seconds: 2)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const HomeView();
        } else {
          return const ColoredBox(color: Colors.pink);
        }
      },
    );
  }
}
