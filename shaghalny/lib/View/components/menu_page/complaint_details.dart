import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../color_const.dart';

class ComplaintDetails extends StatelessWidget {
  String text;
  String subText;
  double? width;
  bool? smallText = true;
  Color? color;
  VoidCallback onTap;

  ComplaintDetails({required this.text, required this.subText , required this.width ,required this.onTap ,this.smallText,required this.color});
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.sp),highlightColor: secondary,
      child: Container(
        height: 80.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.05),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Icon(icon,color: Colors.white,),

            Container(padding: EdgeInsets.fromLTRB(10.w, 10.h, 0, 10.h),
              constraints: BoxConstraints(
                maxWidth: (this.smallText == true)?100.w:200.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${text}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 15.w,),
                  Text(
                    "${subText}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          //  SizedBox(width: width),
         //   SvgPicture.asset("${this.svgIconPath}"),

          ],
        ),
      ),
    );
  }
}