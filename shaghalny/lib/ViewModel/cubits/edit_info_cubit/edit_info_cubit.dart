import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/Model/user_model/user_model.dart';
import '/ViewModel/database/cache_helper/cache_helper.dart';

import '../preference_cubit/preference_cubit.dart';

part 'edit_info_state.dart';

class EditInfoCubit extends Cubit<EditInfoState> {
  EditInfoCubit() : super(EditInfoInitial());

  static EditInfoCubit get(context) => BlocProvider.of<EditInfoCubit>(context);

  void editMainData({
    //required String? graduation_year,
   // required String? faculty,
    required String? email,
   // required String? account_name,
   // required String account_number,
   // required String? bank_name,
    required String? area,
    required String? city,
  })async {
     emit(EditMainInfoLoading());
     await FirebaseFirestore.instance.collection("User").doc(CacheHelper.getData(key: 'uid')).update({
    //   "account_name": account_name,
    //   "account_number":int.parse(account_number) ,
    //   "bank_name": bank_name,
       "email": email,
    //   "faculty": faculty,
    //   "graduation_year": graduation_year,
      "city": city,
       "area": area,
     }).then((value) {
      print("Main Data Updated");
      emit(EditMainInfoSuccess());

     }).catchError((e) {
       print(e.toString());
     });
  }

  void addMainData(PreferenceCubit prefCubit, {
    required  email,
    required  city,
    required  area,
  }){
    try{//prefCubit.getUser();
      prefCubit.userModel!.email=email.toString();
      prefCubit.userModel!.city=city.toString();
      prefCubit.userModel!.area=area.toString();
      emit(AddMainDataSuccess());
    }catch(e){
      debugPrint("\n\n\n Error Add Data $e \n\n\n");
      emit(AddMainDataError());
    }
  }


  void editPaymentData({
    //required String? graduation_year,
    // required String? faculty,

     required String? accountName,
     required String accountNumber,
     required String? bankName,

  })async {
    emit(EditPaymentInfoLoading());
    await FirebaseFirestore.instance.collection("User").doc(CacheHelper.getData(key: 'uid')).update({
         "account_name": accountName,
         "account_number":int.parse(accountNumber) ,
         "bank_name": bankName,

    }).then((value) {
      print("Payment Data Updated");
      emit(EditPaymentInfoSuccess());

    }).catchError((e) {
      print(e.toString());
    });
  }

  void addPaymentData(PreferenceCubit prefCubit, {
    required  accountName,
    required  accountNumber,
    required  bankName,
  }){
    try{//prefCubit.getUser();
      prefCubit.userModel!.accountName=accountName.toString();
      prefCubit.userModel!.accountNumber=int.parse(accountNumber);
      prefCubit.userModel!.bankName=bankName.toString();
      emit(AddPaymentDataSuccess());
    }catch(e){
      debugPrint("\n\n\n Error Add Data $e \n\n\n");
      emit(AddPaymentDataError());
    }
  }







}