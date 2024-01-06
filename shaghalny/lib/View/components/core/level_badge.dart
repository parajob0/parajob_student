import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '/View/components/core/custom_text.dart';

class BigLevelBadge extends StatelessWidget {
  String level;

  BigLevelBadge({required this.level, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment:  AlignmentDirectional.topCenter,
      children: [
        SvgPicture.asset('assets/level badge 2.svg', width: 42.w, height: 43.h),
        Align(
            alignment: Alignment.center,
            // top: 7.h,
            // left: 17.5.w,
            child: Container(
                // color: Colors.red,
                width: 45.w,
                height: 43.h-18.h,
                child: Center(
                    child: CustomText(
                        textAlign: TextAlign.center,
                        text: level,
                        weight: FontWeight.w700,
                        size: 10.sp,
                        color: Colors.white))))
      ],
    );
  }
}
