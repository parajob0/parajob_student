import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaghalny/ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import 'package:shaghalny/color_const.dart';
import '../../utils/job_functions/job_functions.dart';
import '../../Model/jobs_model/job_year_model.dart';
import '../components/jobs_screen/job_year_view.dart';

class ApprovedJobsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16.h,
              ),
              Text(
                "This category includes all your approved jobs, here you sign your contracts and view your jobs.",
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
                  // TODO: implement listener
                },
                builder: (context, state) {
                  var cubit = JobsCubit.get(context);
                  if(state is FillJobsLoading){
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(color: secondary,),
                      ],
                    );
                    // return CircularProgressIndicator(color: secondary,);
                  }
                  else{
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: cubit.approvedJobYearModelList.length,
                      itemBuilder: (context, index) {
                        //todo
                        return JobYearView(jobYearModel: cubit.approvedJobYearModelList[index]);
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