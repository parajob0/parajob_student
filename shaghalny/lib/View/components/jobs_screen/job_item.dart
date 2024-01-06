import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaghalny/Model/jobs_model/applied_job_model.dart';
import 'package:shaghalny/Model/jobs_model/job_model.dart';
import 'package:shaghalny/View/components/core/custom_text.dart';
import 'package:shaghalny/View/components/core/dialog.dart';
import 'package:shaghalny/View/screens/Alerts/sign_the_contract.dart';
import 'package:shaghalny/View/screens/applied_jobs_screen.dart';
import 'package:shaghalny/View/screens/apply_for_job_screen.dart';
import 'package:shaghalny/ViewModel/cubits/home_cubit/home_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/sign_job_contract/sign_job_contract_cubit.dart';
import 'package:shaghalny/utils/page_route.dart';
import '../../../color_const.dart';

class JobItem extends StatefulWidget {
  AppliedJobModel job;
  Color borderColor;

  JobItem({required this.job, required this.borderColor});

  @override
  State<JobItem> createState() => _JobItemState();
}

class _JobItemState extends State<JobItem> {
  List<String>arr=['Approved','Pending','Declined','Upcoming','Sign contract','Completed'];
  late int endTime;
  late CountdownTimerController controller;
  bool validApplication = true;

  Color getStateColor(int state) {
    if (state == 0) {
      return secondary;
    } else if (state == 1) {
      return Color.fromRGBO(184, 186, 187, 1);
    } else if (state == 2) {
      return Colors.red;
    } else {
      return secondary;
    }
  }

  String getState(int num){
    return arr[num];
  }

  // function to calculate endTime
  int calculateEndTime(){
    DateTime approved =  widget.job.approvedTime?.toDate()??DateTime.now();
    DateTime jobStartTime = widget.job.jobModel.startDate.toDate();

    Duration difference = jobStartTime.difference(approved);
    int daysLeft = difference.inDays.abs();

    if(daysLeft<=1) {
      return 1;
    } else if(daysLeft>=2 && daysLeft<=4) {
      return 24;
    } else {
      return 72;
    }
  }

  @override
  void initState() {
    super.initState();

    int addHours =0;
    if(widget.job.state == 4){
      addHours = calculateEndTime();
      endTime = widget.job.approvedTime!.toDate().add(Duration(hours: addHours)).millisecondsSinceEpoch;
    }else{
      endTime=0;
    }
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);

  }

  void onEnd() async{
    // delete from database
    if(widget.job.state==4){
      print('ended');
      validApplication=false;
      var cubit =JobsCubit.get(context);
      await cubit.deleteJobWhenTimeEnds(jobID: widget.job.jobModel.jobId);
      await cubit.deleteJob(jobId: widget.job.jobModel.jobId, context: context, removeFromApplied: false, removeFromApproved: true);
      // update state locally to 2 (in userModel)
      // remove from approved jobs;
    }
  }

  dynamic nextScreen(){
    int state = widget.job.state;
    if(state == 4 ){
      if(validApplication==true){
        showDialog(context: context, builder: (context){return AlertToSignContract();});

      }else{
        return ApplyForJobScreen(model: widget.job.jobModel,);
      }
    }else{
      return ApplyForJobScreen(model: widget.job.jobModel,);
    }
  }


  @override
  Widget build(BuildContext context) {
    HomeCubit homeCubit = HomeCubit.get(context);
    return InkResponse(
      onTap: (){
        print("clicked");
        SignJobContractCubit.setJobId(widget.job.jobModel.jobId);
        // dynamic screen = nextScreen();
        // 0 - approved
        // 1 - pending
        // 2 - declined
        // 3 - upcoming
        // 4 - signContract
        // 5 - done (need to be added)
        // 6 -
        // how to know if its last job ?
        if(widget.job.state == 4 && validApplication){
          customDialog(context:context,dialog:AlertToSignContract());
          // showDialog(context: context, builder: (context){return ;});
        }
        else if (widget.job.state!=2){
          // find next job
          AppNavigator.customNavigator(context: context, screen:  ApplyForJobScreen(model: widget.job.jobModel), finish: false);
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
            color: primary,
            border: Border.all(color: widget.borderColor),
            borderRadius: BorderRadius.all(Radius.circular(10.sp)),
            boxShadow: const[
              BoxShadow(
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CountdownTimer(
                    endTime: endTime,
                    onEnd: onEnd,
                    widgetBuilder: (context,time){
                      return InkWell(
                        onTap: (){
                          String days = "0";
                          String hours = "0";
                          String min = "0";
                          if(time!=null){
                            if(time.days != null){
                              days= time.days.toString();
                            }
                            if(time.hours != null){
                              hours= time.hours.toString();
                            }
                            if(time.min != null){
                              min= time.min.toString();
                            }
                          }
                          print(days);
                          print(hours);
                          print(min);
                          print(time);
                          print(endTime);
                        },
                        child: Container(
                          width: 46.w,
                          height: 46.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                            image: DecorationImage(
                              image: NetworkImage(widget.job.jobModel.image),
                              fit: BoxFit.contain,
                              opacity: (widget.job.state == 4) //'Sign contract'
                                  ?(time!=null && time.days==null)
                                  ? 0.5
                                  : 0.5
                                  :1,
                            ),
                          ),
                          child: (widget.job.state == 4) // 'Sign contract'
                              ?(time!=null)
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if(time.days!=null)
                                CustomText(
                                  text: (time!=null && time.days!=null && time.days!=0)?"${time.days}d":"",
                                  weight: FontWeight.w600,
                                  size: 6.sp,
                                  color: Colors.white),
                              if(time.hours!=null)
                                CustomText(
                                  text: (time!=null && time.hours!=null)?"${time.hours}h":"0h",
                                  weight: FontWeight.w600,
                                  size: 6.sp,
                                  color: Colors.white),
                              CustomText(
                                text: (time!=null && time.min!=null)?"${time.min}min":"0min",
                                weight: FontWeight.w600,
                                size: 6.sp,
                                color: Colors.white,
                              ),
                            ],
                          )
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                  text: "Ended",
                                  weight: FontWeight.w600,
                                  size: 12.sp,
                                  color: Colors.white),
                            ],
                          )
                              :null,
                        ),
                      );
                    }
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [

                        //todo
                        CustomText(
                            text: widget.job.jobModel.position,
                            weight: FontWeight.w600,
                            size: 16.sp,
                            color: Colors.white),
                        CustomText(
                            text: " at",
                            weight: FontWeight.w400,
                            size: 14.sp,
                            color: Colors.white.withOpacity(0.7)),
                      ],
                    ),
                    //todo
                    CustomText(
                      text: widget.job.jobModel.employerModel.name,
                      weight: FontWeight.w700,
                      size: 12.sp,
                      color: const Color.fromRGBO(184, 186, 187, 1),
                    ),
                  ],
                )
              ],
            ),
            CustomText(
              text: getState(widget.job.state),
              weight: FontWeight.w600,
              size: 16.sp,
              color: getStateColor(widget.job.state),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}