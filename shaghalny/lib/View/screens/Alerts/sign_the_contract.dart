// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaghalny/Model/user_model/user_model.dart';
import 'package:shaghalny/View/components/core/loading_indicator.dart';
import 'package:shaghalny/View/screens/contract_screen.dart';
import 'package:shaghalny/View/screens/verify_number.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/verify_number_cubit/vertify_number_cubit.dart';
import 'package:shaghalny/color_const.dart';
import 'package:shaghalny/utils/page_route.dart';
import 'package:shaghalny/view/components/core/alert_message.dart';
import 'package:shaghalny/view/screens/signup_screen.dart';

class AlertToSignContract extends StatelessWidget {
  AlertToSignContract({Key? key}) : super(key: key);
  ConfettiController _centerController =
  ConfettiController(duration: Duration(seconds: 10));

  @override
  Widget build(BuildContext context) {
    _centerController.play();
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.05),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _centerController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 1,
              emissionFrequency: 0.03,
              numberOfParticles: 10,
              gravity: 0,
            ),
          ),
          BlocConsumer<VertifyNumberCubit, VertifyNumberState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is SendOTPPhoneNumberSuccess) {
                print("here2");
                var cubit = VertifyNumberCubit.get(context);
                cubit.changeSendOTPLoadingIndecator(false);

                AppNavigator.customNavigator(
                  context: context, screen: VerifyNumber(

                  // navigate to OTP screen
                  showProgressBar: false,
                  nextScreen: ContractScreen(),
                ), finish: false,);
              }
            },
            builder: (context, state) {
              var cubit = VertifyNumberCubit.get(context);
              return BlocConsumer<PreferenceCubit, PreferenceState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  var preferenceCubit = PreferenceCubit.get(context);
                  return AlertDialogWithButtonWithoutIcon(
                    messageText:
                    "Congrats! your application for this job is accepted.🎉",
                    buttonText: "Sign the contract",
                    warningText: "",
                    onTap: () async {
                      // send OTP
                      cubit.changeSendOTPLoadingIndecator(true);
                      print(preferenceCubit.userModel?.phoneNumber);
                      print("here1");
                      String phoneNumber = preferenceCubit.userModel?.phoneNumber??"";
                      await cubit.phoneAuthentication(phoneNumber, 3, context);
                      print("here3");
                      // cubit.changeSendOTPLoadingIndecator(false);
                    },
                  );
                },
              );
            },
          ),
          BlocConsumer<VertifyNumberCubit, VertifyNumberState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              var cubit = VertifyNumberCubit.get(context);
              return (cubit.sendOTPLoadingIndecator == true)
                  ? LoadingIndicator()
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}