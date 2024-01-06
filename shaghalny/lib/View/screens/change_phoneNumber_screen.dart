import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaghalny/View/components/core/custom_text.dart';
import 'package:shaghalny/View/screens/menu.dart';
import 'package:shaghalny/View/screens/verify_number.dart';

import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../ViewModel/cubits/verify_number_cubit/vertify_number_cubit.dart';
import '../../color_const.dart';
import '../../utils/page_route.dart';
import '../../utils/snackbar.dart';
import '../components/core/buttons.dart';
import '../components/core/text_field.dart';

class ChangePhoneNumber extends StatelessWidget {
  ChangePhoneNumber({Key? key}) : super(key: key);


  static GlobalKey<FormState> phoneKey = new GlobalKey<FormState>();
  TextEditingController phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit = VertifyNumberCubit.get(context);
    PreferenceCubit preferenceCubit =
    BlocProvider.of<PreferenceCubit>(context, listen: true);
    return Scaffold(
      backgroundColor: primary,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 54.h, 24.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: "Change Phone Number", weight: FontWeight.w500, size: 20.sp, color: Colors.white.withOpacity(0.7)),
            SizedBox(height: 40.h),
            DefaultTextField(
              keyboardTypeIsNumber: true,
              hintText: "Enter your phone number",
              formKey: phoneKey,
              controller: phoneController,
              onchange: (val) {
                print(val);
              },
              errorBorder: cubit.phoneErrorBorder,
              validate: (phoneNumber) {
                if (phoneNumber!.length < 11 ||
                    phoneNumber[0] != '0') {
                  return "phone number is not valid";
                }
                return null;
              },
            ),
          ]
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0.w, 24.w, 0.w),
        child: PrimaryButton(
                text: 'Verify',
                onTap: () async {
                  if(phoneKey.currentState!.validate()){
                    if(phoneController.text == preferenceCubit.userModel!.phoneNumber){

                      snackbarMessage("New Phone number cannot be the same as the old one", context);
                    }
                    else{
                      cubit.phoneAuthentication(
                          phoneController.text, 60, context);
                      AppNavigator.customNavigator(
                          context: context,
                          // screen: SetPassword(),
                          screen: VerifyNumber(showProgressBar: true, nextScreen: const MenuScreen()),
                          finish: false);
                    }
                  }
                }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
