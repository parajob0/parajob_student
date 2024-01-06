import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../ViewModel/cubits/warnings_cubit/warnings_cubit.dart';
import '../components/core/animated_splash_screen.dart';
import '../components/core/small_job_container.dart';
import '/color_const.dart';
import '../components/core/custom_text.dart';
import 'apply_for_job_screen.dart';

class WarningScreen extends StatefulWidget {
  const WarningScreen({Key? key}) : super(key: key);

  @override
  State<WarningScreen> createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen> {
  @override
  Widget build(BuildContext context) {
    PreferenceCubit preferenceCubit =
        BlocProvider.of<PreferenceCubit>(context, listen: true);
    return BlocProvider(
      create: (context) => WarningsCubit()..getWarnings(warnings: preferenceCubit.userModel!.warnings),
      child: BlocConsumer<WarningsCubit, WarningsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          WarningsCubit warningsCubit = WarningsCubit.get(context);
          return Scaffold(
            backgroundColor: primary,
            body: Stack(alignment: AlignmentDirectional.center,

                /*   height: 1.sh - 0.04.sh,
        padding: EdgeInsets.fromLTRB(24.w, 50.h, 24.w, 0.h),*/
                children: [
                  const AnimatedSplash(),
                  warningsCubit.gotWarningJobs ?
                  SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24.w, 50.h, 24.w, 0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // const AnimatedSplash(),
                        SizedBox(height: 20.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomText(
                                text: "YOUR ACCOUNT HAS BEEN DISABLED!",
                                size: 25.sp,
                                weight: FontWeight.w600,
                                color: Colors.white,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/warning-icon  red.svg',
                              width: 12.w,
                              height: 21.h,
                            ),
                            SizedBox(width: 15.w),
                            SvgPicture.asset(
                              'assets/warning-icon  red.svg',
                              width: 12.w,
                              height: 21.h,
                            ),
                            SizedBox(width: 15.w),
                            SvgPicture.asset(
                              'assets/warning-icon  red.svg',
                              width: 12.w,
                              height: 21.h,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        CustomText(
                          text: "3 out of 3 violations of application rule",
                          size: 14.sp,
                          weight: FontWeight.w400,
                          color: Colors.white,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),


                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: warningsCubit.jobs.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              debugPrint("\n\n jobs --> ${warningsCubit.jobs[index]} \n\n");
                              debugPrint("\n\n pref cubit warnings --> ${preferenceCubit.userModel!.warnings} \n\n");
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: "${warningsCubit.jobs[index].startDate.toDate().day} ${DateFormat('MMMM').format(warningsCubit.jobs[index].startDate.toDate())} ${warningsCubit.jobs[index].startDate.toDate().year}",
                                    size: 14.sp,
                                    weight: FontWeight.w400,
                                    color: Colors.white,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  SmallJobContainer(
                                    position: warningsCubit.jobs[index].position,
                                    employer: warningsCubit.jobs[index]
                                        .employerModel
                                        .name,
                                    salary: warningsCubit.jobs[index].salary
                                        .toDouble(),
                                    date:
                                    "${warningsCubit.jobs[index].startDate.toDate().day} ${DateFormat('MMMM').format(warningsCubit.jobs[index].startDate.toDate())}",
                                    imagUrl: warningsCubit.jobs[index]
                                        .employerModel
                                        .image,
                                    containerType: 'recommended',
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/warning-icon  red.svg',
                                        width: 9.w,
                                        height: 9.h,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),

                                      CustomText(
                                        text: "${preferenceCubit.userModel!.warnings[warningsCubit.jobs[index].jobId]}",
                                        size: 10.sp,
                                        weight: FontWeight.w400,
                                        color: Colors.red,
                                        textAlign: TextAlign.start,
                                      ),
                                      // SizedBox(height: 40,),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                  )
                  :  const Center(child: CircularProgressIndicator(color: secondary)),
                ]),
          );
        },
      ),
    );
  }
}
