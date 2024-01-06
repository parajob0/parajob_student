import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '/View/components/core/loading_indicator.dart';
import '/View/screens/signin_screen.dart';
import '/utils/page_route.dart';
import '/utils/snackbar.dart';
import '../../ViewModel/cubits/verify_number_cubit/vertify_number_cubit.dart';
import '../../color_const.dart';
import '../components/core/buttons.dart';
import '../components/core/custom_text.dart';
import '../components/core/sign_in_appBar.dart';
import '../components/core/text_field.dart';
import '../components/core/timer_button.dart';

class CheckYourEmailScreen extends StatelessWidget {
  const CheckYourEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = VertifyNumberCubit.get(context);
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
                    text: 'Check your email',
                    size: 24.sp,
                    progress: 0,
                    subText:
                    "Change to your new password through the link in your email.",
                    subSize: 14.sp,
                    showProgressBar: false,
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                  Container(
                    // color: Colors.red,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/checkEmail.png',
                      width: 198.w,
                      height: 178.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0.w, 24.w, 0.w),
            child: BlocConsumer<VertifyNumberCubit, VertifyNumberState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryButton(
                      text: 'Sign in',
                      onTap: () {
                        AppNavigator.customNavigator(
                            context: context, screen: SigninScreen(), finish: true);
                      },
                    ),
                    SizedBox(height: 10.h),
                    SecondaryButton(
                      text: 'Send again',
                      onTap: () async {
                        cubit.changeSendAgainEmailLoadingIndecator(true);
                        await cubit.resetEmailPassword(
                            phoneNumber: VertifyNumberCubit.phone,
                            context: context);
                        cubit.changeSendAgainEmailLoadingIndecator(false);
                      },
                    ),
                    SizedBox(height: 10.h),
                  ],
                );
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ),
        BlocConsumer<VertifyNumberCubit, VertifyNumberState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return  (cubit.sendAgainEmailLoadingIndecator==true)
                ?const LoadingIndicator()
                :Container();
          },
        ),
      ],
    );
  }
}
