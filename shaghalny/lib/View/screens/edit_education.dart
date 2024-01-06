import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/Model/user_model/user_model.dart';
import '/View/components/core/custom_dropdownmenu.dart';
import '/View/screens/Alerts/save_changes.dart';
import '/View/screens/app_complaint.dart';
import '/color_const.dart';
import 'package:intl/intl.dart';

import '../../ViewModel/cubits/edit_info_cubit/edit_info_cubit.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../utils/page_route.dart';
import '../components/core/buttons.dart';
import '../components/core/text_field.dart';

class EditEducationScreen extends StatelessWidget {
   EditEducationScreen({Key? key}) : super(key: key);
   String? selectedGraduationYear;
   List<String>? graduationYearList;
   String yearNow=DateFormat.y().format(DateTime.now());
   int? yearNowForOperations;

   GlobalKey<FormState>facultyKey = new GlobalKey<FormState>();
   GlobalKey<FormState>graduationKey = new GlobalKey<FormState>();
   TextEditingController facultyController = new TextEditingController();
   @override
  Widget build(BuildContext context) {
     EditInfoCubit editInfoCubit = BlocProvider.of<EditInfoCubit>(context, listen: true);
     PreferenceCubit preferenceCubit = BlocProvider.of<PreferenceCubit>(context, listen: true);
     facultyController.text=preferenceCubit.userModel!.faculty!;
     selectedGraduationYear=preferenceCubit.userModel!.graduationYear;

     yearNowForOperations= int.parse(yearNow);
     graduationYearList=[yearNowForOperations.toString(),(yearNowForOperations!+1).toString(),(yearNowForOperations!+2).toString(),(yearNowForOperations!+3).toString(),
       (yearNowForOperations!+4).toString(),(yearNowForOperations!+5).toString(),(yearNowForOperations!+6).toString()];

     return Scaffold(
      backgroundColor: primary,
      body:SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropDownMenuButton(formKey: graduationKey,
                  list: graduationYearList!,
                  hintText: Text('Choose your graduation year',style: TextStyle(color: Colors.grey),),
                  value: selectedGraduationYear != "" ? selectedGraduationYear : null,
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
                formKey: facultyKey,
                controller: facultyController,
                  hintText:"Enter Your Faculty",
                onchange: (val) {
                  print(val);
                },
                  validate: (value){
                    if(value == null || value.isEmpty){
                      return 'Faculty is required';}
                    else{return null;}}
              ),
            ],

          ),
        ),
      ),
       floatingActionButton: Column(
         mainAxisAlignment: MainAxisAlignment.end,
         children: [
           PrimaryButton(text: 'Save Changes', onTap: () {
     if (facultyKey.currentState!.validate()) {
       showDialog(
           context: context,
           builder: (context) {
             return  AlertToSaveChanges(onTap: (){
               Fluttertoast.showToast(
                   msg: "you need to take permission to change education info",
                   toastLength: Toast.LENGTH_LONG,
                   gravity: ToastGravity.BOTTOM,
                   backgroundColor: secondary,
                   textColor: Colors.white,
                   fontSize: 8.0
               );
               AppNavigator.customNavigator(
                   context: context,
                   screen: AppComplaint(),
                   finish: false);
             },onCancelTap: (){
               Navigator.pop(context);
             },);
           });

     }
           }),
         ],
       ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,




     );
  }
}