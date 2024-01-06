import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import '../../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../../ViewModel/database/cache_helper/cache_helper.dart';
import '../../../utils/page_route.dart';
import '../signin_screen.dart';
import '/color_const.dart';
import '/view/components/core/alert_message.dart';
import '/view/screens/signup_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertToDeleteAccount extends StatelessWidget {
  const AlertToDeleteAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PreferenceCubit preferenceCubit = BlocProvider.of<PreferenceCubit>(
        context, listen: true);
    return  Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.05),
      body: AlertDialogWithDeleteButton(hintText: "Warning: if you deleted your account you will lose all your data and your level rank.",messageText: "Are you sure that you want to delete your account?",height: 20.h,buttonText: "Delete my account",
        onTap:() {
          FirebaseFirestore.instance
              .collection("User")
              .doc(CacheHelper.getData(key: "uid"))
              .delete();
          CacheHelper.setData(key: 'uid', value: 'ROkuqkbItLHg7b2Z2HYL');
          GetStorage().write('email',"newUser");
          GetStorage().write('uid',"oldUser");
          CacheHelper.removeData(key: "rand");
          AppNavigator.customNavigator(context: context, screen: SigninScreen(), finish: true);

        }
    )
    );
  }
}
