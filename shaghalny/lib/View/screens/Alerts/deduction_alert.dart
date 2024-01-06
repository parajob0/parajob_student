import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shaghalny/View/components/core/custom_text.dart';

import '../../../Model/jobs_model/job_model.dart';
import '../../../color_const.dart';
import '../../components/core/small_job_container.dart';

class DeductionScreen extends StatelessWidget {
  String amount;
  String reason;
  JobModel jobModel;

  DeductionScreen({required this.amount, required this.reason, required this.jobModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: primary,
      insetPadding: EdgeInsets.fromLTRB(12.w, 24.h, 12.w, 24.h),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.sp))),
      title: CustomText(text: "DEDUCTION!", weight: FontWeight.w600, size: 24.sp, color: Colors.white, textAlign: TextAlign.center,),
      icon: Align(alignment: Alignment.topRight,
        child: InkResponse(
          onTap: () {Navigator.pop(context);},
          child: SvgPicture.asset(
            'assets/exit.svg',
            width: 10.w,
            height: 15.h,),),),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 2.h),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  children: [
                    TextSpan(text: 'EGP ',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 20.sp,
                          color: Colors.white.withOpacity(0.7),),
                    ),
                    TextSpan(text: '$amount ',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          color: Colors.white),
                    ),
                    TextSpan(text: 'has been deducted from your paycheck as a result for ',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 20.sp,
                          color: Colors.white.withOpacity(0.7)),
                    ),
                    TextSpan(text: '$reason.',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          color: Colors.white),
                    ),
                  ]
              )
          ),
          SizedBox(height: 17.h),
          SmallJobContainer(
            borderColor: Colors.red, // or red
            balance: true,
            deduction: true,
            position: jobModel.position,
            employer: jobModel.employerModel.name,
            salary: double.parse(amount),
            date: "${jobModel
                .startDate
                .toDate()
                .day} ${DateFormat('MMMM').format(
                jobModel.startDate.toDate())}", //TODO fix date
            imagUrl: jobModel.employerModel.image,
            containerType:"recommended",
          )
        ],
      ),
    );
  }
}
