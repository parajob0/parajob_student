import 'package:flutter/material.dart';

import '../../components/core/alert_message.dart';

class CheckInOutAlert extends StatelessWidget {
  const CheckInOutAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.05),
      // body: AlertDialogWithoutButton(
      //     messageText:
      //     'Settings > Cellular > Cellular Data Options > turn off "Limit IP Address Tracking"'),
      body: AlertOTPFailed(
        messageText: 'WARNING!!',
        warningText: 'Do not close the app after checking in. That will cause issues with your salary.',

      ),
    );
  }
}
