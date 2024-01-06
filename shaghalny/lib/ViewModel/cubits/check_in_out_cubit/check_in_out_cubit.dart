

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../preference_cubit/preference_cubit.dart';
import '/Model/user_model/user_model.dart';
import '/ViewModel/database/cache_helper/cache_helper.dart';

import '../../../Model/admin_model/admin_model.dart';

part 'check_in_out_state.dart';

class CheckInOutCubit extends Cubit<CheckInOutState> {
  CheckInOutCubit() : super(CheckInOutInitial());

  static CheckInOutCubit get(context) => BlocProvider.of<CheckInOutCubit>(context);


  CollectionReference userRef = FirebaseFirestore.instance.collection('User');

  void checkInOutBalance(PreferenceCubit prefCubit,{
    required String? jobId,
    required String? value,
   /* required String? amount,
    required String? reason,*/
  }) async {
   // String value ="$state--$amount--$reason";
    emit(CheckInOutLoading());
    await FirebaseFirestore.instance
        .collection("User")
        .doc(prefCubit.userModel!.id)
        .set({
      'job_history': {jobId:value},
    },SetOptions(merge: true)).then((value) {
      print("Job History Updated");
      emit(CheckInOutSuccess());
    }).catchError((e) {
      print(e.toString());
    });
  }



  void addInJob({required String userId, required String value})async{
    await userRef.doc(userId).update({'in_job': value});
  }

  void deleteInJob({required userId})async{
    await userRef.doc(userId).update({'in_job': FieldValue.delete()});
  }

}










