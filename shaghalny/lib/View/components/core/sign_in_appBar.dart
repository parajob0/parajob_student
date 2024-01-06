import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/View/components/signup_screen/progress_bar.dart';
import '/color_const.dart';
import 'custom_text.dart';


class SignInAppBar extends StatelessWidget {
  String text;
  FontWeight weight;
  double size = 24.sp;
  Color color;
  int progress;

  String subText;
  FontWeight subWeight;
  double subSize;
  Color subColor;
  bool? showProgressBar = true;
  SignInAppBar(
      {required this.text, this.weight=FontWeight.w600, required this.size, this.color=Colors.white, required this.progress,
        this.subText='', this.subWeight=FontWeight.w500, this.subSize=11, this.subColor=Colors.white,this.showProgressBar=true,
        Key? key}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 60.h, 0.w, 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkResponse(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 20.w,
              height: 20.h,
              child: SvgPicture.asset(
                'assets/backWhite.svg',
                width: 12.w,
                height: 20.h,
              ),
            ),
          ),
          (text != "")?SizedBox(height: 16.h):Container(),
          (showProgressBar == true)?ProgressBar(progress: progress,):Container(),
          (showProgressBar == true)?SizedBox(height: 5.h):SizedBox(height: 0.h),
          (showProgressBar == true)?Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomText(text: '$progress%', weight: FontWeight.w400, size: 12.sp, color: Colors.white),
            ],
          ):Row(),
          (showProgressBar == true)?SizedBox(height: 16.36.h):Container(),
          CustomText(
            text: text,
            size: size,
            weight: weight,
            color: color,
          ),
          Opacity(
            opacity: 0.7,
            child: CustomText(
              text: subText,
              size: subSize,
              weight: subWeight,
              color: subColor,
            ),
          ),
        ],
      ),
    );
  }
}
