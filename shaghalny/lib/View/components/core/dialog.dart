import 'package:flutter/material.dart';

Future<Object?> customDialog({required context , required Widget dialog}){
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return Align(
        alignment: Alignment.center,
        child:dialog,
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
        child: child,
      );
    },

    transitionDuration: const Duration(milliseconds: 300),
  );
}