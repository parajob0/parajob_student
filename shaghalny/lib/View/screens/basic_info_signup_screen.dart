import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaghalny/View/screens/app_complaint.dart';
import '/Model/user_model/user_model.dart';
import '/View/components/core/buttons.dart';
import '/View/components/core/sign_in_appBar.dart';
import '/View/components/signup_screen/progress_bar.dart';
import '/View/screens/signup_screen.dart';
import '/View/screens/verify_number.dart';
import '/view/components/core/custom_dropdownmenu.dart';
import '/view/screens/set_password.dart';

import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../ViewModel/cubits/sign_up_cubit/sign_up_cubit.dart';
import '../../ViewModel/cubits/verify_number_cubit/vertify_number_cubit.dart';
import '../../color_const.dart';
import '../../utils/page_route.dart';
import '../components/core/custom_text.dart';
import '../components/core/text_field.dart';
import 'front_ID_scan_screen.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class BasicInfoSignUp extends StatefulWidget {
  BasicInfoSignUp({Key? key}) : super(key: key);

  @override
  State<BasicInfoSignUp> createState() => _BasicInfoSignUpState();
}

class _BasicInfoSignUpState extends State<BasicInfoSignUp> {
 static GlobalKey<FormState> firstnameKey = new GlobalKey<FormState>();
 static GlobalKey<FormState> lastnameKey = new GlobalKey<FormState>();
 static GlobalKey<FormState> phoneKey = new GlobalKey<FormState>();
 static  GlobalKey<FormState> emailKey = new GlobalKey<FormState>();
 static GlobalKey<FormState> passwordKey = new GlobalKey<FormState>();
 static  GlobalKey<FormState> genderKey = new GlobalKey<FormState>();

  String? selectedgender;
  List<String> genderList = <String>[
    "Female",
    "Male",
    "Prefer not to answer"
  ];

  TextEditingController firstnameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

 bool mobileValidation=false;
 bool emailValidation=false;


 void initState() {
    // TODO: implement initState
    super.initState();
    var cubit = PreferenceCubit.get(context);
    if(cubit.userModel?.firstName!=null){
      firstnameController.text = cubit.userModel?.firstName??"";
    }
    if(cubit.userModel?.firstName!=null){
      lastnameController.text = cubit.userModel?.lastName??"";
    }
    if(cubit.userModel?.firstName!=null){
      emailController.text = cubit.userModel?.email??"";
    }
  }

