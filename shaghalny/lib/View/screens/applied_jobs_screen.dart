import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaghalny/Model/jobs_model/job_model.dart';
import 'package:shaghalny/Model/jobs_model/job_month_model.dart';
import 'package:shaghalny/Model/jobs_model/job_year_model.dart';
import 'package:shaghalny/View/components/core/loading_indicator.dart';
import 'package:shaghalny/ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import '../../utils/job_functions/job_functions.dart';
import '../../color_const.dart';
import '../components/jobs_screen/job_item.dart';
import '../components/jobs_screen/job_year_view.dart';

class AppliedJobsScreen extends StatelessWidget {
  AppliedJobsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16.h,
              ),
              Text(
                "The jobs you applied for and still waiting whether to be approved and assigned to you or not.",
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              BlocConsumer<JobsCubit, JobsState>(
                listener: (context, state) {

                },
                builder: (context, state) {
                  var cubit = JobsCubit.get(context);
                  if(state is FillJobsLoading){
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: secondary,),
                      ],
                    );
                    // return CircularProgressIndicator(color: secondary,);
                  }
                  else{
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount:cubit.appliedJobYearModelList.length,
                      itemBuilder: (context, index) {
                        return JobYearView(jobYearModel: cubit.appliedJobYearModelList[index],containerType: 0,);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10.h,
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}