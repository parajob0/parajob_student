import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/custom_text.dart';

class ProfileContainer extends StatelessWidget {
  String title;
  String number;

  ProfileContainer({required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
      width: 98.w,
      height: 115.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: title,
            weight: FontWeight.w600,
            size: 15.sp,
            color: const Color.fromRGBO(255, 255, 255, 1),
          ),
          CustomText(
            text: number,
            weight: FontWeight.w600,
            size: 32.sp,
            color: const Color.fromRGBO(255, 255, 255, 1),
          ),
        ],
      ),
    );
  }
}