import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shaghalny/View/screens/app_complaint.dart';
import 'package:shaghalny/View/screens/menu.dart';
import '/Model/user_model/user_model.dart';
import '/View/components/core/sign_in_appBar.dart';
import '/View/screens/edit_personal_info.dart';
import '/View/screens/front_ID_scan_screen.dart';
import '/View/screens/submit_review.dart';
import '/ViewModel/cubits/sign_up_cubit/sign_up_cubit.dart';
import '/ViewModel/database/cache_helper/cache_helper.dart';
import '/color_const.dart';
import '/color_const.dart';
import '/view/components/core/buttons.dart';
import '/view/components/core/custom_text.dart';
import '/view/components/core/text_field.dart';
import '/view/screens/education_screen.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../utils/page_route.dart';
import '../components/signup_screen/progress_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SetPassword extends StatelessWidget {
  SetPassword({Key? key}) : super(key: key);
  static  GlobalKey<FormState> passwordKey = new GlobalKey<FormState>();
  static GlobalKey<FormState> rePasswordKey = new GlobalKey<FormState>();

  TextEditingController passwordController = new TextEditingController();
  TextEditingController rePasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    PreferenceCubit preferenceCubit =
        BlocProvider.of<PreferenceCubit>(context, listen: true);
    SignUpCubit signUpCubit =
        BlocProvider.of<SignUpCubit>(context, listen: true);
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: primary,
          body: SingleChildScrollView(
            child: Container(
                // height: 50,
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SignInAppBar(
                          text: "Set Password ", size: 24.sp, progress: 20),
                      DefaultTextField(
                        isSecure: true,
                        hintText: "Enter Password",
                        formKey: passwordKey,
                        controller: passwordController,
                        onchange: (val) {
                          print(val);
                        },
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
                      SizedBox(height: 15.h),
                      DefaultTextField(
                        isSecure: true,
                        hintText: "Renter password",
                        formKey: rePasswordKey,
                        controller: rePasswordController,
                        onchange: (val) {
                          print(val);
                        },
                        validate: (password) {
                          if (password == null || password.isEmpty) {
                            return "you must Renter password";
                          } else if (password != passwordController.text) {
                            return "you must enter the same password";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 180.h),
                    ])),
          ),
          floatingActionButton: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PrimaryButton(
                      text: 'Continue',
                      onTap: () async{if (passwordKey.currentState!.validate()&&rePasswordKey.currentState!.validate()){
                        /*signUpCubit.createNewUser(first_name: UserModel.getFirstName(), last_name: UserModel.getLastName(),
              email: UserModel.getEmail(), phone: UserModel.getPhoneNumber(), password: passwordController.text,
              gender: UserModel.getGender() , area: UserModel.getArea(), city: UserModel.getCity(), level: 1);*/


                        String? token = await FirebaseMessaging.instance.getToken();

                        signUpCubit.createNewUser(
                            preferenceCubit,
                            first_name: preferenceCubit.userModel!.firstName!,
                            last_name: preferenceCubit.userModel!.lastName!,
                            email: preferenceCubit.userModel!.email!,
                            phone: preferenceCubit.userModel!.phoneNumber!,
                            password: passwordController.text,
                            gender: preferenceCubit.userModel!.gender!,
                            area: preferenceCubit.userModel!.area!,
                            city: preferenceCubit.userModel!.city!,
                            level: 0,
                            token: token.toString()
                            // isApproved: false,
                            // withGoogle: false
                        );
                        signUpCubit.addPassLevelData(preferenceCubit,
                            password: passwordController.text,
                            level: 0);
                        /*   signUpCubit.addData(preferenceCubit,id: UserModel.getID() ,firstName: UserModel.getFirstName(), lastName: UserModel.getLastName(),
              email: UserModel.getEmail(), password: passwordController.text, phoneNumber: UserModel.getPhoneNumber(),
              gender: UserModel.getGender(), area: UserModel.getArea(), city: UserModel.getCity(),level: 1);*/
                        print(preferenceCubit.userModel!.id.toString());
                        print(preferenceCubit.userModel!.firstName);
                        print(preferenceCubit.userModel!.lastName);
                        print(preferenceCubit.userModel!.email);
                        print(preferenceCubit.userModel!.phoneNumber);
                        print(preferenceCubit.userModel!.password);
                        print(preferenceCubit.userModel!.area);
                        print(preferenceCubit.userModel!.city);
                        print(preferenceCubit.userModel!.gender);
                        print(preferenceCubit.userModel!.level);
                        GetStorage().write('email',preferenceCubit.userModel!.email );
                      //  GetStorage().write('uid',preferenceCubit.userModel!.id );

                        AppNavigator.customNavigator(
                            context: context,
                            screen:  const FrontIDScan(),
                            finish: true);
                      }
                        // if (passwordKey.currentState!.validate()&&repasswordKey.currentState!.validate()) {
                        //   UserModel.setPassword(passwordController.text);
                        //   SignUpCubit.get(context).createNewUser(first_name: UserModel.getFirstName(),
                        //       last_name: UserModel.getLastName(), email: UserModel.getEmail(), phone: UserModel.getPhoneNumber(),
                        //       password: UserModel.getPassword(), gender: UserModel.getGender(), type: UserModel.getType(),
                        //       area: UserModel.getArea(), city: UserModel.getCity(), level: 1);
                        //   AppNavigator.customNavigator(
                        //       context: context,
                        //       screen: FrontIDScan(),
                        //       finish: true);}
                      }),
                  SizedBox(height: 15.h),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: InkResponse(onTap: (){ AppNavigator.customNavigator(context: context, screen: AppComplaint(), finish: false);},
                        child: CustomText(
                            text: "Contact Us",
                            weight: FontWeight.w400,
                            size: 14.sp,
                            color: secondary),
                      ))
                ],
              )),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
