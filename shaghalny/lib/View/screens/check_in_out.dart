import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shaghalny/View/screens/bottom_navigation_screen.dart';
import 'package:shaghalny/View/screens/qr_code.dart';
import 'package:shaghalny/View/screens/qr_code_out.dart';
import 'package:shaghalny/ViewModel/database/cache_helper/cache_helper.dart';
import 'package:shaghalny/utils/page_route.dart';
// import 'package:workmanager/workmanager.dart';
import '../../Model/jobs_model/job_model.dart';
import '../../ViewModel/cubits/check_in_out_cubit/check_in_out_cubit.dart';
import '../../ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../main.dart';
import '/View/components/core/buttons.dart';
import '/View/components/core/custom_text.dart';
import '/color_const.dart';
import 'package:intl/intl.dart';

import 'Alerts/check_in_out_alert.dart';
import 'Alerts/otp_failed.dart';
// import 'package:wakelock/wakelock.dart';

class CheckInOut extends StatefulWidget {
  bool checkInQrCoded;
  bool checkOutQrCoded;
  int jobDurationInSeconds;
  int jobDurationInHours;
  JobModel? model;
  String lastJobId;

  CheckInOut({
    this.checkInQrCoded = false,
    this.checkOutQrCoded = false,
    this.jobDurationInSeconds = 0,
    this.jobDurationInHours = 0,
    this.model,
    required this.lastJobId,
  });

  @override
  State<CheckInOut> createState() => _CheckInOutState();
}

class _CheckInOutState extends State<CheckInOut> with TickerProviderStateMixin {
  late AnimationController controller;
  String formattedTimeIn = "";
  String formattedTimeOut = "";
  String formattedTimeSaved = "";
  String formattedExtraTime = "";
  late DateTime extraTime;

  DateTime timeIn = DateTime.now();

  late DateTime timeOut;

  late DateTime timeSaved;

  String difference = "";

  String value = "";

  String stateYesOrNo = "no";
  int amount = 0;
  String reason = "nothing";

  DateTime? startDate;

  DateTime? endDate;

  Timestamp? endDateTimeStamp;

  Timestamp? startDateTimeStamp;

  int? calculatedStartTime;

  int? jobTimeInHours;

