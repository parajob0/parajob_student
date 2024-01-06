import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/Model/user_model/user_model.dart';
import '/ViewModel/database/cache_helper/cache_helper.dart';

import '../preference_cubit/preference_cubit.dart';

part 'complaints_review_state.dart';

class ComplaintReviewCubit extends Cubit<ComplaintReviewState> {
  ComplaintReviewCubit() : super(ComplaintReviewInitial());

  static ComplaintReviewCubit get(context) => BlocProvider.of<ComplaintReviewCubit>(context);

  void reviewData(PreferenceCubit prefCubit, {
    required String? review,
    required String? rating,
    required String? day,
    required String? month,
    required String? year,
    required String? employerId,
    required double? rate,
  }) async {
    emit(SubmitReviewLoading());
    await FirebaseFirestore.instance
        .collection("employer")
        .doc("$employerId")
        .set({
      'reviews':{'${prefCubit.userModel!.id}':FieldValue.arrayUnion(["$review--$rating--$day.$month.$year"])},
      'rate': rate,
    },SetOptions(merge: true)).then((value) {
      print("Review Updated");
      emit(SubmitReviewSuccess());
    }).catchError((e) {
      print(e.toString());
    });
  }

  void complaintAboutPlace(PreferenceCubit prefCubit,{
    required String? employerId,
    required String? complaint,
  }) async {
    emit(ComplaintAboutPlaceLoading());
    await FirebaseFirestore.instance
        .collection("employer")
        .doc("$employerId")
        .set({
      'complaints': {prefCubit.userModel!.id: complaint},
    },SetOptions(merge: true)).then((value) {
      print("Complaint about place Updated");
      emit(ComplaintAboutPlaceSuccess());
    }).catchError((e) {
      print(e.toString());
    });
  }

  void complaintAboutJob(PreferenceCubit prefCubit,{
    required String? jobId,
    required String? complaint,
  }) async {
    emit(ComplaintAboutJobLoading());
    await FirebaseFirestore.instance
        .collection("jobs")
        .doc("$jobId")
        .set({
      'complaints': {prefCubit.userModel!.id: complaint},
    },SetOptions(merge: true)).then((value) {
      print("Complaint about job Updated");
      emit(ComplaintAboutJobSuccess());
    }).catchError((e) {
      print(e.toString());
    });
  }


  void appComplaint({
    required String? id,
    required String? complaint,
  }) async {
    emit(AppComplaintLoading());
    await FirebaseFirestore.instance
        .collection("admin")
        .doc('ijON2lGYNt410JUskAcc')
        .set({
      'complaints': {id: complaint},
    },SetOptions(merge: true)).then((value) {
      print("Complaint about app Updated");
      emit(AppComplaintSuccess());
    }).catchError((e) {
      print(e.toString());
    });
  }



}
