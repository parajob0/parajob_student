import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/color_const.dart';

class ProgressBar extends StatelessWidget {
  int progress;
  ProgressBar({required this.progress, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        progress < 20 ? BarComponent() : BarComponent(progress: progress,),
        SizedBox(width: 8.w),
        progress < 40 ? BarComponent() : BarComponent(progress: progress,),
        SizedBox(width: 8.w),
        progress < 60 ? BarComponent() : BarComponent(progress: progress,),
        SizedBox(width: 8.w),
        progress < 80 ? BarComponent() : BarComponent(progress: progress,),
        SizedBox(width: 8.w),
        progress < 100 ? BarComponent() : BarComponent(progress: progress,),
      ],
    );
  }
}

class BarComponent extends StatelessWidget {
  int progress;
  BarComponent({this.progress = 0, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return progress == 0 ? Container(
      height: 3.h,
      width: 56.w,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.all(Radius.circular(5.sp))
      ),
    )
    : Container(
      height: 3.h,
      width: 56.w,
      decoration: BoxDecoration(
          color: secondary,
          borderRadius: BorderRadius.all(Radius.circular(5.sp)),
          boxShadow: const [
            BoxShadow(
              color: secondary,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ]
      ),
    );
  }
}

