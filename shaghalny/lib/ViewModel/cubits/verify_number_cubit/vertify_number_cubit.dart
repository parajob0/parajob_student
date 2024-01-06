import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shaghalny/utils/snackbar.dart';

import '../../../View/components/core/alert_message.dart';
import '../../../View/screens/Alerts/otp_failed.dart';
part 'vertify_number_state.dart';

class VertifyNumberCubit extends Cubit<VertifyNumberState> {
  VertifyNumberCubit() : super(VertifyNumberInitial());
  static VertifyNumberCubit get(context) => BlocProvider.of(context);

  bool? phoneErrorBorder = false;
  static String verId="";
  static String phone="";
  String errorMessage = "";
  bool sendOTPLoadingIndecator = false;
  bool verifyNumberLoadingIndecator = false;
  bool sendAgainEmailLoadingIndecator = false;
  void changePhoneErrorMessage(bool val) {
    phoneErrorBorder = val;
    emit(ChangePhoneErrorMessage());
  }

  void setPhoneNumber(String n){
    phone = n;
    emit(PhoneNumberChanged());
  }

  void setErrorMessage(String s){
    errorMessage = s;
    emit(SetErrorMessage());
  }

  void changeSendOTPLoadingIndecator(bool x){
    sendOTPLoadingIndecator = x;
    emit(ChangeSendOTPLoadingIndecator());
  }

  void changeVerifyNumberLoadingIndecator(bool x){
    verifyNumberLoadingIndecator = x;
    emit(ChangeVerifyNumberLoadingIndecator());
  }

  void changeSendAgainEmailLoadingIndecator(bool x){
    sendAgainEmailLoadingIndecator = x;
    emit(ChangeSendAgainEmailLoadingIndecator());
  }


  // send OTP
  Future<void> phoneAuthentication(String phoneNumber,int timeout,context) async {
    String number = "+2"+phoneNumber;
    setPhoneNumber(phoneNumber);
    emit(SendOTPPhoneNumberLoading());

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) {
      },
      verificationFailed: (FirebaseAuthException e) {
        print("\n\n\n\n");
        print(e.toString());
        print("\n\n\n\n");
        print("failed");
        // snackbarMessage("Limit exceeded please try again later", context);
        showDialog(
          context: context,
          builder: (context) {
            return const OTPFailed();
          },
        );
        changeSendOTPLoadingIndecator(false);
        emit(SendOTPPhoneNumberFail());
      },
      codeSent: (String verificationId, int? resendToken) {
        verId = verificationId;
        print("Code Sent");
        snackbarMessage("Code Sent", context);
        emit(SendOTPPhoneNumberSuccess());
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        changeSendOTPLoadingIndecator(false);
      },
      timeout: Duration(seconds: timeout),
    );
  }

  Future<bool> verifyOTPPhoneNumber(String sms,context) async {
    // Create a PhoneAuthCredential with the code
    emit(VerifyEmailAndPhoneLoading());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verId,
      smsCode: sms,
    );
    try{
      var value = await FirebaseAuth.instance.signInWithCredential(credential);
      if(value.user != null){
        print("Phone Code is correct");
        emit(VerifyOTPPhoneNumberSuccess());
        return true;
      }else{
        print("Phone Code is wrong");
        snackbarMessage("Phone Code is wrong", context);
        emit(VerifyOTPPhoneNumberFail());
        return false;
      }
    }catch(e){
      print(e.toString());
      snackbarMessage("please try again later.", context);
      return false;
    }

  }


  // for forget password screen
  Future<String>getUserEmailByPhoneNumber(String number)async{
    String email="";

    await FirebaseFirestore.instance.collection('User').get().then((value){
      value.docs.forEach((element) {
        if(element.data()['phone_number'] == number){
          email = element.data()['email'];
        }
      });
    });
    emit(GetUserEmailByPhoneNumberSuccess());
    return email;
  }

  Future<void>resetEmailPassword({required String phoneNumber , required context})async{

    emit(ResetPasswordEmailSentLoading());
    try{
      String email = await getUserEmailByPhoneNumber(phoneNumber);
      if(email.isNotEmpty){
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        print("Check your Email Please");
        snackbarMessage("Check your Email Please", context);
        emit(ResetPasswordEmailSentSucc());
      }else{
        snackbarMessage("Email with this phone number not found", context);
        emit(ResetPasswordEmailSentFail());
      }
    }catch(e){
      print(e.toString());
      snackbarMessage("Try again later", context);
      emit(ResetPasswordEmailSentFail());
    }


  }

}