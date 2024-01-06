import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../ViewModel/cubits/sign_in_cubit/sign_in_cubit.dart';
import '../../screens/forget_password_screen.dart';
import '../core/custom_text.dart';

class RememberMe extends StatelessWidget {
  bool value;
  SignInCubit cubit;
  RememberMe({required this.value , required this.cubit});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 14.0.h,
          width: 14.0.w,
          child: Checkbox(
            value: cubit.rememberMe,
            checkColor: Colors.black,
            activeColor: Colors.white,
            onChanged: (val) {
              cubit.changeRememberMeValue();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.sp),
            ),
            side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(width: 1.0, color: Colors.white),
            ),
          ),
        ),
        SizedBox(width: 5.w),
        CustomText(
          text: "Remember me",
          weight: FontWeight.w500,
          size: 10.sp,
          color: Colors.white,
        ),
        Spacer(),
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordScreen()),);
          },
          child: CustomText(
            text: "Forgot Password?",
            weight: FontWeight.w500,
            size: 8.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}