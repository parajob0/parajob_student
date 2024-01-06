import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shaghalny/Model/jobs_model/job_model.dart';
import 'package:shaghalny/View/components/core/loading_indicator.dart';
import 'package:shaghalny/View/screens/Alerts/congrats.dart';
import 'package:shaghalny/ViewModel/cubits/apply_for_job_cubit/apply_for_job_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/home_cubit/home_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import 'package:shaghalny/color_const.dart';
import 'package:shaghalny/view/components/core/alert_message.dart';
import 'package:shaghalny/view/screens/signup_screen.dart';

class AlertToApplyJob extends StatelessWidget {
  JobModel jobModel;
  JobsCubit jobCubit;
  HomeCubit homeCubit;
  AlertToApplyJob({Key? key,required this.homeCubit , required this.jobModel , required this.jobCubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = ApplyForJobCubit.get(context);
    return BlocConsumer<ApplyForJobCubit, ApplyForJobState>(
      listener: (context, state) {
        // TODO: implement listener
        if(state is ApplyForJobSuccess){
          cubit.changeApplyForJobLoadingIndicator(false);
          Navigator.pop(context);
          showDialog(context: context, builder: (context){
            return CongratsForApplying();
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.05),
          body: Stack(
            children: [
              AlertDialogWithButtonWithoutIcon(
                  messageText: "Are you sure that you want to apply for this job?",
                  buttonText: "Yes, apply for this job",
                  warningText: "Warning: if you try to delete your application 48 hours before this you will pay a fee on your next job",
                  onTap: () async{
                    cubit.changeApplyForJobLoadingIndicator(true);
                    await cubit.applyForJob(jobModel.jobId, context).then((value) async {


                      jobCubit.addToAppliedJobs(jobModel);
                    });
                    cubit.changeApplyForJobLoadingIndicator(false);
                  }),
              (cubit.applyForJobLoadingIndicator==true) ?LoadingIndicator() :Container(),
            ],
          ),
        );
      },
    );
  }
}