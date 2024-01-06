import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class JobDetails extends StatelessWidget {
  String text;
  String svgIconPath;
  bool? smallText = true;
  JobDetails({required this.text, required this.svgIconPath , this.smallText});
  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: Container(
        height: 50.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.05),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Icon(icon,color: Colors.white,),
            SvgPicture.asset("${this.svgIconPath}"),
            SizedBox(
              width: 8.w,
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: (this.smallText == true)?100.w:200.w,
              ),
              child: Text(
                "${text}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}