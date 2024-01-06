import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../color_const.dart';

class AboutUsDetails extends StatelessWidget {
  String text;
  double? width;
  String svgIconPath;
  bool? smallText = true;
  Color? color;
  VoidCallback onTap;

  AboutUsDetails({required this.text, required this.svgIconPath , required this.width ,this.smallText,required this.color,required this.onTap});
  @override
  Widget build(BuildContext context) {
    return  InkWell(onTap:onTap ,
      borderRadius: BorderRadius.circular(10.sp),highlightColor: secondary,
      child: Container(
        height: 50.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.05),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Icon(icon,color: Colors.white,),

            Container(
              constraints: BoxConstraints(
                maxWidth: (this.smallText == true)?100.w:200.w,
              ),
              child: Padding(
                padding:  EdgeInsets.fromLTRB(10.h, 0, 0, 0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(width: width),
            SvgPicture.asset("${this.svgIconPath}"),

          ],
        ),
      ),
    );
  }
}