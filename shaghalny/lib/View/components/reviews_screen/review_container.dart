import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/View/components/core/custom_text.dart';

class ReviewContainer extends StatelessWidget {

  String name;
  double rate;
  String review;
  String date;

  ReviewContainer({required this.name, required this.rate, required this.review, required this.date, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 20.h,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
          color: Colors.white.withOpacity(0.05)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: name, weight: FontWeight.w500, size: 16.sp, color: Colors.white),
                Row(
                  children: [
                    SvgPicture.asset('assets/rate.svg', color: Colors.white, width: 10.w, height: 10.h,),
                    CustomText(text: ' ${rate.toString()}', weight: FontWeight.w500, size: 10.sp, color: Colors.white),
                  ],
                )
              ],
            ),
            SizedBox(height: 8.h),
            CustomText(text: review, weight: FontWeight.w400, size: 14.sp, color: Colors.white),
            SizedBox(height: 8.h),
            CustomText(text: date, weight: FontWeight.w400, size: 10.sp, color: Colors.white.withOpacity(0.7)),
          ],
        ),
      );
  }
}
