import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/Model/user_model/user_model.dart';
import '/View/components/core/custom_dropdownmenu.dart';
import '/View/screens/Alerts/save_changes.dart';
import '/color_const.dart';

import '../../ViewModel/cubits/edit_info_cubit/edit_info_cubit.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../components/core/buttons.dart';
import '../components/core/text_field.dart';
class EditPaymentScreen extends StatelessWidget {
   EditPaymentScreen({Key? key}) : super(key: key);
   TextEditingController accountName = TextEditingController();
   TextEditingController accountNumber = TextEditingController();
   TextEditingController bankName = TextEditingController();
   GlobalKey<FormState> accountNameKey = GlobalKey<FormState>();
   GlobalKey<FormState> accountNumberKey = GlobalKey<FormState>();
   GlobalKey<FormState> bankNameKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    EditInfoCubit editInfoCubit = BlocProvider.of<EditInfoCubit>(context, listen: true);
    PreferenceCubit preferenceCubit = BlocProvider.of<PreferenceCubit>(context, listen: true);
    bankName.text = preferenceCubit.userModel!.bankName!;
    accountName.text = preferenceCubit.userModel!.accountName!;
    accountNumber.text = preferenceCubit.userModel!.accountNumber.toString();
    return Scaffold(
      backgroundColor: primary,
      body:SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextField(
                formKey: accountNameKey,
                controller: accountName,
                hintText: "Enter Your Account name",
                onchange: (val) {
                  print(val);
                },
                  validate: (value){
                    if(value == null || value.isEmpty){
                      return 'Account name is required';}
                    else{return null;}}
              ),
              SizedBox(height: 15.h),
              DefaultTextField(
                formKey: accountNumberKey,
                controller: accountNumber,
                hintText: "Enter Your Account Number",
                onchange: (val) {
                  print(val);
                },
                validate: (val){
                  if(val!.length != 16){

                    return 'Account Number must be 16 digits';
                  }else{
                    return null;
                  }
                },
              ),
              SizedBox(height: 15.h),
              DefaultTextField(
                formKey: bankNameKey,
                controller: bankName,
                hintText: "Enter Your Bank Name",
                onchange: (val) {
                  print(val);
                },
                  validate: (value){
                    if(value == null || value.isEmpty){
                      return 'Bank Name is required';}
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
    if (accountNameKey.currentState!.validate()&&accountNumberKey.currentState!.validate()&&bankNameKey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return  AlertToSaveChanges(onTap: (){
              editInfoCubit.editPaymentData(accountName: accountName.text,
                  accountNumber: accountNumber.text,
                  bankName: bankName.text);
              editInfoCubit.addPaymentData(
                  preferenceCubit, accountName: accountName.text,
                  accountNumber: accountNumber.text,
                  bankName: bankName.text);
              print(preferenceCubit.userModel!.accountName);
              print(preferenceCubit.userModel!.accountNumber);
              print(preferenceCubit.userModel!.bankName);
              Navigator.pop(context);
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