import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../color_const.dart';

class TimerButton extends StatefulWidget {
  String defaultText;
  VoidCallback onTap;
  Color ?activeColor = Colors.white;
  Color ?disActiveColor = Colors.grey;
  int seconds;
  TimerButton(
      {required this.seconds,
       this.activeColor,
       this.disActiveColor,
      required this.onTap,
      required this.defaultText,
      });

  @override
  State<TimerButton> createState() => _TimerButtonState();
}


class _TimerButtonState extends State<TimerButton> {
  final interval = const Duration(seconds: 1);

  int timerMaxSeconds = 0;
  int currentSeconds = 0;
  bool countDownComplete = false;

  void initState() {
    countDownComplete=true;
    startTimeout();
  }

  startTimeout([int? milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      if (!mounted) return;
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= widget.seconds) {
          setState(() {
            countDownComplete = false;
            currentSeconds = 0;
          });
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String sendAgainStr = (widget.seconds - currentSeconds <= 9)
        ? "${widget.defaultText} after 00:0"
        : "${widget.defaultText} after 00:";
    return InkResponse(
      onTap: () {
        if (!countDownComplete) {
          countDownComplete = true;
          startTimeout();
          widget.onTap();
        } //else do nothing
      },
      child: Container(
        height: 52,
        width: 342,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: (!countDownComplete)?Border.all(color: Colors.white):Border.all(color: Colors.grey),
          color: primary,
        ),
        child: Center(
            child: (countDownComplete)
                // disActive
                ? Text(sendAgainStr + "${widget.seconds - currentSeconds}",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ))
                // Active
                : Text(
                    "${widget.defaultText}",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  )),
      ),
    );
  }
}
