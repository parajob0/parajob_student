import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/View/components/core/buttons.dart';
import '/color_const.dart';

class AlertDialogWithButton extends StatelessWidget {
  String messageText;
  String buttonText;
  VoidCallback onTap;
  AlertDialogWithButton({required this.messageText, required this.onTap,required this.buttonText, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      insetPadding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.sp))),
      title: SvgPicture.asset(
        'assets/Warning circle.svg',
        width: 10.w,
        height: 15.h,),
      icon: Align(alignment: Alignment.topRight,
          child:InkResponse(
            onTap: () {Navigator.pop(context);},
            child: SvgPicture.asset(
              'assets/exit.svg',
              width: 10.w,
              height: 15.h,),),),
      backgroundColor: primary,
      content: Text(messageText,textAlign: TextAlign.center,style: TextStyle(fontSize: 19.sp,color: Colors.white),),
      actions: <Widget>[
      InkResponse(
      onTap: onTap,
      child: Container(
        height: 52.h,
        width: 300.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
          border: Border.all(color: secondary),
          color: secondary,
        ),
        child: Center(
          child: Text(
            buttonText,
            style: GoogleFonts.poppins(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
      ],
    );
  }
}

class AlertOTPFailed extends StatelessWidget {
  String messageText;
  String warningText;
  AlertOTPFailed({required this.messageText, required this.warningText, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.sp))),
      icon: Align(alignment: Alignment.topRight,
        child:InkResponse(
          onTap: () {Navigator.pop(context);},
          child: SvgPicture.asset(
            'assets/exit.svg',
            width: 10.w,
            height: 15.h,),),),
      backgroundColor: primary,
      content: Text(messageText,textAlign: TextAlign.center,style: TextStyle(fontSize: 19.sp,color: Colors.white),),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
          child: Text(warningText,style: TextStyle(color: Colors.grey,fontSize: 10.sp),textAlign:TextAlign.center ,),
        ),
        SizedBox(height: 20.h,),
      ],
    );
  }
}



class AlertDialogWithButtonWithoutIcon extends StatelessWidget {
  String messageText;
  String buttonText;
  VoidCallback onTap;
  String warningText;

  AlertDialogWithButtonWithoutIcon({required this.messageText, required this.onTap,required this.buttonText,required this.warningText, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      insetPadding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.sp))),
      icon: Align(alignment: Alignment.topRight,
        child:InkResponse(
          onTap: () {Navigator.pop(context);},
          child: SvgPicture.asset(
            'assets/exit.svg',
            width: 10.w,
            height: 15.h,),),),
      backgroundColor: primary,
      content: Text(messageText,textAlign: TextAlign.center,style: TextStyle(fontSize: 19.sp,color: Colors.white),),
      actions: <Widget>[
      Center(
        child: InkResponse(
        onTap: onTap,
        child: Container(
          height: 52.h,
          width: 300.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.sp)),
            border: Border.all(color: secondary),
            color: secondary,
          ),
          child: Center(
            child: Text(
              buttonText,
              style: GoogleFonts.poppins(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
    ),
      ),
        SizedBox(height: 10.h,),
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
          child: Text(warningText,style: TextStyle(color: Colors.grey,fontSize: 10.sp),textAlign:TextAlign.start ,),
        ),
        SizedBox(height: 20.h,),
      ],
    );
  }
}

class AlertDialogWithoutButton extends StatelessWidget {
  String messageText;
  AlertDialogWithoutButton({required this.messageText, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      insetPadding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.sp))),
      backgroundColor: primary,
    //  content: Text(messageText,textAlign: TextAlign.center,style: TextStyle(fontSize: 19.sp,color: Colors.white),),
      actions: <Widget>[
        SizedBox(height: 20.h,width: 20.w,),
        Text(messageText,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.sp,color: Colors.white),),
        SizedBox(height: 20.h,width: 20.w,),
      ],
    );
  }
}

class AlertDialogWithDeleteButton extends StatelessWidget {
  String messageText;
  double? height;
  String hintText;
  String buttonText;
  VoidCallback onTap;
  AlertDialogWithDeleteButton({required this.messageText,required this.hintText,required this.height,required this.onTap,required this.buttonText, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      insetPadding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.sp))),
      title: SvgPicture.asset(
        'assets/Warning circle.svg',
        width: 12.w,
        height: 20.h,),
      icon: Align(alignment: Alignment.topRight,
        child: InkResponse(
          onTap: () {Navigator.pop(context);},
          child: SvgPicture.asset(
            'assets/exit.svg',
            width: 10.w,
            height: 15.h,),),),
      backgroundColor: primary,
      content: Text(messageText,textAlign: TextAlign.center,style: TextStyle(fontSize: 19.sp,color: Colors.white),),
      actions: <Widget>[
        Center(
          child: InkResponse(onTap: onTap, child: Container(
            height: 52.h,
            width: 300.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.sp)),
              border: Border.all(color: Colors.red),
              color: primary,
            ),
            child: Center(
              child: Text(buttonText,
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ),
          )
          ),
        ),
        SizedBox(height: 10.h,),
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
          child: Text(hintText,style: TextStyle(color: Colors.grey,fontSize: 10.sp),textAlign:TextAlign.start ,),
        ),
        SizedBox(height: height,),
      ],
    );
  }
}

class AlertDialogWithTwoButtons extends StatelessWidget {
  String messageText;
  String firstButtonText;
  String secondButtonText;
  VoidCallback onTapFirstButton;
  VoidCallback onTapSecondButton;
  AlertDialogWithTwoButtons({required this.messageText,required this.onTapSecondButton, required this.onTapFirstButton,required this.firstButtonText,required this.secondButtonText, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      insetPadding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.sp))),

      icon: Align(alignment: Alignment.topRight,
        child:InkResponse(
          onTap: () {Navigator.pop(context);},
          child: SvgPicture.asset(
            'assets/exit.svg',
            width: 10.w,
            height: 15.h,),),),
      backgroundColor: primary,
      content: Text(messageText,textAlign: TextAlign.center,style: TextStyle(fontSize: 19.sp,color: Colors.white),),
      actions: <Widget>[
        Center(
          child: InkResponse(
            onTap: onTapFirstButton,
            child: Container(
              height: 52.h,
              width: 300.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                border: Border.all(color: secondary),
                color: secondary,
              ),
              child: Center(
                child: Text(
                  firstButtonText,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
SizedBox(height: 10.h,),
        Center(
          child: InkResponse(
            onTap: onTapSecondButton,
            child: Container(
              height: 52.h,
              width: 300.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                border: Border.all(color: Colors.white),
                color: primary,
              ),
              child: Center(
                child: Text(
                  secondButtonText,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),

              ),

            ),

          ),

        ),
        SizedBox(height: 20.h,),

      ],
    );
  }
}
