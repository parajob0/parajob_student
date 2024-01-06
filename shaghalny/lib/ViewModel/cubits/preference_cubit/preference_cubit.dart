import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shaghalny/ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import '../../../Model/jobs_model/job_model.dart';
import '/ViewModel/database/cache_helper/cache_helper.dart';

import '../../../Model/admin_model/admin_model.dart';
import '../../../Model/user_model/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
part 'preference_state.dart';

class PreferenceCubit extends Cubit<PreferenceState> {
  PreferenceCubit() : super(PreferenceInitial());

  static PreferenceCubit get(context) =>
      BlocProvider.of<PreferenceCubit>(context);

  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
  CollectionReference adminRef = FirebaseFirestore.instance.collection('admin');
  CollectionReference notiRef = FirebaseFirestore.instance.collection('notifications');


  NewUserModel? userModel;

  Future<void> getUser({String id = 'ROkuqkbItLHg7b2Z2HYL'}) async{
    print("getUser Function");

    if(id == "ROkuqkbItLHg7b2Z2HYL") {
      await CacheHelper.put(key: 'uid', value: "ROkuqkbItLHg7b2Z2HYL");
    }
    await CacheHelper.put(key: 'uid', value: id);


    debugPrint("\n\n get user id ==> ${CacheHelper.getData(key: 'uid')} \n\n");

    //todo change this to the current user id
    await userRef.doc(CacheHelper.getData(key: 'uid')).get().then(
    // userRef.doc('69siIEiFzNhXrRQcLdyZ46CQKBu2').get().then(
            (DocumentSnapshot doc) async{
          final data = doc.data() as Map<String, dynamic>;

          userModel = NewUserModel.fromDocumentSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>);

          await subscribeToTopicNotification();

          debugPrint("\n\n first name = ${userModel!.firstName}");

          emit(GetUserSuccess());
        }, onError: (e) {
      print("Error getting document: $e");
      emit(GetUserError());
    });
  }

  void getDummyUser() {
    userRef.doc('69siIEiFzNhXrRQcLdyZ46CQKBu2').get().then(
            (DocumentSnapshot doc) {
          // final data = doc.data() as Map<String, dynamic>;

          userModel = NewUserModel.fromDocumentSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
        }, onError: (e) {
      print("Error getting document: $e");
      emit(GetUserError());
    });

    emit(GetUserSuccess());
  }

  NewAdminModel? adminModel;

  void getAdmin() {
    adminRef.doc('ijON2lGYNt410JUskAcc').get().then(
            (DocumentSnapshot doc) {
          if (doc.exists) {
            adminModel = NewAdminModel.fromDocumentSnapshot(
                doc as DocumentSnapshot<Map<String, dynamic>>);
          } else {
            adminRef.get().then((QuerySnapshot snapshot) {
              adminModel = NewAdminModel.fromDocumentSnapshot(
                  snapshot.docs[0] as DocumentSnapshot<Map<String, dynamic>>);
            });
          }

          emit(GetAdminSuccess());
        }, onError: (e) {
      print("Error getting document: $e");
      emit(GetAdminError());
    });
  }

  List<dynamic> currentArea = [];

  void changeCity({required String city}) {
    currentArea = adminModel!.area[city];

    emit(CityChanged());
  }

  void changeProfilePic(String str){
    userModel?.profilePic = str;
    emit(ChangeProfilePic());
  }

  void xpLevelUp({required JobModel jobModel, required String value,required String lastJobId , required JobsCubit jobsCubit})async{
    //todo garab el function
    //todo pass params to this function
    await changeDataWhenCheckOut(jobModel: jobModel, lastJobId: lastJobId, jobsCubit: jobsCubit, jobDetail: value);

    // addJobToHistory(jobId: jobModel.jobId, value: value);


    if(userModel!.level == 0){
      userModel!.level = 1;
      userModel!.jobHistory![jobModel.jobId] = value;
      // todo send notification to user
      addToFirebase(levelUP: true);
    }
    else if(userModel!.level == 1){

      //in the beginning of level 1
      if(userModel!.jobHistory!.length == 2){
        userModel!.xp = 1750;
        userModel!.jobHistory![jobModel.jobId] = value;
        addToFirebase(levelUP: false);
      }
      else if(userModel!.jobHistory!.length == 3){
        userModel!.level = 2;
        userModel!.xp = 0;
        userModel!.jobHistory![jobModel.jobId] = value;

        //todo send notification to user
        addToFirebase(levelUP: true);
      }
    }
    else if(userModel!.level == 2){

      //in the beginning of level 2
      if(userModel!.jobHistory!.length == 4){
        userModel!.xp = 1166;
        userModel!.jobHistory![jobModel.jobId] = value;
        addToFirebase(levelUP: false);
      }
      else if(userModel!.jobHistory!.length == 5){
        userModel!.xp = 2334;
        userModel!.jobHistory![jobModel.jobId] = value;
        addToFirebase(levelUP: false);
      }
      else if(userModel!.jobHistory!.length == 6){
        userModel!.level = 3;
        userModel!.xp = 0;
        userModel!.jobHistory![jobModel.jobId] = value;

        //todo send notifications to user
        addToFirebase(levelUP: true);
      }
    }

    // level up based on job hours
    // 200xp to level 4
    else{
      //3 --> 240xp
      //4 --> 220xp
      //5 --> 200xp
      //6 --> 180xp
      //7 --> 160xp
      //8 --> 140xp
      //9 --> 120xp
      //10 --> 100xp

      // 240 - (level - 3)*20

      int hours = jobModel.endDate.toDate().difference(jobModel.startDate.toDate()).inHours;
      int userLevel = userModel!.level!;

      int equation = 240 - (userLevel - 3) * 20;
      int newXP = userLevel < 10 ? (equation * hours): (100 * hours);

      int levelUP = (newXP/3500).floor();
      int newLevel = levelUP + int.parse(userModel!.level.toString());

      userModel!.level = newLevel;

      userModel!.xp = (newXP%3500);

      if(levelUP > 0){
        addToFirebase(levelUP: true);
      }else{
        addToFirebase(levelUP: false);
      }

    }

  }




  void addToFirebase({required bool levelUP}){

    if(levelUP) {
        notiRef.add({
        "date": Timestamp.fromDate(DateTime.now()),
        "is_opened": false,
        "type": "level",
      }).then((value) {
        userRef.doc(userModel!.id).set({
          "notifications": [value.id],
          "level": userModel!.level,
          "xp": userModel!.xp,
          "total_income": userModel!.totalIncome
        },SetOptions(merge: true));
      });
    }
    else{
      print("Change total income");
      userRef.doc(userModel!.id).set({
        "xp": userModel!.xp,
        "total_income": userModel!.totalIncome
      },SetOptions(merge: true));
    }
  }

  void clearCurrentUserModel(){
     try{
       userModel?.clearUserModel();
     }catch(e){
       print(e.toString());
     }

  }

  int isInJobs(String jobId){
    int state = -1;
    userModel?.jobs?.forEach((key, value) {
      if(key == jobId){
          state = int.parse(value[0]);
      }
    });
    return state;
  }

  void changeJobStateInUserModel({required String jobId , required String state}){
    userModel?.jobs?[jobId][0] = state;
  }

  // JobModel , lastJobId ,
  // JobModel.id == lastJobId -> changeState , add  to jobHistory
  // else add  to jobHistory only
  // update UserModel and jobs
  Future<bool> changeDataWhenCheckOut({required JobModel jobModel , required String lastJobId ,required JobsCubit jobsCubit,required String jobDetail})async{
      if(jobModel.jobId == lastJobId){
        // ChangeStateInFirebase
        await jobsCubit.changeJobStateInDataBase(uid: userModel?.id??"", jobId: jobModel.parentID, list: userModel?.jobs?[jobModel.parentID], state: '5');

        // modifyUserJobs;
        changeJobStateInUserModel(jobId: jobModel.parentID, state: '5');

        // modifyJobsInCubit;
        jobsCubit.changeJobStateInAllJobs(jobId:  jobModel.parentID, state: '5');

      }
      //AddToJobHistory
      await jobsCubit.addToJobHistory(jobId: jobModel.jobId, userId: userModel?.id??"", text: jobDetail);
      return true;
  }


  Future<void> subscribeToTopicNotification()async{
    await FirebaseMessaging.instance.subscribeToTopic('public');
    debugPrint("\n\n subscribed to topic \n\n");
    await FirebaseMessaging.instance.subscribeToTopic(userModel!.id!);
  }

}