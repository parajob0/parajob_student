import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shaghalny/Model/user_model/user_model.dart';
import 'package:shaghalny/View/screens/bottom_navigation_screen.dart';
import 'package:shaghalny/ViewModel/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'package:shaghalny/ViewModel/database/cache_helper/cache_helper.dart';
import 'package:shaghalny/color_const.dart';
import 'package:shaghalny/utils/page_route.dart';
import 'package:shaghalny/view/components/core/alert_message.dart';
import 'package:shaghalny/view/screens/signup_screen.dart';

class AlertContractSigned extends StatelessWidget {
  AlertContractSigned({Key? key}) : super(key: key);
  ConfettiController _centerController =
  ConfettiController(duration: Duration(seconds: 10));

  @override
  Widget build(BuildContext context) {
    _centerController.play();
    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.05),
        body: WillPopScope(
          onWillPop: () async {
            AppNavigator.customNavigator(
                context: context, screen: BottomNavigation(index: 0,), finish: true);
            return false;
          },
          child: Stack(
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
              InkWell(
                  onTap: () async{
                    // String? uid = UserModel.getID();
                    // await cubit.getCurrentUser(uid);
                    AppNavigator.customNavigator(context: context, screen: BottomNavigation(index: 0,), finish: true);

                  },
                  child: AlertDialogWithoutButton(
                      messageText:
                      "Your contract for this job is signed successfully.🎉")),
            ],
          ),
        ));
  }
}