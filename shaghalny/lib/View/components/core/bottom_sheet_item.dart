import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BottomSheetItem extends StatelessWidget {
  String text;
  VoidCallback ontap;
  bool editProfilePic;
  Color textColor;
  BottomSheetItem({required this.text, required this.ontap ,this.editProfilePic = false,this.textColor=Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.05),
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
        child: InkWell(
          onTap: ontap,
          child: Row(
            mainAxisAlignment: (editProfilePic)?MainAxisAlignment.center:MainAxisAlignment.start,
            children: [
              Text(
                "${text}",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),
              if(!editProfilePic)
                Spacer(),
              if(!editProfilePic)
                SvgPicture.asset(
                  "assets/next.svg",
                  width: 7.w,
                  height: 12.h,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
