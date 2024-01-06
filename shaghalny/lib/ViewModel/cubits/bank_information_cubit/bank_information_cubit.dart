import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '/ViewModel/cubits/preference_cubit/preference_cubit.dart';

import '../../../Model/user_model/user_model.dart';
import '../../database/cache_helper/cache_helper.dart';

part 'bank_information_state.dart';

class BankInformationCubit extends Cubit<BankInformationState> {
  BankInformationCubit() : super(BankInformationInitial());

  bool bankNumberErrorBorder = false;

  static BankInformationCubit get(context) => BlocProvider.of<BankInformationCubit>(context);

  void uploadBankInfo( PreferenceCubit prefCubit, {
      required String accountName,
      required int accountNumber,
      required String bankName,
    }){

      FirebaseFirestore.instance.collection("User").doc(CacheHelper.getData(key: 'uid')).update(
          {
            "account_name": accountName,
            "account_number": accountNumber,
            "bank_name": bankName,

          }
      ).then((value) {
        print("Bank Details Added");

      });

      prefCubit.userModel!.accountName = accountName;
      prefCubit.userModel!.accountNumber = accountNumber;
      prefCubit.userModel!.bankName = bankName;

      emit(BankInformationError());

  }

  void accountNumberErrorMessage(bool val) {
    bankNumberErrorBorder = val;
    emit(BankNumberErrorMessage());
  }

  void addBankData(PreferenceCubit prefCubit, {
    required accountName,
    required accountNumber,
    required bankName,

  }){
    try{//prefCubit.getUser();
      prefCubit.userModel!.accountName=accountName.toString();
      prefCubit.userModel!.accountNumber=int.parse(accountNumber);
      prefCubit.userModel!.bankName=bankName.toString();



      emit(AddBankDataSuccess());
    }catch(e){
      debugPrint("\n\n\n Error Add Data $e \n\n\n");
      emit(AddBankDataError());
    }
  }










}