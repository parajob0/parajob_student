import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
part 'apply_for_job_state.dart';

class ApplyForJobCubit extends Cubit<ApplyForJobState> {
  ApplyForJobCubit() : super(ApplyForJobInitial());

  static ApplyForJobCubit get(context) =>
      BlocProvider.of<ApplyForJobCubit>(context);

  bool applyForJobLoadingIndicator = false;

  void changeApplyForJobLoadingIndicator(bool x) {
    applyForJobLoadingIndicator = x;
    emit(ChangeApplyForJobLoadingIndicator());
  }

  Future<bool> checkUserFrontId(String uid) async {
    try {
      final Reference fileRef =
      FirebaseStorage.instance.ref().child('/front_id/${uid}.jpg');
      String downloadUrl = await fileRef.getDownloadURL();
      // print(downloadUrl);
      emit(CheckFrontIdSuccess());
      return true;
    } catch (e) {
      emit(CheckFrontIdSuccess());
      return false;
    }
  }

  Future<bool> checkUniversityId(String uid) async {
    try {
      final Reference fileRef =
      FirebaseStorage.instance.ref().child('/university_id/${uid}.jpg');
      String downloadUrl = await fileRef.getDownloadURL();
      // print(downloadUrl);
      emit(CheckuniversityIdSuccess());
      return true;
    } catch (e) {
      emit(CheckuniversityIdSuccess());
      return false;
    }
  }


  Future<bool> checkPicWithId(String uid) async {
    try {
      final Reference fileRef =
      FirebaseStorage.instance.ref().child('/picture_with_id/${uid}.jpg');
      String downloadUrl = await fileRef.getDownloadURL();
      // print(downloadUrl);
      emit(CheckPicWithIdSuccess());
      return true;
    } catch (e) {
      emit(CheckPicWithIdSuccess());
      return false;
    }
  }

  // from firebase
  Future<void> applyForJob(String jobId, context) async {
    try {
      emit(ApplyForJobLoading());
      PreferenceCubit preferenceCubit = PreferenceCubit.get(context);
      String uid = preferenceCubit.userModel?.id ?? "";
      DocumentReference<Map<String, dynamic>> value = FirebaseFirestore.instance.collection('User').doc(uid);
      List<dynamic> list = ['1', Timestamp.now()];

      preferenceCubit.userModel!.jobs![jobId] = list;

      await value.update({
        'jobs.$jobId': list,
      });
      await addToJobsAppliedUsers(jobId,uid);
      print("success");
      emit(ApplyForJobSuccess());
    } catch (e) {
      print(e.toString());
      emit(ApplyForJobFail());
    }
  }

  // from firebase
  Future<void> deleteJob(String jobId, context) async {
    try {
      emit(DeleteJobLoading());
      PreferenceCubit preferenceCubit = PreferenceCubit.get(context);
      String uid = preferenceCubit.userModel?.id ?? "";
      DocumentReference<Map<String, dynamic>> value =
      FirebaseFirestore.instance.collection('User').doc(uid);
      await value.update({
        'jobs.$jobId': FieldValue.delete(),
      });
      await deleteFromJobsAppliedUsers(jobId,uid);
      await deleteFromJobsApprovedUsers(jobId,uid);
      print("deleted");
      emit(DeleteJobSuccess());
    } catch (e) {
      print(e.toString());
      emit(DeleteJobFail());
    }
  }

  // in Job Collection
  Future<void> addToJobsAppliedUsers(String jobId, String uid) async {
    final CollectionReference myListRef = FirebaseFirestore.instance.collection('jobs');
    await myListRef.doc(jobId).update({
      'applied_users': FieldValue.arrayUnion([uid]),
    })
        .then((value){
      emit(AddToJobsAppliedUsersSuccess());
    })
        .catchError((e) {
      print(e.toString());
      emit(AddToJobsAppliedUsersFail());
    });

  }

  // in Job Collection
  Future<void> deleteFromJobsAppliedUsers(String jobId, String uid)async{
    final DocumentReference myDocRef = FirebaseFirestore.instance.collection('jobs').doc(jobId);

    await myDocRef.update({'applied_users': FieldValue.arrayRemove([uid]),});
    emit(DeleteFromJobsAppliedUsers());
  }
  Future<void> deleteFromJobsApprovedUsers(String jobId, String uid)async{
    final DocumentReference myDocRef = FirebaseFirestore.instance.collection('jobs').doc(jobId);

    await myDocRef.update({'approved_users': FieldValue.arrayRemove([uid]),});
    emit(DeleteFromJobsApprovedUsers());
  }
}