  @override
  Widget build(BuildContext context) {

var fire= FirebaseFirestore.instance.collection("User");

    var cubit = VertifyNumberCubit.get(context);
    PreferenceCubit preferenceCubit =
        BlocProvider.of<PreferenceCubit>(context, listen: true);
    SignUpCubit signUpCubit =
        BlocProvider.of<SignUpCubit>(context, listen: true);
    return BlocConsumer<VertifyNumberCubit, VertifyNumberState>(
      listener: (context, state) {
       /*  if (state is SendOTPPhoneNumberSuccess) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyNumber(
                showProgressBar: false,
                nextScreen: SetPassword(),
              )));
    }*/
      },
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
                          text: "Main information", size: 24.sp, progress: 0),
                      DefaultTextField(
                          hintText: "Enter your first name",
                          formKey: firstnameKey,
                          controller: firstnameController,
                          onchange: (val) {
                            print(val);
                          },
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'First name is required';
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(height: 15.h),
                      DefaultTextField(
                          hintText: "Enter your last name",
                          formKey: lastnameKey,
                          controller: lastnameController,
                          onchange: (val) {
                            print(val);
                          },
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Last name is required';
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(height: 15.h),
                      DefaultTextField(
                        keyboardTypeIsNumber: true,
                        hintText: "Enter your phone number",
                        formKey: phoneKey,
                        controller: phoneController,
                        onchange: (val)async {
                        await  fire.where("phone_number",isEqualTo: val).get().then(
                                  (value) {
                                print(value.docs);
                                if (value.docs.isEmpty) {
                                  mobileValidation = true;
                                  print(mobileValidation);
                                }else{
                                  mobileValidation=false;
                                  print(mobileValidation);
                                }

                              }
                          );

                          print(val);
                        },
                        errorBorder: cubit.phoneErrorBorder,
                        validate: (phoneNumber) {

                          if (phoneNumber!.length < 11 ||
                              phoneNumber[0] != '0') {
                            return "phone number is not valid";
                          }



                          else if(phoneNumber.length == 11 ||
                              phoneNumber[0] == '0')
                            {
                              if(mobileValidation==false){
                                return "phone number is used";  }
                             else  if(mobileValidation==true){
                                return null;  }
                            }
                         return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      DefaultTextField(
                        hintText: "Enter your email",
                        formKey: emailKey,
                        controller: emailController,
                        onchange: (val)async {
                          await  fire.where("email",isEqualTo: val).get().then(
                                  (value) {
                                print(value.docs);
                                if (value.docs.isEmpty) {
                                  emailValidation = true;
                                  print(emailValidation);
                                }else{
                                  if(preferenceCubit.userModel!.externalSignIn == true){
                                    emailValidation = true;
                                  }
                                  else {
                                    emailValidation=false;
                                  }
                                  print(emailValidation);
                                }

                              }
                          );
                          print(val);
                        },
                        validate: (email) {
                          final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email ?? "");
                          if(preferenceCubit.userModel!.externalSignIn == true){
                            return null;
                          }
                          else if(emailValidation==false){
                            return "Email is used";  }
                          else  if(emailValidation==true){
                            return null;  }

                          if (!emailValid) {
                            return 'Email is not valid';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomDropDownMenuButton(
                          formKey: genderKey,
                          list: genderList,
                          hintText: Text(
                            'Select your Gender',
                            style: TextStyle(color: Colors.grey),
                          ),
                          value: selectedgender,
                          onchange: (String? newValue) {
                            selectedgender = newValue;
                          },
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'gender is required';
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(height: 30.h),
                      Center(
                          child: BlocConsumer<SignUpCubit, SignUpState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {

                          return PrimaryButton(
                              text: 'Continue',
                              onTap: () async {


                                if (firstnameKey.currentState!.validate() &&
                                    lastnameKey.currentState!.validate() &&
                                    emailKey.currentState!.validate() &&
                                    phoneKey.currentState!.validate() &&
                                    genderKey.currentState!.validate()) {


                                  signUpCubit.addBasicData(preferenceCubit,
                                      firstName: firstnameController.text,
                                      lastName: lastnameController.text,
                                      email: emailController.text,
                                      phoneNumber: phoneController.text,
                                      gender: selectedgender);
                                  /* UserModel.setFirstName(firstnameController.text);
                                  UserModel.setLastName(lastnameController.text);
                                  UserModel.setEmail(emailController.text);
                                  UserModel.setPhoneNumber(phoneController.text);
                                  UserModel.setGender(selectedgender!);
                                  print(UserModel.getFirstName());
                                  print(UserModel.getLastName());
                                  print(UserModel.getEmail());
                                  print(UserModel.getPhoneNumber());
                                  print(UserModel.getGender());*/

                                 // cubit.phoneAuthentication(
                                 //      preferenceCubit.userModel!.phoneNumber!, 60, context);

                                  if(preferenceCubit.userModel!.externalSignIn!){

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
                                      token: token.toString(),
                                      // isApproved: false,
                                      // withGoogle: true,
                                    );
                                  }

                                 AppNavigator.customNavigator(
                                      context: context,
                                      // screen: VerifyNumber(showProgressBar: true, nextScreen: preferenceCubit.userModel!.externalSignIn! ?
                                      //       const FrontIDScan()
                                      //     : SetPassword()
                                      // ),
                                      screen: preferenceCubit.userModel!.externalSignIn! ? const FrontIDScan() : SetPassword(),
                                      finish: false);
                                  //


                                }
                              });
                        },
                      )),
                      SizedBox(height: 20.h),
                      InkResponse(onTap: (){ AppNavigator.customNavigator(context: context, screen: AppComplaint(), finish: false);},
                        child: CustomText(
                            text: "Contact Us",
                            weight: FontWeight.w400,
                            size: 14.sp,
                            color: secondary),
                      )
                    ])),
          ),
        );
      },
    );
  }
}
