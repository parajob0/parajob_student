import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/View/components/core/custom_text.dart';

import '../../../color_const.dart';

class NotificationContainer extends StatelessWidget {
  String imageUrl;
  String notificationType;
  String employer;
  String position;
  int level;
  bool isClicked;
  String date;

  NotificationContainer(
      {this.imageUrl = '',
      required this.notificationType,
      this.employer = '',
      this.position = '',
      this.level = 0,
      this.isClicked = false,
      required this.date,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isClicked ? primary : Colors.white.withOpacity(0.05),
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
      child: Row(
        children: [
          if (notificationType == "contract" || notificationType == "accept" ||  notificationType == "qr")
            Stack(
              children: [
                Container(
                  width: 46.w,
                  height: 46.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                      image: DecorationImage(
                          image: NetworkImage(imageUrl), fit: BoxFit.cover)),
                ),
                if (notificationType == "qr")
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        "assets/qrcode.svg",
                        width: 15.sp,
                        height: 15.sp,
                      ))
              ],
            ),
          if (notificationType == "level")
            Container(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SvgPicture.asset(
                    "assets/profileLevel.svg",
                    width: 48.w,
                    height: 48.h,
                  ),
                  CustomText(
                    text: "$level", weight: FontWeight.w700, size: 16.sp, color: Colors.white)
                ],
              ),
            ),
          if (notificationType == "warning")
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                  color: Colors.black),
            ),

          SizedBox(width: 8.w),

          if (notificationType == "contract")
            Expanded(
              child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text: 'Warning! Your deadline to sign your contract with ',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            color: Colors.white.withOpacity(0.7)),
                          ),
                        TextSpan(text: employer,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: Colors.white),
                        ),
                        TextSpan(text: ' is coming soon.',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: Colors.white.withOpacity(0.7)),
                        ),
                        TextSpan(text: ' $date',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: Colors.white.withOpacity(0.5)),
                        ),
                      ]
                  )
              )
            ),
          if (notificationType == "accept")
            Expanded(
                child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: 'Congrats! ',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white.withOpacity(0.7)),
                          ),
                          TextSpan(text: employer,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                color: Colors.white),
                          ),
                          TextSpan(text: ' has accepted  you as a ',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white.withOpacity(0.7)),
                          ),
                          TextSpan(text: position,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                color: Colors.white),
                          ),
                          TextSpan(text: '. $date',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: Colors.white.withOpacity(0.5)),
                          ),
                        ]
                    )
                )
            ),
          if (notificationType == "qr")
            Expanded(
                child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: 'Your QR code is ready for you to ',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white.withOpacity(0.7)),
                          ),
                          TextSpan(text: "check in ",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                color: Colors.white),
                          ),
                          TextSpan(text: 'for your job with ',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white.withOpacity(0.7)),
                          ),
                          TextSpan(text: employer,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                color: Colors.white),
                          ),
                          TextSpan(text: '. $date',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: Colors.white.withOpacity(0.5)),
                          ),
                        ]
                    )
                )
            ),
          if (notificationType == "level")
            Expanded(
                child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: 'New level ',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white),
                          ),
                          TextSpan(text: 'has been unlocked!',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white.withOpacity(0.7)),
                          ),
                          TextSpan(text: ' $date',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: Colors.white.withOpacity(0.5)),
                          ),
                        ]
                    )
                )
            ),
          if (notificationType == "warning")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(
                    text: "Warning!",
                    weight: FontWeight.w600,
                    size: 16.sp,
                    color: Colors.white),
                RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: 'Violation of rules',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white.withOpacity(0.7)),
                          ),
                          TextSpan(text: ' $date',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: Colors.white.withOpacity(0.5)),
                          ),
                        ]
                    )
                ),
              ],
            ),
        ],
      ),
    );
  }
}
