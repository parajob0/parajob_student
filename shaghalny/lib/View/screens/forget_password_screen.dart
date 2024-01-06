import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shaghalny/View/components/core/loading_indicator.dart';
import 'package:shaghalny/View/screens/check_your_email_screen.dart';
import 'package:shaghalny/View/screens/signin_screen.dart';
import 'package:shaghalny/View/screens/verify_number.dart';
import '../../ViewModel/cubits/verify_number_cubit/vertify_number_cubit.dart';
import '../../color_const.dart';
import '../components/core/buttons.dart';
import '../components/core/custom_text.dart';
import '../components/core/text_field.dart';
import 'Alerts/otp_failed.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);
  static GlobalKey<FormState> phoneKey = new GlobalKey<FormState>();
  static TextEditingController phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit = VertifyNumberCubit.get(context);
    return BlocConsumer<VertifyNumberCubit, VertifyNumberState>(
      listener: (context, state) {
        if (state is SendOTPPhoneNumberSuccess) {
          cubit.changeSendOTPLoadingIndecator(false);
          Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyNumber(showProgressBar: false, nextScreen: const CheckYourEmailScreen(),)));
        }
        if(state is SendOTPPhoneNumberFail){
          cubit.changeSendOTPLoadingIndecator(false);
        }
        // TODO: implement listener
      },
      builder: (context, state) {

        return WillPopScope(
          onWillPop: ()async{
            cubit.changePhoneErrorMessage(false);
            cubit.setErrorMessage("");
            cubit.changeSendOTPLoadingIndecator(false);
            return true;
          },
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: primary,
                body: SingleChildScrollView(
                  child: Container(
                    height: 1.sh - 0.04.sh,
                    padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 40.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkResponse(
                          onTap: () {
                            cubit.changePhoneErrorMessage(false);
                            cubit.setErrorMessage("");
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            'assets/backWhite.svg',
                            // color: secondary,
                            width: 12.w,
                            height: 20.h,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        CustomText(
                          text: "Forget Password",
                          weight: FontWeight.w600,
                          size: 24.sp,
                          color: Colors.white,
                        ),
                        SizedBox(height: 40.h),
                        CustomText(
                          text:
                          "Please enter your phone number to receive your verification OTP.",
                          weight: FontWeight.w500,
                          size: 14.sp,
                          color: Colors.white,
                        ),
                        SizedBox(height: 24.h),
                        DefaultTextField(
                          keyboardTypeIsNumber: true,
                          hintText: "Enter your phone number",
                          formKey: phoneKey,
                          controller: phoneController,
                          onchange: (val) {
                            // print(val);
                          },
                          errorBorder: cubit.phoneErrorBorder,
                        ),
                        SizedBox(height: 300.h),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: Padding(
                  padding: EdgeInsets.all(24.sp),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        text: cubit.errorMessage,
                        weight: FontWeight.w400,
                        size: 14.sp,
                        color: Colors.red,
                      ),
                      SizedBox(height: 8.h),
                      PrimaryButton(
                          text: 'Send',
                          onTap: () async {
                            cubit.changeSendOTPLoadingIndecator(true);
                            // valid phone number
                            bool validPhoneNumber = false;
                            if(phoneController.text.length == 11 && phoneController.text[0]=='0' && phoneController.text[1]=='1'){
                              cubit.changePhoneErrorMessage(false);
                              cubit.setErrorMessage("");
                              validPhoneNumber = true;
                            }else{
                              cubit.setErrorMessage("Invalid phone number!");
                              cubit.changePhoneErrorMessage(true);
                            }


                            if(validPhoneNumber){
                              // VertifyNumberCubit.phone = phoneController.text;
                              cubit.setPhoneNumber(phoneController.text);

                              await cubit.phoneAuthentication(phoneController.text, 3,context).then((value) {});



                            }else{
                              // TODO SHOW PHONE NUMBER ERROR MEESAGE
                              cubit.changeSendOTPLoadingIndecator(false);
                              print("Phone not valid");
                            }
                          }),
                    ],
                  ),
                ),
                floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
              ),
              (cubit.sendOTPLoadingIndecator==true)
                  ?const LoadingIndicator()
                  :Container(),
            ],
          ),
        );
      },
    );
  }
}