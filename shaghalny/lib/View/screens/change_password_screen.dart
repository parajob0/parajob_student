import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class ChangePassword extends StatelessWidget {
  ChangePassword({Key? key}) : super(key: key);


  static GlobalKey<FormState> passwordKey = new GlobalKey<FormState>();
  TextEditingController passwordController = new TextEditingController();

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
              CustomText(text: "Change Password", weight: FontWeight.w500, size: 20.sp, color: Colors.white.withOpacity(0.7)),
              SizedBox(height: 40.h),
              DefaultTextField(
                keyboardTypeIsNumber: false,
                hintText: "Enter your password",
                formKey: passwordKey,
                controller: passwordController,
                onchange: (val) {
                  print(val);
                },
                errorBorder: cubit.phoneErrorBorder,
                validate: (password) {
                  // r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$
                  final bool passwordValid = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                      .hasMatch(password ?? "");

                  if (!passwordValid) {
                    return "password should contain at least one upper case,\nat least one lower case,\nat least one digit,\nat least one Special character,\nat least 8 characters";
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
            text: 'Change',
            onTap: () async {
              if(passwordKey.currentState!.validate()){
                if(passwordController.text == preferenceCubit.userModel!.password){

                  snackbarMessage("New Password cannot be the same as the old one", context);
                }
                else{
                  preferenceCubit.userModel!.password = passwordController.text;

                  User user = FirebaseAuth.instance.currentUser!;
                  user.updatePassword(passwordController.text).then((_){
                    debugPrint("Successfully changed password");
                  }).catchError((error){
                    debugPrint("Password can't be changed $error");
                    //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                  });

                  // FirebaseFirestore.instance.collection("User")
                  //     .doc(preferenceCubit.userModel!.id)
                  //     .set({
                  //   "password": passwordController.text,
                  // }, SetOptions(merge: true));
                  snackbarMessage("Password Changed", context);
                  Navigator.pop(context);
                }
              }
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
