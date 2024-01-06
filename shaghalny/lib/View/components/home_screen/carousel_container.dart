import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../color_const.dart';
import '../core/custom_text.dart';

class CarouselContainer extends StatelessWidget {
  String employerName;
  String employerImage;
  dynamic employerRate;
  double jobSalary;
  String position;
  String date;
  String location;
  String perHour;
  String per;

  CarouselContainer(
      {super.key,
      required this.employerName,
      required this.employerImage,
      required this.employerRate,
      required this.jobSalary,
      required this.position,
      required this.date,
      required this.location,
      required this.perHour,
      required this.per,
      });

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
          border: Border.all(color: secondary),
          boxShadow: [
            BoxShadow(
              color: secondary.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(1, 1),
            )
          ]),
      // height: 360.h,
      width: 248.w,
      // padding: EdgeInsets.fromLTRB(16.67.w, 8.3.h, 17.34.w, 50.h),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.67.w, 0.h, 17.34.w, 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 25.w,
                      height: 25.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(employerImage),
                              fit: BoxFit.cover)),
                    ),
                    CustomText(
                      text: ' $employerName',
                      weight: FontWeight.w400,
                      size: 10.42.sp,
                      color: Colors.white,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/rate.svg',
                      width: 10.42.w,
                      height: 10.42.h,
                    ),
                    CustomText(
                      text: ' $employerRate',
                      weight: FontWeight.w400,
                      size: 10.42.sp,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: 'EGP ',
                  weight: FontWeight.w300,
                  size: 27.09.sp,
                  color: Colors.white,
                ),
                CustomText(
                  text: '$jobSalary',
                  weight: FontWeight.w700,
                  size: 27.09.sp,
                  color: Colors.white,
                ),
              ],
            ),

            // SizedBox(height: 6.3.h),
            CustomText(
              text: 'EGP $perHour $per',
              weight: FontWeight.w300,
              size: 10.42.sp,
              color: Colors.white,
            ),

            SizedBox(height: 0.h),
            CustomText(
              text: position,
              weight: FontWeight.w600,
              size: 19.sp,
              color: Colors.white,
            ),

            // SizedBox(height: 5.06.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/calender.svg',
                      width: 12.5.sp,
                      height: 12.5.sp,
                    ),
                    CustomText(
                      text: ' $date',
                      weight: FontWeight.w400,
                      size: 10.42.sp,
                      color: Colors.white,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/location.svg',
                      width: 12.5.sp,
                      height: 12.5.sp,
                    ),
                    CustomText(
                      text: ' $location',
                      weight: FontWeight.w400,
                      size: 10.42.sp,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
