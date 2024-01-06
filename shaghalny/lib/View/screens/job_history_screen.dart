import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaghalny/View/components/core/sign_in_appBar.dart';
import 'package:shaghalny/View/components/jobs_screen/job_year_view.dart';
import 'package:shaghalny/ViewModel/cubits/job_history_cubit/job_history_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import 'package:shaghalny/color_const.dart';

class JobHistoryScreen extends StatelessWidget {
  const JobHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PreferenceCubit preferenceCubit = BlocProvider.of<PreferenceCubit>(context, listen: true);
    PreferenceCubit preferenceCubit =PreferenceCubit.get(context);
    return BlocProvider(
      create: (context) => JobHistoryCubit()..getJobHistory(context),
      child: Scaffold(
        backgroundColor: primary,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 40.h),
            child: Column(
              children: [
                SignInAppBar(
                  text: 'Your job history',
                  size: 24.sp,
                  progress: 0,
                  showProgressBar: false,
                ),
                BlocConsumer<JobHistoryCubit, JobHistoryState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state)  {
                    var cubit = JobHistoryCubit.get(context);
                    if(state is GetJobHistoryLoading){
                      return CircularProgressIndicator(color: secondary,);
                    }else{
                      return (cubit.jobYearModelList!=null)
                          ?ListView.separated(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount:cubit.jobs.length??1,
                        itemBuilder: (context, index) {
                          if(cubit.jobs!=null){
                            return JobYearView(jobYearModel: cubit.jobYearModelList![index],containerType: 1,);
                          }else{
                            return Container();
                          }
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 10.h,
                          );
                        },
                      )
                          :Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}