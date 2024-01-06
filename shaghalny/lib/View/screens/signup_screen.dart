import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:shaghalny/View/screens/app_complaint.dart';
import 'package:shaghalny/ViewModel/cubits/sign_in_cubit/sign_in_cubit.dart';
import '/Model/user_model/user_model.dart';
import '/View/components/core/buttons.dart';
import '/View/components/core/custom_text.dart';
import '/View/components/core/sign_in_appBar.dart';
import '/View/components/signup_screen/progress_bar.dart';
import '/View/screens/basic_info_signup_screen.dart';
import '/View/screens/verify_number.dart';
import '/ViewModel/cubits/sign_up_cubit/sign_up_cubit.dart';
import '/ViewModel/cubits/verify_number_cubit/vertify_number_cubit.dart';
import '/color_const.dart';
import '/view/components/core/custom_dropdownmenu.dart';
import '/view/screens/set_password.dart';
import '/view/screens/signin_screen.dart';

import '../../Model/admin_model/admin_model.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../utils/page_route.dart';

class SignupScreen extends StatelessWidget {
  String? selectedCity;
  String? selectedArea;
 static GlobalKey<FormState> cityKey = new GlobalKey<FormState>();
 static GlobalKey<FormState> areaKey = new GlobalKey<FormState>();
  List<String>? cityList;
  List<String>? areaList;
  List<dynamic>? test;


  @override
  Widget build(BuildContext context) {

    PreferenceCubit preferenceCubit = BlocProvider.of<PreferenceCubit>(context, listen: true);
    SignUpCubit signUpCubit = BlocProvider.of<SignUpCubit>(context, listen: true);
    SignInCubit signInCubit = SignInCubit.get(context);
    print(preferenceCubit.adminModel!.city);
    print(preferenceCubit.adminModel!.area);


    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {},
      builder: (context, state) {
        //cityList= preferenceCubit.adminModel!.city.map((e) => e.toString()).toList();
        // areaList= test!.map((e) => e.toString()).toList();
       // test = preferenceCubit.adminModel!.area.entries.map( (entry) => (entry.value)).toList();        //  areaList= test!.map((e) => e.toString()).toList();
      //  areaList= test!.map((e) => e.toString()).toList();
        return WillPopScope(
          onWillPop: ()async{
            await signInCubit.googleSignOut();
            return true;
          },
          child: Scaffold(
            backgroundColor: primary,
            body: SingleChildScrollView(
              child: Container(
                // height: 50,
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SignInAppBar(text: "Create a new account ", size: 24.sp, progress: 0),
                    Column(children: [
                      CustomDropDownMenuButton(
                          formKey: cityKey,
                          // list:cityList!,//preferenceCubit.adminModel!.city.toList(), //AdminModel.getCity(),
                          list: preferenceCubit.adminModel!.city.map((e) => e.toString()).toList(),
                          hintText: Text(
                            'Choose your city',
                            style: TextStyle(color: Colors.grey),
                          ),
                          value: selectedCity,
                          onchange: (String? newValue) {
                            selectedCity = newValue;
                            preferenceCubit.changeCity(city: newValue.toString());
                          },
                          validate: (value) {
                            if (value == null) {
                              return 'City is required';
                            } else {


                              return null;
                            }
                          }),
                      SizedBox(height: 15.h),
                      CustomDropDownMenuButton(
                          formKey: areaKey,
                          // list:areaList!,//AdminModel.getArea(),
                          list: preferenceCubit.currentArea.map((e) => e.toString()).toList(),
                          // list: [],
                          hintText: const Text(
                            'Choose your area',
                            style: TextStyle(color: Colors.grey),
                          ),
                          value: selectedArea,
                          onchange: (String? newValue) {
                            selectedArea = newValue;
                          },
                          validate: (value) {
                            if (value == null) {
                              return 'Area is required';
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(height: 15.h),

                    ]),
                    SizedBox(height: 180.h),
                    Center(
                      child: PrimaryButton(
                          text: 'Continue',
                          onTap: () async {
                            if (cityKey.currentState!.validate() &&
                                areaKey.currentState!.validate()
                            ) {
                              /*  UserModel.setCity(selectedCity!);
                              UserModel.setArea(selectedArea!);
                              print(UserModel.getCity());
                              print(UserModel.getArea());*/
                              signUpCubit.addCityArea(preferenceCubit, city: selectedCity, area: selectedArea);
                              print(preferenceCubit.userModel!.city);
                              print(preferenceCubit.userModel!.area);


                              AppNavigator.customNavigator(
                                  context: context,
                                  screen: BasicInfoSignUp(),
                                  finish: false);
                            }
                          }),
                    ),


                    SizedBox(height: 30.h),
                    InkResponse(onTap:(){ AppNavigator.customNavigator(context: context, screen: AppComplaint(), finish: false);},
                      child: CustomText(
                          text: "Contact Us",
                          weight: FontWeight.w400,
                          size: 14.sp,
                          color: secondary),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}