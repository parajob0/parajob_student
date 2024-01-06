import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import '../../../color_const.dart';
import '/Model/user_model/user_model.dart';
import '/ViewModel/database/cache_helper/cache_helper.dart';

import '../../../Model/admin_model/admin_model.dart';
import '../preference_cubit/preference_cubit.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  // List<String> cityList=[];


  static SignUpCubit get(context) => BlocProvider.of<SignUpCubit>(context);

  void createNewUser(PreferenceCubit prefCubit, {
    required String first_name,
    required String last_name,
    required String email,
    required String phone,
    required String password,
    required String? gender,
    required String? area,
    required String? city,
    required int? level,
    required String token
    // required bool isApproved,
    // required bool withGoogle,
  }) {
    emit(SignUpLoading());

    prefCubit.userModel!.isApproved = false;

    if (prefCubit.userModel!.externalSignIn!) {

      // String uid = value.user!.uid;
      CacheHelper.setData(key: 'uid', value: prefCubit.userModel!.id.toString());
      print(CacheHelper.getData(key: 'uid'));
      print("must be changed");
      GetStorage().write('uid', prefCubit.userModel!.id.toString());
      debugPrint("\n\n create new user id --> ${prefCubit.userModel!.id.toString()} \n\n");

      allData(uId: prefCubit.userModel!.id.toString(),
          first_name: first_name,
          last_name: last_name,
          email: email,
          password: password,
          phoneNumber: phone,
          gender: gender,
          area: area,
          city: city,
          level: level,
          token: token
          // isApproved: false,
          // withGoogle: true,
      );

      print("Sign Up done");
      //  print(UserModel.getID());
      emit(SignUpDataSuccess());
    }else{
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: password)
          .then((value) async {
        // String uid = value.user!.uid;
        await CacheHelper.setData(key: 'uid', value: value.user!.uid);
        print(CacheHelper.getData(key: 'uid'));
        print("must be changed");
        GetStorage().write('uid', value.user!.uid);
        debugPrint("\n\n create new user id --> ${value.user!.uid} \n\n");
        allData(uId: value.user!.uid,
            first_name: first_name,
            last_name: last_name,
            email: email,
            phoneNumber: phone,
            gender: gender,
            password: password,
            city: city,
            area: area,
            level: level,
            token: token
            // isApproved: false,
            // withGoogle: false
        );
        // UserModel.setID(value.user?.uid);
        print("Sign Up done");
        //  print(UserModel.getID());
        emit(SignUpDataSuccess());
      })
          .catchError((e) {
        print(e.toString());
        if(e is PlatformException) {
          if(e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
            Fluttertoast.showToast(
                msg: "Email Already Exists",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: secondary,
                textColor: Colors.white,
                fontSize: 8.0
            );
          }
        }
      });
    }
  }

  void allData({ required String uId,
    required String first_name,
    required String last_name,
    required String email,
    required String password,
    required String phoneNumber,
    required String? gender,
    required String? area,
    required String? city,
    required int? level,
    required String token
    // required bool isApproved,
    // required bool withGoogle,

  }) {
    if(password == ""){
      FirebaseFirestore.instance.collection("User").doc(uId).set({
        "user_id": uId,
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "phone_number": phoneNumber,
        "gender": gender,
        "city": city,
        "area": area,
        "level": level,
        "is_approved": false,
        "with_google": true,
        "token": token
      }).then((value) {
        print("User Added");
      }).catchError((e) {
        print(e.toString());
      });
    }
    else{
      FirebaseFirestore.instance.collection("User").doc(uId).set({
        "user_id": uId,
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "phone_number": phoneNumber,
        "gender": gender,
        "city": city,
        "area": area,
        "password": password,
        "level": level,
        "is_approved": false,
        "with_google": false,
        "token": token
      }).then((value) {
        print("User Added");
      }).catchError((e) {
        print(e.toString());
      });
    }
  }

  void addData(PreferenceCubit prefCubit, {
    required id,
    required firstName,
    required lastName,
    required email,
    required password,
    required phoneNumber,
    required gender,
    required area,
    required city,
    required level,
    required isApproved,

  }) {
    try { //prefCubit.getUser();
      prefCubit.userModel!.id = id.toString();
      prefCubit.userModel!.firstName = firstName.toString();
      prefCubit.userModel!.lastName = lastName.toString();
      prefCubit.userModel!.email = email.toString();
      prefCubit.userModel!.phoneNumber = phoneNumber.toString();
      prefCubit.userModel!.password = password.toString();
      prefCubit.userModel!.gender = gender.toString();
      prefCubit.userModel!.area = area.toString();
      prefCubit.userModel!.city = city.toString();
      prefCubit.userModel!.level = level;
      prefCubit.userModel!.isApproved = isApproved;


      emit(AddDataSuccess());
    } catch (e) {
      debugPrint("\n\n\n Error Add Data $e \n\n\n");
      emit(AddDataError());
    }
  }


  void addCityArea(PreferenceCubit prefCubit, {
    required city,
    required area,
  }) {
    try { //prefCubit.getUser();
      prefCubit.userModel!.city = city.toString();
      prefCubit.userModel!.area = area.toString();


      emit(AddCityAreaSuccess());
    } catch (e) {
      debugPrint("\n\n\n Error Add Data $e \n\n\n");
      emit(AddCityAreaError());
    }
  }


  void addBasicData(PreferenceCubit prefCubit, {
    required firstName,
    required lastName,
    required email,
    required phoneNumber,
    required gender,

  }) {
    try { //prefCubit.getUser();
      prefCubit.userModel!.firstName = firstName.toString();
      prefCubit.userModel!.lastName = lastName.toString();
      prefCubit.userModel!.email = email.toString();
      prefCubit.userModel!.phoneNumber = phoneNumber.toString();
      prefCubit.userModel!.gender = gender.toString();


      emit(AddBasicDataSuccess());
    } catch (e) {
      debugPrint("\n\n\n Error Add Data $e \n\n\n");
      emit(AddBasicDataError());
    }
  }


  void addPassLevelData(PreferenceCubit prefCubit, {
    required password,
    required level,


  }) {
    try { //prefCubit.getUser();
      prefCubit.userModel!.password = password.toString();
      prefCubit.userModel!.level = int.parse(level);


      emit(AddBasicDataSuccess());
    } catch (e) {
      debugPrint("\n\n\n Error Add Data $e \n\n\n");
      emit(AddBasicDataError());
    }
  }


}










