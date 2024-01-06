import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shaghalny/View/components/core/loading_indicator.dart';
import 'package:shaghalny/ViewModel/cubits/apply_for_job_cubit/apply_for_job_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import 'package:shaghalny/color_const.dart';
import 'package:shaghalny/view/components/core/alert_message.dart';
import 'package:shaghalny/view/screens/signup_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertToDeleteApplication extends StatelessWidget {
  String jobId;
  JobsCubit jobsCubit;
  AlertToDeleteApplication({Key? key, required this.jobId ,required this.jobsCubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApplyForJobCubit, ApplyForJobState>(
      listener: (context, state) {
        // TODO: implement listener
        if(state is DeleteJobSuccess){
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var cubit = ApplyForJobCubit.get(context);
        return Scaffold(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.05),
          body: Stack(
            children: [
              AlertDialogWithDeleteButton(
                hintText:"",
                // hintText: "Warning: if you try to delete your application 48 hours before this you will pay a fee on your next job",
                messageText: "Are you sure that you want to delete your application for this job?",
                height: 20.h,
                buttonText: "Delete my application",
                onTap: () async{
                  cubit.changeApplyForJobLoadingIndicator(true);
                  await cubit.deleteJob(jobId, context).then((value){
                    jobsCubit.deleteJob(jobId: jobId, context: context, removeFromApplied: true, removeFromApproved: true);
                  });
                  cubit.changeApplyForJobLoadingIndicator(false);
                },
              ),
              (cubit.applyForJobLoadingIndicator==true)?LoadingIndicator():Container(),
            ],
          ),
        );
      },
    );
  }
}