import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shaghalny/View/components/core/loading_indicator.dart';
import 'package:shaghalny/View/screens/check_your_email_screen.dart';
import 'package:shaghalny/View/screens/front_ID_scan_screen.dart';
import 'package:shaghalny/View/screens/menu.dart';
import 'package:shaghalny/View/screens/signin_screen.dart';
import 'package:shaghalny/utils/page_route.dart';
import 'package:shaghalny/utils/snackbar.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../ViewModel/cubits/sign_up_cubit/sign_up_cubit.dart';
import '../../ViewModel/cubits/verify_number_cubit/vertify_number_cubit.dart';
import '../../color_const.dart';
import '../components/core/buttons.dart';
import '../components/core/custom_text.dart';
import '../components/core/sign_in_appBar.dart';
import '../components/core/text_field.dart';
import '../components/core/timer_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class VerifyNumber extends StatefulWidget {
  bool showProgressBar;
  dynamic nextScreen;
  String newPhone;

  // page ->0 resetPassword
  // page ->1 setPasswrod
  VerifyNumber(
      {required this.showProgressBar, required this.nextScreen, this.newPhone = ""});

  @override
  State<VerifyNumber> createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {
  int timeout = 59;
  String otp = "";

  List<TextEditingController?> list = [];

  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit = VertifyNumberCubit.get(context);
    PreferenceCubit preferenceCubit =
    BlocProvider.of<PreferenceCubit>(context, listen: true);
    SignUpCubit signUpCubit =
    BlocProvider.of<SignUpCubit>(context, listen: true);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: primary,
          body: SingleChildScrollView(
            child: Container(
              height: 1.sh - 0.04.sh,
              padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SignInAppBar(
                    text: 'Verify your number',
                    size: 24.sp,
                    progress: 0,
                    subText: "Check your messages to find OTP.",
                    showProgressBar: (widget.showProgressBar) ? true : false,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: PinCodeTextField(
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        inactiveFillColor: Colors.transparent,
                        activeFillColor: Colors.transparent,
                        selectedFillColor: primary,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white,
                        selectedColor: secondary,
                        shape: PinCodeFieldShape.underline,
                        borderRadius: BorderRadius.circular(5),
                        borderWidth: 3,
                        disabledColor: Colors.transparent,
                        fieldHeight: 50,
                        fieldWidth: 40,
                      ),
                      cursorColor: Colors.transparent,
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: primary,
                      enableActiveFill: false,
                      controller: controller,
                      onCompleted: (v) {
                        print("Completed");
                        controller.text = v;
                        print(controller.text.toString());
                      },
                      onChanged: (value) {
                        print(controller.text);
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        return true;
                      },
                      appContext: context,
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0.w, 24.w, 0.w),
            child: BlocConsumer<VertifyNumberCubit, VertifyNumberState>(
              listener: (context, state) {
                if (state is ResetPasswordEmailSentSucc) {
                  cubit.changeVerifyNumberLoadingIndecator(false);
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (BuildContext context) => widget.nextScreen));
                }
              },
              builder: (context, state) {
                var cubit = VertifyNumberCubit.get(context);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryButton(
                        text: 'Verify',
                        onTap: () async {
                          cubit.changeVerifyNumberLoadingIndecator(true);
                          await cubit
                              .verifyOTPPhoneNumber(controller.text, context)
                              .then((value) async {
                            print(VertifyNumberCubit.verId);
                            if (value == true) {
                              // TODO Add different screens
                              if (widget.nextScreen is CheckYourEmailScreen) {
                                await cubit.resetEmailPassword(
                                    phoneNumber: VertifyNumberCubit.phone,
                                    context: context);
                              }
                              else {
                                if (widget.nextScreen is FrontIDScan) {


                                  String? token = await FirebaseMessaging.instance.getToken();

                                  signUpCubit.createNewUser(
                                    preferenceCubit,
                                    first_name: preferenceCubit.userModel!
                                        .firstName!,
                                    last_name: preferenceCubit.userModel!
                                        .lastName!,
                                    email: preferenceCubit.userModel!.email!,
                                    phone: preferenceCubit.userModel!
                                        .phoneNumber!,
                                    password: "",
                                    gender: preferenceCubit.userModel!.gender!,
                                    area: preferenceCubit.userModel!.area!,
                                    city: preferenceCubit.userModel!.city!,
                                    level: 0,
                                    token: token.toString()
                                    // isApproved: false,
                                    // withGoogle: true,
                                  );
                                }

                                if (widget.nextScreen is MenuScreen) {
                                  preferenceCubit.userModel!.phoneNumber =
                                      widget.newPhone;
                                  FirebaseFirestore.instance.collection("User")
                                      .doc(preferenceCubit.userModel!.id)
                                      .set({
                                    "phone_number": widget.newPhone,
                                  }, SetOptions(merge: true));

                                  snackbarMessage("Phone Number Changed", context);
                                }

                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (context) => widget
                                            .nextScreen));
                              }
                            }
                            else {
                              // Error Message;
                              print("Verifiy is false");
                              snackbarMessage("Wrong OTP.", context);
                            }
                            cubit.changeVerifyNumberLoadingIndecator(false);
                          });
                        }),
                    SizedBox(height: 10.h),
                    TimerButton(
                      seconds: timeout,
                      activeColor: Colors.red,
                      onTap: () async {
                        // print("\n\n phone --> ${VertifyNumberCubit.phone} \n\n");
                        // await cubit.phoneAuthentication(
                        //     VertifyNumberCubit.phone, timeout, context);
                        print("\n\n phone pref --> ${preferenceCubit.userModel!
                            .phoneNumber} \n\n");
                        await cubit.phoneAuthentication(
                            preferenceCubit.userModel!.phoneNumber!, timeout,
                            context);
                      },
                      defaultText: "Send again",
                    ),
                    SizedBox(height: 24.h),
                    (widget.showProgressBar)
                        ? Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                          text: 'Contact Us',
                          weight: FontWeight.w400,
                          size: 14.sp,
                          color: secondary),
                    )
                        : Container(),
                  ],
                );
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerFloat,
        ),
        BlocConsumer<VertifyNumberCubit, VertifyNumberState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return (cubit.verifyNumberLoadingIndecator == true)
                ? const LoadingIndicator()
                : Container();
          },
        ),
      ],
    );
  }
}