import 'package:flutter/material.dart';
import 'package:pattern_background/pattern_background.dart';

class MyBackgroundTexture extends StatelessWidget {
  final Widget child;
  const MyBackgroundTexture({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: CustomPaint(
        size: Size(width, height),
        painter: DotPainter(
          dotColor: Colors.amber,
          dotRadius: 2,
        ),
        child: child,
      ),
    );
  }
}
