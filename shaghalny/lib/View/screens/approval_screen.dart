import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shaghalny/color_const.dart';

import '../components/core/animated_splash_screen.dart';
import '../components/core/custom_text.dart';

class ApprovalScreen extends StatelessWidget {
  const ApprovalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const AnimatedSplash(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                      text: "PARA",
                      weight: FontWeight.w300,
                      size: 58.sp,
                      color: Colors.white),
                  CustomText(
                      text: "JOB",
                      weight: FontWeight.w700,
                      size: 58.sp,
                      color: Colors.white),
                ],
              ),
              SizedBox(height: 80.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: RichText(
                  textAlign: TextAlign.center,
                    text: TextSpan(
                        children: [
                          TextSpan(text: "You're ",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white),
                          ),
                          TextSpan(text: 'waitlisted',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: secondary),
                          ),
                          TextSpan(text: '! Please wait for your account to be approved.',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: Colors.white),
                          ),
                        ]
                    )
                ),
              )
            ],
          )
        ]
      ),
    );
  }
}
