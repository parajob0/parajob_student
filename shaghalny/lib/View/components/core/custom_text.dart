import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  String text = 'ddddd';
  FontWeight weight = FontWeight.normal;
  double size = 24.sp;
  Color color = Colors.white;
  TextAlign textAlign;

  // Mina Adde this
  bool isUnderLined;

  CustomText(
      {this.isUnderLined = false,
      required this.text,
      required this.weight,
      required this.size,
      required this.color,
      this.textAlign = TextAlign.left,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: weight,
        fontSize: size,
        color: color,
        decoration:
            (isUnderLined) ? TextDecoration.underline : TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }
}
