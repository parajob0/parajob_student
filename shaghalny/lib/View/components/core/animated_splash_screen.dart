import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:ui' as ui;

class AnimatedSplash extends StatelessWidget {
  const AnimatedSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        const RiveAnimation.asset(
          'assets/parajob.riv',
          fit: BoxFit.cover,
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
                sigmaX: 100.0, sigmaY: 100.0),
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  color:
                  Colors.black.withOpacity(0.7)),
            ),
          ),
        ),
      ],
    );
  }
}
