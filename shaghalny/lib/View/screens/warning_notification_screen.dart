import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../ViewModel/cubits/warnings_cubit/warnings_cubit.dart';
import '../components/core/small_job_container.dart';
import '/color_const.dart';
import '../components/core/custom_text.dart';
import 'apply_for_job_screen.dart';

class WarningNotificationScreen extends StatefulWidget {
  WarningNotificationScreen({Key? key}) : super(key: key);

  @override
  State<WarningNotificationScreen> createState() =>
      _WarningNotificationScreenState();
}

class _WarningNotificationScreenState extends State<WarningNotificationScreen> {

  @override
  Widget build(BuildContext context) {
    PreferenceCubit preferenceCubit =
        BlocProvider.of<PreferenceCubit>(context, listen: true);
    return BlocProvider(
      create: (context) => WarningsCubit()
        ..getWarnings(warnings: preferenceCubit.userModel!.warnings),
      child: BlocConsumer<WarningsCubit, WarningsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          WarningsCubit warningsCubit = WarningsCubit.get(context);
          return warningsCubit.gotWarningJobs
              ? Scaffold(
                  backgroundColor: primary,
                  body: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24.w, 50.h, 24.w, 0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkResponse(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            'assets/backWhite.svg',
                            width: 12.w,
                            height: 20.h,
                          ),
                        ),
                        SizedBox(height: 25.h),
                        Center(
                          child: CustomText(
                              text: "WARNING!",
                              size: 25.sp,
                              weight: FontWeight.w600,
                              color: Colors.red),
                        ),
                        SizedBox(height: 10.h),
                        Center(
                          child: CustomText(
                            text: "Violation of the application rules",
                            size: 14.sp,
                            weight: FontWeight.w600,
                            color: Colors.white,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_amber,
                              color: Colors.red,
                              size: 40.sp,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Icon(Icons.warning_amber,
                                color: warningsCubit.jobs.length >= 2
                                    ? Colors.red
                                    : Colors.white,
                                size: 40.sp),
                            SizedBox(
                              width: 10.w,
                            ),
                            Icon(Icons.warning_amber,
                                color: warningsCubit.jobs.length == 3
                                    ? Colors.red
                                    : Colors.white,
                                size: 40.sp)
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Center(
                          child: CustomText(
                            text:
                                "${warningsCubit.jobs.length} out of 3 violations",
                            size: 14.sp,
                            weight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
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
                                  InkResponse(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ApplyForJobScreen(
                                                      model: warningsCubit.jobs[index])));
                                    },
                                    child: SmallJobContainer(
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
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(color: secondary));
        },
      ),
    );
  }
}
