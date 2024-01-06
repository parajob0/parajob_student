import 'package:flutter/material.dart';
import '/View/screens/bottom_navigation_screen.dart';
import '/color_const.dart';
import '/utils/page_route.dart';
import '/view/components/core/alert_message.dart';
import '/view/screens/signup_screen.dart';

class AlertReviewSubmitted extends StatelessWidget {
  const AlertReviewSubmitted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.05),
      body: AlertDialogWithButtonWithoutIcon(
          messageText:
          "Your review has been submitted successfully.",
          buttonText: "Go back to Home",
          warningText: "",
          onTap: () {
            AppNavigator.customNavigator(
                context: context,
                screen: BottomNavigation(index: 0,),
                finish: true);
          }),
    );
  }
}
