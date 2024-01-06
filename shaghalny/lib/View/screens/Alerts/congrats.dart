import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaghalny/color_const.dart';
import 'package:shaghalny/view/components/core/alert_message.dart';
import 'package:shaghalny/view/screens/signup_screen.dart';

class CongratsForApplying extends StatelessWidget {
  CongratsForApplying({Key? key}) : super(key: key);
  ConfettiController _centerController=ConfettiController(duration: Duration(seconds: 10));
  @override
  Widget build(BuildContext context) {
    _centerController.play();
    return  Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.05),
        body:Stack(children:<Widget> [
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

          AlertDialogWithoutButton(messageText: "Congrats! your application for this job is now being considered.🎉"),
          InkWell(onTap: (){
            Navigator.pop(context);
          },),
        ],));
  }
}