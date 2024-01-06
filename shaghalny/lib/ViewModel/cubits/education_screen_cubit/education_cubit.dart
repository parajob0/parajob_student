
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/Model/user_model/user_model.dart';

import '../../database/cache_helper/cache_helper.dart';
import '../preference_cubit/preference_cubit.dart';

part 'education_state.dart';

class EducationCubit extends Cubit<EducationState> {
  EducationCubit() : super(EducationScreenInitial());

  static EducationCubit get(context) => BlocProvider.of<EducationCubit>(context);
  void educationDetails({
    required String? university,
    required String? graduationYear,
    required String faculty,

  }) {
    emit(EducationScreenLoading());
    FirebaseFirestore.instance.collection("User").doc(CacheHelper.getData(key: 'uid')).update(
        {
          "university": university,
          "graduation_year": graduationYear,
          "faculty":faculty ,

        }
    ).then((value) {
      print("Education Details Added");
      // UserModel.setUniversity(university!);
      // UserModel.setGraduationYear(graduationYear!);
      // UserModel.setFaculty(faculty);
      emit(EducationScreenDataSuccess());

    }).catchError((e) {
      print(e.toString());
    });
  }




  void addEducationDataAndNewID(PreferenceCubit prefCubit, {
    required  university,
    required  graduationYear,
    required  faculty,
    required id

  }){
    try{//prefCubit.getUser();
      prefCubit.userModel!.university=university.toString();
      prefCubit.userModel!.graduationYear=graduationYear.toString();
      prefCubit.userModel!.faculty=faculty.toString();
      prefCubit.userModel!.id=id.toString();




      emit(AddEducationDataSuccess());
    }catch(e){
      debugPrint("\n\n\n Error Add Data $e \n\n\n");
      emit(AddEducationDataError());
    }
  }










}






















