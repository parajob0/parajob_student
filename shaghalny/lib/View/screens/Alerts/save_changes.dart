import 'package:flutter/material.dart';
import '/color_const.dart';
import '/view/screens/signup_screen.dart';

import '../../components/core/alert_message.dart';


class AlertToSaveChanges extends StatelessWidget {
  VoidCallback onTap;
  VoidCallback onCancelTap;
   AlertToSaveChanges({required this.onTap,required this.onCancelTap,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.05),
      body: AlertDialogWithTwoButtons(messageText: "Are you sure that you want to save these changes?",
        onTapFirstButton: onTap,onTapSecondButton: onCancelTap,
        firstButtonText: "Save Changes",secondButtonText: "Cancel",),
    );
      }

  }