  bool isPlaying = false;
  String checkButton = 'Check in';
  String checkHint = 'in';
  Color checkInDotColor = Colors.grey;
  Color checkOutDotColor = Colors.grey;
  Color extraTimeDotColor = Colors.grey;
  int operation = 0;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours} : ${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')} : ${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours} : ${(count.inMinutes % 60).toString().padLeft(2, '0')} : ${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  @override
  void initState() {

    super.initState();
    /*  startDateTimeStamp=widget.model!.startDate;
      endDateTimeStamp=widget.model!.endDate;
      startDate=startDateTimeStamp!.toDate();
      endDate=endDateTimeStamp!.toDate();*/



    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.jobDurationInSeconds),
    );
    if (widget.checkInQrCoded == true) {
    /*  Workmanager().registerOneOffTask(
        "CheckINOUT",
        "CheckINOUT",
      );*/
      controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
      setState(() {
        isPlaying = true;
        checkButton = "Check out";
        checkHint = "out";
        checkInDotColor = secondary;
        formattedTimeIn = DateFormat.jm().format(DateTime.now());
        timeIn = DateTime.now();
        calculatedStartTime =
            timeIn.difference(widget.model!.startDate.toDate()).inMinutes;
        if (calculatedStartTime! > 15 && calculatedStartTime! <= 30) {
          amount = ((widget.model!.salary * 10) / 100).floor();
          reason = "late";
          stateYesOrNo = "yes";
        } else if (calculatedStartTime! > 30 && calculatedStartTime! <= 60) {
          amount = ((widget.model!.salary * 20) / 100).floor();
          reason = "too late";
          stateYesOrNo = "yes";
        } else if (calculatedStartTime! > 60) {
          amount = ((widget.model!.salary * 40) / 100).floor();
          reason = "too late";
          stateYesOrNo = "yes";
        }
       // CacheHelper.setData(key: "check", value: "yes");
      });
    }
    controller.addListener(() {
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
        controller.addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            print('completed');
          }
          timeSaved = DateTime.now();
          print(DateFormat.jm().format(timeSaved));
          operation = 1;
        });
      } else {
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    JobsCubit jobsCubit = JobsCubit.get(context);

    PreferenceCubit prefCubit =
    BlocProvider.of<PreferenceCubit>(context, listen: true);
    CheckInOutCubit checkCubit =
    BlocProvider.of<CheckInOutCubit>(context, listen: true);



//jobTimeInHours=int.parse(endDate!.difference(startDate!).inHours.toString());
    return WillPopScope(
      onWillPop: ()async
      {if(widget.checkInQrCoded==true){
        return false;
      }
      else {

        return true;
      }
      },
      child: Scaffold(
        backgroundColor: primary,
        body: Container(
          height: 1.sh - 0.04.sh,
          padding: EdgeInsets.fromLTRB(24.w, 50.h, 24.w, 0.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*InkResponse(
                onTap: () {Navigator.pop(context);},
                child: SvgPicture.asset(
                  'assets/backWhite.svg',
                  width: 12.w,
                  height: 20.h,),),*/
                SizedBox(height: 15.h),
                CustomText(
                  text: "Check in & out",
                  size: 24.sp,
                  weight: FontWeight.w400,
                  color: Colors.white,
                ),
                SizedBox(height: 10.h),
                Stack(children: <Widget>[
                  Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 80 / 2.0,
                        ),
                        child: Container(
                          height: 300.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Color.fromRGBO(255, 255, 255, 0.1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8.0,
                                offset: Offset(0.0, 5.0),
                              ),
                            ],
                          ),
                          width: double.infinity,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 80 / 2,
                              ),
                              CustomText(
                                  text:
                                  widget.jobDurationInHours > 0 ? '${widget.jobDurationInHours}-Hours shift' : '${widget.jobDurationInSeconds/60}--Minutes shift',
                                  weight: FontWeight.w500,
                                  size: 17.sp,
                                  color: Colors.white),
                              SizedBox(height: 20.h),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 220.w,
                                    height: 200.h,
                                    child: CircularProgressIndicator(
                                      backgroundColor: secondary,
                                      color: secondary,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.grey.shade700),
                                      value: progress,
                                      strokeWidth: 5,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: AnimatedBuilder(
                                      animation: controller,
                                      builder: (context, child) => Text(
                                        countText,
                                        style: GoogleFonts.poppins(
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.0,
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Center(
                            child: Container(
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    prefCubit.userModel!.profilePic!),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
                SizedBox(
                  height: 10.h,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.fiber_manual_record,
                            color: checkInDotColor, size: 12),
                        SizedBox(
                          width: 5.w,
                        ),
                        CustomText(
                            text: "Checked in at :",
                            weight: FontWeight.w400,
                            size: 15.sp,
                            color: hintColor),
                        SizedBox(
                          width: 5.w,
                        ),
                        CustomText(
                            text: formattedTimeIn,
                            weight: FontWeight.w400,
                            size: 15.sp,
                            color: Colors.white),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(4.w, 0, 0, 0),
                      child: Column(
                        children: [
                          Icon(Icons.fiber_manual_record,
                              color: Colors.grey, size: 2),
                          Icon(Icons.fiber_manual_record,
                              color: Colors.grey, size: 2),
                          Icon(Icons.fiber_manual_record,
                              color: Colors.grey, size: 2),
                          Icon(Icons.fiber_manual_record,
                              color: Colors.grey, size: 2),
                          Icon(Icons.fiber_manual_record,
                              color: Colors.grey, size: 2),
                          Icon(Icons.fiber_manual_record,
                              color: Colors.grey, size: 2),
                          Icon(Icons.fiber_manual_record,
                              color: Colors.grey, size: 2),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.fiber_manual_record,
                            color: checkOutDotColor, size: 12),
                        SizedBox(
                          width: 5.w,
                        ),
                        CustomText(
                            text: "Checked out at :",
                            weight: FontWeight.w400,
                            size: 15.sp,
                            color: hintColor),
                        SizedBox(
                          width: 5.w,
                        ),
                        CustomText(
                            text: formattedTimeOut,
                            weight: FontWeight.w400,
                            size: 15.sp,
                            color: Colors.white),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(4.w, 0, 0, 0),
                      child: Column(
                        children: [
                          Icon(Icons.fiber_manual_record,
                              color: Colors.grey, size: 2),
                          Icon(Icons.fiber_manual_record,
                              color: Colors.grey, size: 2),
                          Icon(Icons.fiber_manual_record,
                              color: Colors.grey, size: 2),
                          Icon(Icons.fiber_manual_record,
                              color: Colors.grey, size: 2),
                          Icon(Icons.fiber_manual_record,
                              color: Colors.grey, size: 2),
                          Icon(Icons.fiber_manual_record,
                              color: Colors.grey, size: 2),
                          Icon(Icons.fiber_manual_record,
                              color: Colors.grey, size: 2),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.fiber_manual_record,
                            color: extraTimeDotColor, size: 12),
                        SizedBox(
                          width: 5.w,
                        ),
                        CustomText(
                            text: "Extra time :",
                            weight: FontWeight.w400,
                            size: 15.sp,
                            color: hintColor),
                        SizedBox(
                          width: 5.w,
                        ),
                        CustomText(
                            text: difference,
                            weight: FontWeight.w400,
                            size: 15.sp,
                            color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BlocConsumer<CheckInOutCubit, CheckInOutState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            return PrimaryButton(
                                text: checkButton,
                                onTap: () {


                                  value = "$stateYesOrNo--$amount--$reason--$timeIn";
                                  if (controller.isAnimating) {
                                    setState(()async {
                                      AppNavigator.customNavigator(
                                          context: context,
                                          screen: QrCodeOut(
                                            lastJobId: widget.lastJobId,
                                            value: widget.checkOutQrCoded,
                                            model: widget.model,
                                          ),
                                          finish: false);
                                      final newValue = await Navigator.of(
                                          context).push(MaterialPageRoute(
                                          builder: (context) => QrCodeOut(
                                            lastJobId: widget.lastJobId,
                                            value:
                                            widget.checkOutQrCoded,
                                            model: widget.model,
                                          )));
                                      widget.checkOutQrCoded = newValue;
                                      if (widget.checkOutQrCoded == true) {
                                         controller.reset();
                                        checkButton = "Done";
                                        checkHint = "in";
                                        checkOutDotColor = secondary;
                                        formattedTimeOut = DateFormat.jm()
                                            .format(DateTime.now());
                                        timeOut = DateTime.now();

                                        /* CheckInOutCubit.get(context)
                                              .checkInOutBalance(prefCubit,
                                                  jobId: widget.model!.jobId,
                                                  value: value);*/
                                        prefCubit.userModel!.totalIncome =
                                            prefCubit
                                                .userModel!.totalIncome! +
                                                widget.model!.salary -
                                                amount;
                                        prefCubit.xpLevelUp(
                                            jobModel: widget.model!,
                                            value: "$stateYesOrNo--${amount.toString()}--$reason--$timeIn",
                                            jobsCubit: jobsCubit,
                                            lastJobId: widget.lastJobId);

                                        prefCubit.userModel!.jobHistory!
                                            .addAll({
                                          widget.model!.jobId: "$stateYesOrNo--${amount.toString()}--$reason--$timeIn",
                                        });

                                         checkCubit.deleteInJob(userId: prefCubit.userModel!.id);
                                         prefCubit.userModel!.inJob = '';

                                      }
                                    });

                                  }
                                  else {

                                    if (operation == 0 &&
                                        widget.checkInQrCoded == false) {
                                      setState(() {
                                        // isPlaying = false;
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const CheckInOutAlert();
                                          },
                                        ).then((value) {AppNavigator.customNavigator(
                                            context: context,
                                            screen: QrCodeIn(
                                              lastJobId: widget.lastJobId,
                                              model: widget.model,
                                            ),
                                            finish: false);});


                                      });
                                      checkCubit.addInJob(userId: prefCubit.userModel!.id.toString(), value: "$timeIn--${widget.model!.jobId}");
                                      prefCubit.userModel!.inJob = "$timeIn--${widget.model!.jobId}";


                                    }
                                    else if (operation == 1 &&
                                        widget.checkOutQrCoded == false) {
                                      // controller.stop();
                                      AppNavigator.customNavigator(
                                          context: context,
                                          screen: QrCodeOut(
                                            lastJobId: widget.lastJobId,
                                            value: widget.checkOutQrCoded,
                                            model: widget.model,
                                          ),
                                          finish: false);
                                      setState(() async {
                                        final newValue =
                                        await AppNavigator.customNavigator(
                                            context: context,
                                            screen: QrCodeOut(
                                              lastJobId: widget.lastJobId,
                                              value: widget.checkOutQrCoded,
                                              model: widget.model,
                                            ),
                                            finish: false);
                                        /*  Navigator.of(context).push(MaterialPageRoute
                                   (builder:(context)=>  QrCodeOut(value: widget.checkOutQrCoded,model: widget.model,) ));*/
                                        setState(() {
                                          widget.checkOutQrCoded = newValue;
                                          if (widget.checkOutQrCoded == true) {
                                            checkButton = "Done";
                                            checkHint = "in";
                                            checkOutDotColor = secondary;
                                            extraTimeDotColor = secondary;
                                            formattedTimeOut = DateFormat.jm()
                                                .format(DateTime.now());
                                            //formattedExtraTime=DateFormat.jm().format(DateTime.now());
                                            extraTime = DateTime.now();
                                            difference = extraTime
                                                .difference(timeSaved)
                                                .inMinutes
                                                .toString();
                                            /* CheckInOutCubit.get(context)
                                                .checkInOutBalance(prefCubit,
                                                    jobId: widget.model!.jobId,
                                                    value: value);
                                            print(stateYesOrNo);*/
                                            prefCubit.userModel!.totalIncome =
                                                prefCubit.userModel!
                                                    .totalIncome! -
                                                    amount;

                                            prefCubit.xpLevelUp(
                                                jobModel: widget.model!,
                                                value: "$stateYesOrNo--${amount.toString()}--$reason--$timeIn",
                                                jobsCubit: jobsCubit,
                                                lastJobId: widget.lastJobId);
                                            prefCubit.userModel!.jobHistory!
                                                .addAll({
                                              widget.model!.jobId:
                                              "$stateYesOrNo--${amount.toString()}--$reason--$timeIn",
                                            });
                                            AppNavigator.customNavigator(
                                                context: context,
                                                screen: BottomNavigation(
                                                  index: 0,
                                                ),
                                                finish: true);
                                          }
                                        });
                                      });
                                    }
                                    else if (operation == 1 &&
                                        widget.checkOutQrCoded == true &&
                                        widget.checkInQrCoded == true) {
                                      setState(() {
                                        widget.checkInQrCoded=false;
                                        widget.checkOutQrCoded=false;
                                        widget.jobDurationInSeconds = 0;
                                        widget.jobDurationInHours = 0;
                                        formattedTimeIn="";
                                        formattedTimeOut="";
                                        formattedTimeSaved="";
                                        formattedExtraTime="";
                                        difference="";
                                        value="";
                                        stateYesOrNo = "no";
                                        amount = 0;
                                        reason = "nothing";
                                        isPlaying = false;
                                        checkButton = 'Check in';
                                        checkHint = 'in';
                                        checkInDotColor = Colors.grey;
                                        checkOutDotColor = Colors.grey;
                                        extraTimeDotColor = Colors.grey;
                                        operation = 0;
                                        progress = 1.0;
                                       // Workmanager().cancelByUniqueName("CheckINOUT");
                                       // print("no more execute");

                                        AppNavigator.customNavigator(
                                            context: context,
                                            screen: BottomNavigation(
                                              index: 0,
                                            ),
                                            finish: true);

                                      });
                                    }
                                  }
                                });
                          },
                        ),
                        SizedBox(height: 15.h),
                        CustomText(
                            text:
                            "Check $checkHint by scanning the code from your team leader",
                            weight: FontWeight.w400,
                            size: 12.sp,
                            color: hintColor)
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}