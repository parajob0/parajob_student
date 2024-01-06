import 'dart:async';

import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';
import 'package:shaghalny/View/screens/basic_info_signup_screen.dart';
import 'package:shaghalny/View/screens/education_screen.dart';
import 'package:shaghalny/View/screens/signup_screen.dart';
import '../../Model/jobs_model/job_model.dart';
import '/View/components/core/custom_text.dart';
// import '/View/screens/on_boarding/students_on_boarding_screen.dart';
import '/view/screens/signin_screen.dart';
import '../../Model/admin_model/admin_model.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../color_const.dart';
import 'dart:ui' as ui;

import '../components/core/animated_splash_screen.dart';
import 'apply_for_job_screen.dart';
import 'approval_screen.dart';
import 'bottom_navigation_screen.dart';
import 'on_boarding/on_boarding_screen.dart';
import 'warning_screen.dart';

class Splash extends StatefulWidget {

  bool newUser;
  bool toNavigation;
  Splash({required this.newUser, this.toNavigation = false, Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}


class _SplashState extends State<Splash> {
  @override
  void initState(){
    super.initState();
    PreferenceCubit prefCubit = PreferenceCubit.get(context);
    //
    // JobModel? model;
    //
    // debugPrint("\n init state splash screen \n");
    //
    // if(prefCubit.userModel!.inJob.isNotEmpty){
    //
    //   debugPrint("\n inside if condition \n");
    //
    //   DocumentSnapshot jobSnapshot =
    //   await FirebaseFirestore.instance.collection('jobs').doc(prefCubit.userModel!.inJob.split("--")[1].toString().trim()).get();
    //
    //   final data = jobSnapshot.data() as Map<String, dynamic>;
    //
    //   DocumentSnapshot employerSnapshot =
    //       await FirebaseFirestore.instance.collection('employer').doc(data['employer_id'].toString().trim()).get();
    //
    //   model = JobModel.fromDocumentSnapshot(
    //       jobSnapshot as DocumentSnapshot<Map<String, dynamic>>,
    //       employerSnapshot as DocumentSnapshot<Map<String, dynamic>>);
    // }

    Timer(const Duration(seconds: 4), (){
      // !prefCubit.userModel!.isBanned ?
      // prefCubit.userModel!.phoneNumber != "" ?
      // prefCubit.userModel!.isApproved ?
      // // prefCubit.userModel!.inJob.isEmpty ?
      // prefCubit.userModel!.warnings.length == 3 ?
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WarningScreen()))
      // : Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (BuildContext context) =>  widget.toNavigation ? BottomNavigation(index: 0) : widget.newUser ? const OnBoarding():
      //     SigninScreen()))
      // // : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ApplyForJobScreen(model: model as JobModel,)))
      // : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ApprovalScreen()))
      // : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SigninScreen()))
      // : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SigninScreen()));

      !prefCubit.userModel!.isBanned ?
      prefCubit.userModel!.phoneNumber != "" ?
      (!prefCubit.userModel!.isApproved && prefCubit.userModel!.accountName == "") || prefCubit.userModel!.isApproved
          // (prefCubit.userModel!.isApproved && prefCubit.userModel!.accountName == "") ||
          // (prefCubit.userModel!.isApproved && prefCubit.userModel!.accountName != "")
          ?
      // prefCubit.userModel!.inJob.isEmpty ?
      prefCubit.userModel!.warnings.length == 3 ?
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WarningScreen()))
          : Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>  widget.toNavigation ? BottomNavigation(index: 0) : widget.newUser ? const OnBoarding():
          SigninScreen()))
      // : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ApplyForJobScreen(model: model as JobModel,)))
          : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ApprovalScreen()))
          : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SigninScreen()))
          : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SigninScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: primary,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const AnimatedSplash(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                  text: "Welcome to",
                  weight: FontWeight.w700,
                  size: 16.sp,
                  color: Colors.white),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                      text: "PARA",
                      weight: FontWeight.w300,
                      size: 58.sp,
                      color: Colors.white),
                  CustomText(
                      text: "-JOB",
                      weight: FontWeight.w700,
                      size: 58.sp,
                      color: Colors.white),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}