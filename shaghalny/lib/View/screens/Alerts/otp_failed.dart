import 'package:flutter/material.dart';

import '../../components/core/alert_message.dart';

class OTPFailed extends StatelessWidget {
  const OTPFailed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.05),
      // body: AlertDialogWithoutButton(
      //     messageText:
      //     'Settings > Cellular > Cellular Data Options > turn off "Limit IP Address Tracking"'),
      body: AlertOTPFailed(
        messageText: 'OTP Failed', warningText: 'Settings > Cellular > Cellular Data Options > turn off "Limit IP Address Tracking"',

      ),
    );
  }
}
