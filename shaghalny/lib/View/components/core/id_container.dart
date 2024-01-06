
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../color_const.dart';
import 'custom_text.dart';

class IDContainer extends StatelessWidget {
  String imagePath;
  String imageHolder;
  String hintText;

  IDContainer({this.imagePath='', this.imageHolder='', this.hintText='', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imagePath == '' ?
      Container(
        height: 220.h,
        width: 342.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.sp)),
            border: Border.all(color: Colors.white, width: 2.sp)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hintText == 'education')
              Opacity(
                opacity: 0.7.sp,
                child: Column(
                  children: [
                    CustomText(text:'Note:', weight: FontWeight.w500, size: 13.sp, color: Colors.white, ),
                    CustomText(text:'You can scan any other document that', weight: FontWeight.w500, size: 13.sp, color: Colors.white, ),
                    CustomText(text:'proves you’re a university student.', weight: FontWeight.w500, size: 13.sp, color: Colors.white, ),
                  ],
                ),
              ),
            SvgPicture.asset(imageHolder),

            if (hintText != 'education')
              Opacity(
                opacity: 0.7,
                child: hintText.length > 5 ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(text:'Take a picture holding the ID.', weight: FontWeight.w500, size: 13.sp, color: Colors.white, ),
                  ],
                )
                : hintText == '' ?
                CustomText(text: '', weight: FontWeight.w600, size: 0, color: Colors.white)
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(text:'Scan the ', weight: FontWeight.w500, size: 13.sp, color: Colors.white, ),
                    CustomText(text: hintText, weight: FontWeight.w500, size: 13.sp, color: secondary, ),
                    CustomText(text:' of the ID', weight: FontWeight.w500, size: 13.sp, color: Colors.white, ),
                  ],
                ),
              )
          ],
        ),
      )
    : Container(
      height: 220.h,
      width: 342.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
          border: Border.all(color: Colors.white, width: 2.sp)
      ),
      child: Image.file(File(imagePath)),
    );
  }
}
