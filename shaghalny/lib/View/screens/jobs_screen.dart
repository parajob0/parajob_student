import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaghalny/View/components/core/custom_text.dart';
import 'package:shaghalny/View/components/core/loading_indicator.dart';
import 'package:shaghalny/ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../color_const.dart';
import 'applied_jobs_screen.dart';
import 'approved_jobs_screen.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({Key? key}) : super(key: key);

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          PreferenceCubit preferenceCubit =  BlocProvider.of<PreferenceCubit>(context, listen: true);
          var jobCubit = JobsCubit.get(context);
          if(jobCubit.appliedJobYearModelList.isEmpty){
            jobCubit.fillJobs(preferenceCubit, context);
          }
          return(preferenceCubit.userModel != null)
              ? Stack(
            children: [
              DefaultTabController(
                length: 2,
                child: Scaffold(
                  backgroundColor: primary,
                  appBar: AppBar(
                    backgroundColor: primary,
                    elevation: 0.0,
                    bottom: TabBar(
                      indicatorColor: secondary,
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                      indicatorPadding: EdgeInsets.fromLTRB(30.sp, 0, 30.sp, 0),
                      indicatorWeight: 3,
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                            // Use the default focused overlay color
                            return states.contains(MaterialState.focused)
                                ? null
                                : Colors.transparent;
                          }),

                      indicator: const UnderlineTabIndicator(
                        // borderRadius: BorderRadius.circular(15.sp),
                        borderSide: BorderSide(color: secondary, width: 2),
                      ),
                      tabs: [
                        Tab(
                          child: Text(
                            "Applied jobs",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Tab(
                          child: Row(
                            children: [
                              Text(
                                "Approved jobs  ",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Container(
                              //   width: 15.w,
                              //   height: 15.h,
                              //   decoration: BoxDecoration(
                              //     color: Colors.transparent,
                              //     borderRadius: BorderRadius.circular(20.sp),
                              //     border: Border.all(color: secondary),
                              //   ),
                              //   child: Center(
                              //     child: BlocConsumer<JobsCubit, JobsState>(
                              //       listener: (context, state) {
                              //         // TODO: implement listener
                              //       },
                              //       builder: (context, state) {
                              //         var cubit = JobsCubit.get(context);
                              //         return CustomText(text: "${cubit.approvedJobYearModelList.length}",
                              //           weight: FontWeight.w600,
                              //           size: 12.sp,
                              //           color: secondary,
                              //         );
                              //       },
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      AppliedJobsScreen(),
                      ApprovedJobsScreen(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 81.h, 35.w, 0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 20.sp,
                    height: 20.sp,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20.sp),
                      border: Border.all(color: secondary),
                    ),
                    child: Center(
                      child: BlocConsumer<JobsCubit, JobsState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          var cubit = JobsCubit.get(context);
                          return InkWell(
                              onTap: () {
                                //cubit.fillJobs();
                              },
                              child: CustomText(text: "${cubit.approvedJobYearModelList.length}",
                                weight: FontWeight.w600,
                                size: 12.sp,
                                color: secondary,
                              ));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
              :LoadingIndicator();
        }
    );
  }
}