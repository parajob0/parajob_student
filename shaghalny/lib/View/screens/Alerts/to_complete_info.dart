import 'package:flutter/material.dart';
import 'package:shaghalny/color_const.dart';
import 'package:shaghalny/utils/page_route.dart';
import 'package:shaghalny/view/components/core/alert_message.dart';
import 'package:shaghalny/view/screens/signup_screen.dart';

class AlertToCompleteInfo extends StatelessWidget {
  dynamic screen;
  bool isProfilePic;

  AlertToCompleteInfo({Key? key, required this.screen, this.isProfilePic = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.05),
      body: AlertDialogWithButton(
        messageText:
        isProfilePic ? "Please put a profile picture" : "You need to complete your information to apply for this job.",
        buttonText: isProfilePic ? "Go to profile" : "Go to settings",
        onTap: () {
          AppNavigator.customNavigator(context: context, screen: screen, finish: false);
        },
      ),
    );
  }
}