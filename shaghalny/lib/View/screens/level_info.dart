import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/View/components/core/custom_text.dart';
import '/View/components/core/progress_bar.dart';

import '../../color_const.dart';
import '../components/core/level_badge.dart';
import '../components/level_info_screen/bullet_point.dart';

class LevelInfo extends StatelessWidget {

  int level;
  LevelInfo({this.level=45, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(16.w, 24.h, 24.w, 32.h),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset('assets/exit.svg', width: 18.w, height: 18.h,),
              ],
            ),
            SizedBox(height: 6.h,),
            SvgPicture.asset('assets/level_cup.svg', width: 120.w, height: 120.h,),
            SizedBox(height: 20.h,),
            CustomText(text: 'You are now on level', weight: FontWeight.w400, size: 16.sp, color: Colors.white.withOpacity(0.7)),
            CustomText(text: '$level', weight: FontWeight.w600, size: 26.sp, color: Colors.white),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: "80%", weight: FontWeight.w500, size: 10.sp, color: secondary),
                SizedBox(width: 8.w),
                CustomProgressBar(progress: 0.8,width: 100.w,height: 6.h,),
                SizedBox(width: 8.w),
                BigLevelBadge(level: "${level+1}",),
              ],
            ),

            SizedBox(height: 35.h,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(text: "How to level up?", weight: FontWeight.w500, size: 16.sp, color: Colors.white),
              ],
            ),
            SizedBox(height: 8.h,),
            BulletPoint(text: 'Lorem ipsum dolor sitmet',),
            BulletPoint(text: 'Lorem ipsum dolor sitmet',),
            BulletPoint(text: 'Lorem ipsum dolor sitmet',),

            SizedBox(height: 16.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(text: "Why to level up?", weight: FontWeight.w500, size: 16.sp, color: Colors.white),
              ],
            ),
            SizedBox(height: 8.h,),
            BulletPoint(text: 'Lorem ipsum dolor sitmet',),
            BulletPoint(text: 'Lorem ipsum dolor sitmet',),
            BulletPoint(text: 'Lorem ipsum dolor sitmet',),

          ],
        ),
      );
  }
}
