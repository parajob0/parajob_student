import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '/View/components/core/custom_text.dart';

import '../../../color_const.dart';

class SmallJobContainer extends StatelessWidget {
  String position;
  String employer;
  double salary;
  String date;
  String imagUrl;
  double rate;
  bool isBlurred; // whether to put a border secondary color or leave it black
  Color borderColor;
  String containerType;
  bool balance;
  bool deduction;
  SmallJobContainer(
      {required this.position,
      required this.employer,
      required this.salary,
      required this.date,
      required this.imagUrl,
      required this.containerType,
      this.rate = 0,
      this.isBlurred = false,
      this.borderColor = secondary,
      this.balance=false,
      this.deduction=false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = (this.borderColor == Colors.red)? Colors.red:Colors.white;
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.sp)),
          border: isBlurred ? Border.all() : Border.all(color: borderColor),
          color: isBlurred ? Colors.black.withOpacity(0.5) : primary,
          boxShadow: [
            if (!isBlurred)
              BoxShadow(
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  color: borderColor.withOpacity(0.25))
          ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 46.w,
                height: 46.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                    image: DecorationImage(image: NetworkImage(imagUrl), fit: BoxFit.cover)),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomText(
                          text: position,
                          weight: FontWeight.w600,
                          size: 16.sp,
                          color: textColor,
                      ),
                      CustomText(
                          text: " at",
                          weight: FontWeight.w400,
                          size: 14.sp,
                          color: textColor.withOpacity(0.7)),
                    ],
                  ),
                  CustomText(
                      text: employer,
                      weight: FontWeight.w700,
                      size: 12.sp,
                      color: textColor,
                  ),
                ],
              )
            ],
          ),
          containerType == "recommended"
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        CustomText(
                            text: (balance==true)? (deduction==true) ? "- EGP" : "+ EGP ":" EGP ",
                            weight: FontWeight.w300,
                            size: 16.sp,
                            color: textColor,
                        ),
                        CustomText(
                            text: "$salary",
                            weight: FontWeight.w700,
                            size: 16.sp,
                            color: textColor,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/calender.svg',
                          width: 12.5.sp,
                          height: 12.5.sp,
                          color: textColor,
                        ),
                        CustomText(
                            text: " $date",
                            weight: FontWeight.w400,
                            size: 10.sp,
                            color: textColor,
                        ),
                      ],
                    ),
                  ],
                )
              : containerType == "high"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            CustomText(
                                text: "EGP ",
                                weight: FontWeight.w300,
                                size: 16.sp,
                                color: Colors.white),
                            CustomText(
                                text: "$salary",
                                weight: FontWeight.w700,
                                size: 16.sp,
                                color: Colors.white),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/rate.svg',
                              width: 12.5.sp,
                              height: 12.5.sp,
                            ),
                            CustomText(
                                text: "  $rate",
                                weight: FontWeight.w400,
                                size: 10.sp,
                                color: Colors.white),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            CustomText(
                                text: "EGP ",
                                weight: FontWeight.w300,
                                size: 16.sp,
                                color: Colors.white),
                            CustomText(
                                text: "$salary",
                                weight: FontWeight.w700,
                                size: 16.sp,
                                color: Colors.white),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/calender.svg',
                              width: 12.5.sp,
                              height: 12.5.sp,
                            ),
                            CustomText(
                                text: " $date",
                                weight: FontWeight.w400,
                                size: 10.sp,
                                color: Colors.white),
                          ],
                        ),
                      ],
                    )
        ],
      ),
    );
  }
}
