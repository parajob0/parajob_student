import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/color_const.dart';

import '../components/core/custom_text.dart';

class AboutTheApplicationScreen extends StatelessWidget {
  const AboutTheApplicationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: primary,
body: Container(
  height: 1.sh - 0.04.sh,
  padding: EdgeInsets.fromLTRB(24.w, 50.h, 24.w, 0.h),
  child:   SingleChildScrollView(

  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkResponse(
        onTap: () {Navigator.pop(context);},
        child: SvgPicture.asset(
          'assets/backWhite.svg',
          width: 12.w,
          height: 20.h,),),
      SizedBox(height: 25.h),
      CustomText(
        text: "About Shaghalny",
        size: 24.sp,
        weight: FontWeight.w400,
        color: Colors.white,),
      SizedBox(height: 10.h),
      CustomText(
        text: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. "
            "The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English."
            " Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. "
            "Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
        size: 12.sp,
        weight: FontWeight.w400,
        color: Colors.grey,),
      SizedBox(height: 20.h),
      CustomText(
        text: "Our Vision",
        size: 24.sp,
        weight: FontWeight.w400,
        color: Colors.white,),
      SizedBox(height: 10.h),
      CustomText(
        text: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout."
            " The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters.",
        size: 12.sp,
        weight: FontWeight.w400,
        color: Colors.grey,),
      SizedBox(height: 20.h),
      CustomText(
      text: "Our Mission",
      size: 24.sp,
      weight: FontWeight.w400,
      color: Colors.white,),
      SizedBox(height: 10.h),
      CustomText(
      text: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. "
          "The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters.",
      size: 12.sp,
      weight: FontWeight.w400,
      color: Colors.grey,),
      SizedBox(height: 20.h),
      CustomText(
        text: "Our Values",
        size: 24.sp,
        weight: FontWeight.w400,
        color: Colors.white,),
      SizedBox(height: 10.h),
      CustomText(
        text: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout."
            " The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters.",
        size: 12.sp,
        weight: FontWeight.w400,
        color: Colors.grey,),
  ],),
  ),
),
    );
  }
}
