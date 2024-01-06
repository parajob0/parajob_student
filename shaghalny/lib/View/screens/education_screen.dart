import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shaghalny/View/screens/Alerts/log_out.dart';
import 'package:shaghalny/View/screens/app_complaint.dart';
import 'package:shaghalny/View/screens/check_in_out.dart';
import 'package:shaghalny/ViewModel/database/cache_helper/cache_helper.dart';
import '/View/components/core/sign_in_appBar.dart';
import '/View/components/signup_screen/progress_bar.dart';
import '/View/screens/bank_information_screen.dart';
import '/ViewModel/cubits/education_screen_cubit/education_cubit.dart';
import '/color_const.dart';
import '/utils/page_route.dart';
import '/view/components/core/custom_dropdownmenu.dart';
import '/view/screens/education_scanner.dart';
import '../../Model/admin_model/admin_model.dart';
import '../../Model/user_model/user_model.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../ViewModel/cubits/sign_up_cubit/sign_up_cubit.dart';
import '../components/core/buttons.dart';
import '../components/core/custom_text.dart';
import '../components/core/id_container.dart';
import '../components/core/skip_button.dart';
import '../components/core/text_field.dart';

class EducationScreen extends StatelessWidget {
  String? selectedUniversity;
  String yearNow=DateFormat.y().format(DateTime.now());
  int? yearNowForOperations;
  String? selectedGraduationYear;
  List<String> universityList =[];
  List<String>? graduationYearList;
  static GlobalKey<FormState> universityKey = new GlobalKey<FormState>();
  static GlobalKey<FormState> graduationKey = new GlobalKey<FormState>();
  static GlobalKey<FormState> facultyKey = new GlobalKey<FormState>();
  TextEditingController facultyController = new TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    PreferenceCubit preferenceCubit = BlocProvider.of<PreferenceCubit>(context, listen: true);
    EducationCubit educationCubit=BlocProvider.of<EducationCubit>(context, listen: true);
    universityList= preferenceCubit.adminModel!.university.map((e) => e.toString()).toList();
    yearNowForOperations= int.parse(yearNow);
    graduationYearList=[yearNowForOperations.toString(),(yearNowForOperations!+1).toString(),(yearNowForOperations!+2).toString(),(yearNowForOperations!+3).toString(),
      (yearNowForOperations!+4).toString(),(yearNowForOperations!+5).toString(),(yearNowForOperations!+6).toString()];

    return  Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignInAppBar(text: "Education ", size: 24.sp, progress: 60),
              Column(
                  children:[
                    CustomDropDownMenuButton(formKey: universityKey,
                      list: universityList,//AdminModel.getUniversity(),
                      hintText:  Text('Choose your university',style: TextStyle(color: Colors.grey),),
                      value: selectedUniversity,
                      onchange: (String? newValue) {
                        selectedUniversity = newValue;
                      },
                      validate:  (value){
                        if(value==null) {
                          return 'University is required';
                        }else{
                          return null;
                        }
                      }
                  ),

                    SizedBox(height: 15.h),


                    CustomDropDownMenuButton(formKey: graduationKey,
                        list: graduationYearList!,
                        hintText: Text('Choose your graduation year',style: TextStyle(color: Colors.grey),),
                        value: selectedGraduationYear,
                        onchange: (String? newValue) {
                          selectedGraduationYear = newValue;
                        },
                        validate:  (value){
                          if(value==null) {
                            return 'Graduation Year is required';
                          }else{
                            return null;
                          }
                        }
                    ),

                    SizedBox(height: 15.h),
                    DefaultTextField(
                        hintText: "Enter your faculty",
                        formKey: facultyKey,
                        controller: facultyController,
                        onchange: (val){
                          print(val);
                        },
                        validate: (value){
                          if(value == null||value.isEmpty){
                            return 'Faculty is required';}
                          else{return null;}}
                    ),
                  ]
              ),
            //  SizedBox(height: 230.h),
              //Center(child: CustomText(text: 'Skip >>', weight: FontWeight.w500, size: 16.sp, color: Colors.white)),
              Padding(
                padding:  EdgeInsets.fromLTRB(0,300,0,0),
                child: const Align(alignment: Alignment.bottomCenter,

                    child: SkipButton()),
              ),
              SizedBox(height: 10.h),
              Align(alignment: Alignment.bottomLeft,
                  child:
                  InkResponse(onTap: (){ AppNavigator.customNavigator(context: context, screen: AppComplaint(), finish: false);},
                      child: CustomText(text: "Contact Us", weight:FontWeight.w400 , size: 14.sp, color: secondary))),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),

      floatingActionButton: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 50.h),
        child: BlocConsumer<EducationCubit, EducationState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PrimaryButton(text: 'Continue', onTap: () {
                    if(universityKey.currentState!.validate()&& graduationKey.currentState!.validate()
                        &&facultyKey.currentState!.validate()) {

                      educationCubit.educationDetails(
                          university: selectedUniversity,
                          graduationYear: selectedGraduationYear,
                          faculty: facultyController.text);
                      educationCubit.addEducationDataAndNewID(preferenceCubit,id: CacheHelper.getData(key: "uid") ,university: selectedUniversity
                          , graduationYear: selectedGraduationYear, faculty: facultyController.text);
                      print(preferenceCubit.userModel!.university);
                      print(preferenceCubit.userModel!.graduationYear);
                      print(preferenceCubit.userModel!.faculty);
                      print(preferenceCubit.userModel!.id);
                      print(CacheHelper.getData(key: "uid"));


                      AppNavigator.customNavigator(
                          context: context,
                          screen:    const EducationScanner(),
                          finish: true);
                    }}),
                  SizedBox(height: 15.h),



                ],
              );

            }
        ),

      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }
}