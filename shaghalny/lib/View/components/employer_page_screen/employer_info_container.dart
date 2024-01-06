import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/custom_text.dart';

class EmployerInfoContainer extends StatelessWidget {
  String title;
  String subText;

  EmployerInfoContainer({required this.title, required this.subText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 101.w,
      height: 90.h,
      // padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
          color: Colors.white.withOpacity(0.05)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(text: title, weight: FontWeight.w600, size: 14.sp, color: Colors.white),
          CustomText(text: subText, weight: FontWeight.w500, size: 30.sp, color: Colors.white),
        ],
      ),
    );
  }
}
