import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '/utils/page_route.dart';
import '../../screens/signup_screen.dart';
import '../core/custom_text.dart';

Widget dontHaveAnAccount(BuildContext context,PreferenceCubit preferenceCubit){
  return   Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CustomText(
        text: "Don't have an account?  ",
        weight: FontWeight.w600,
        size: 10.sp,
        color: Colors.white,
      ),
      InkWell(
        onTap: (){
          preferenceCubit.clearCurrentUserModel();
          preferenceCubit.userModel?.externalSignIn = false;
          AppNavigator.customNavigator(context: context, screen: SignupScreen(), finish: false);
        },
        child: CustomText(
          text: "Signup",
          weight: FontWeight.w600,
          size: 10.sp,
          color: Colors.white,
          isUnderLined: true,
        ),
      ),
    ],
  );
}