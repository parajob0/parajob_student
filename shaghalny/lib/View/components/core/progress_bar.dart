import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';

import '../../../color_const.dart';

class CustomProgressBar extends StatelessWidget {
  double progress;
  double width;
  double height;

  CustomProgressBar({
    required this.progress,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      value: progress,
      width: width,
      height: height,
      backgroundColor: Colors.white,
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          secondary,
          Colors.white,
        ],
      ),
    );
  }
}
