import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '/View/components/core/custom_text.dart';

class BulletPoint extends StatelessWidget {
  String text;
  BulletPoint({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/dot.svg', width: 24.w, height: 24.h, color: Colors.white.withOpacity(0.8),),
        CustomText(text: text, weight: FontWeight.w400, size: 14.sp, color: Colors.white.withOpacity(0.8)),
      ],
    );
  }
}
