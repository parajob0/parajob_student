import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '/color_const.dart';

class PrimaryButton extends StatelessWidget {
  String text;
  VoidCallback onTap;
  int fontSize;
  PrimaryButton({required this.text, required this.onTap, this.fontSize = 16, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        height: 52.h,
        width: 342.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
          border: Border.all(color: secondary),
          color: secondary,
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: fontSize.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


class SecondaryButton extends StatelessWidget {
  String text;
  VoidCallback onTap;
  Color color;
  SecondaryButton({this.color=Colors.white,required this.text, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        height: 52.h,
        width: 342.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
          border: Border.all(color: color),
          color: primary,
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}


class TertiaryButton extends StatelessWidget {

  Widget child;
  VoidCallback onTap;
  TertiaryButton({required this.child, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        height: 52.h,
        width: 342.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
          border: Border.all(color: Colors.white),
          color: primary,
        ),
        child:child,
      ),
    );
  }
}
