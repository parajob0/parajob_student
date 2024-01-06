import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/color_const.dart';

import '../core/custom_text.dart';

class SpecialContainer extends StatelessWidget {

  String imageUrl;
  String employer;
  String salary;
  bool isBlurred;

  SpecialContainer({required this.employer, required this.salary, required this.imageUrl, this.isBlurred=false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.w, 16.h, 15.w, 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.sp)),
        color: isBlurred ? Colors.black.withOpacity(0.5) : secondary.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.sp)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageUrl)
              )
            ),
            // child: Image.network(imageUrl),
          ),
          SizedBox(height: 4.h,),
          CustomText(text: employer, weight: FontWeight.w600, size: 13.sp, color: Colors.white),

          SizedBox(height: 4.h,),
          Row(
            children: [
              CustomText(text: 'EGP ', weight: FontWeight.w300, size: 12.sp, color: Colors.white.withOpacity(0.7)),
              CustomText(text: salary, weight: FontWeight.w600, size: 12.sp, color: Colors.white.withOpacity(0.7)),
            ],
          ),

        ],
      ),
    );
  }
}
