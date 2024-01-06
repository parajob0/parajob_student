import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/Model/user_model/user_model.dart';
import '/View/components/core/custom_dropdownmenu.dart';
import '/View/screens/Alerts/save_changes.dart';
import '/ViewModel/cubits/edit_info_cubit/edit_info_cubit.dart';
import '/ViewModel/cubits/sign_up_cubit/sign_up_cubit.dart';
import '/color_const.dart';

import '../../Model/admin_model/admin_model.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../components/core/buttons.dart';
import '../components/core/text_field.dart';

class EditMainInfoScreen extends StatelessWidget {
  EditMainInfoScreen({Key? key}) : super(key: key);
  String? selectedCity;
  String? selectedArea;
  List<String>? cityList;
  List<String>? areaList;
  List<dynamic>? test;
  GlobalKey<FormState> cityKey = new GlobalKey<FormState>();
  GlobalKey<FormState> areaKey = new GlobalKey<FormState>();
  GlobalKey<FormState>emailKey = new GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    EditInfoCubit editInfoCubit = BlocProvider.of<EditInfoCubit>(context, listen: true);
    PreferenceCubit preferenceCubit = BlocProvider.of<PreferenceCubit>(context, listen: true);
   /* cityList= preferenceCubit.adminModel!.city.map((e) => e.toString()).toList();
    test=   preferenceCubit.adminModel!.area.entries.map( (entry) => (entry.value)).toList();
    areaList= test!.map((e) => e.toString()).toList();*/
    emailController.text=preferenceCubit.userModel!.email!;
    selectedCity=preferenceCubit.userModel!.city;
    selectedArea=preferenceCubit.userModel!.area;

    return Scaffold(
      backgroundColor: primary,
      body:SingleChildScrollView(
        child: Container(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextField(
                formKey: emailKey,
                controller: emailController,
                hintText: "",
                onchange: (val) {
                  print(val);
                },
                validate: (email) {
                  final bool emailValid =
                  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(email??"");

                  if (!emailValid) {
                    return 'Email is not valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15.h),

              CustomDropDownMenuButton(
                formKey: cityKey,
                list: preferenceCubit.adminModel!.city.map((e) => e.toString()).toList(),//AdminModel.getCity(),
                value: selectedCity,
                onchange: (String? newValue) {
                  selectedCity = newValue;
                  preferenceCubit.changeCity(city: newValue.toString());
                },

              ),
              SizedBox(height: 15.h),
              CustomDropDownMenuButton(
                formKey: areaKey,
                list:preferenceCubit.currentArea.map((e) => e.toString()).toList(),//AdminModel.getArea(),
                value: selectedArea,
                onchange: (String? newValue) {
                  selectedArea = newValue;
                },
              ),
            ],

          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PrimaryButton(text: 'Save Changes', onTap: () { //if (emailKey.currentState!.validate()) {
            showDialog(
                context: context,
                builder: (context) {
                  return  AlertToSaveChanges(onTap: (){
                    editInfoCubit.editMainData(email: emailController.text,
                        area: selectedArea,
                        city: selectedCity);
                    editInfoCubit.addMainData(
                        preferenceCubit, email: emailController.text,
                        city: selectedCity,
                        area: selectedArea);
                    Navigator.pop(context);
                    print(preferenceCubit.userModel!.email);
                    print(preferenceCubit.userModel!.city);
                    print(preferenceCubit.userModel!.area);
                  },onCancelTap: (){
                    Navigator.pop(context);
                  },);
                });


          }),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,



    );





  }
}