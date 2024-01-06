import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import 'package:shaghalny/ViewModel/database/cache_helper/cache_helper.dart';

import '../../../Model/notification_model/notification_model.dart';
import '../../../Model/user_model/user_model.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  static NotificationsCubit get(context) =>
      BlocProvider.of<NotificationsCubit>(context);

  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
  CollectionReference jobRef = FirebaseFirestore.instance.collection('jobs');
  CollectionReference employerRef =
  FirebaseFirestore.instance.collection('employer');
  CollectionReference notiRef =
  FirebaseFirestore.instance.collection('notifications');

  List<NotificationModel> notificationModel = [];
  bool gotNotifications = false;
  int unseenNotifications = 0;

  void getNotifications({required String userId, required PreferenceCubit prefCubit,/* required List userNotifications*/}) async{

    List userNotifications = [];
    // unseenNotifications = 0;
    try{


      if(notificationModel.isEmpty){
        debugPrint("\n\n get notifications function \n\n");
        userNotifications = await updateUserModel(userId: userId, prefCubit: prefCubit);

        for (var value in userNotifications){

          DocumentSnapshot<dynamic> snapshot = await notiRef.doc(value).get();

          if(snapshot.data()['job_id'] != null){

            DocumentSnapshot jobSnapshot =
            await jobRef.doc(snapshot.data()!['job_id'].toString().trim()).get();

            final data = jobSnapshot.data() as Map<String, dynamic>;

            DocumentSnapshot employerSnapshot =
            await employerRef.doc(data['employer_id'].toString().trim()).get();

            //CHECK IF OPENED
            debugPrint("\n\n is opened --> ${snapshot.data()!['is_opened']} \n\n");
            if(snapshot.data()!['is_opened'] == false){
              unseenNotifications++;
            }

            notificationModel.add(NotificationModel.fromDocumentSnapshot(
                snapshot as DocumentSnapshot<Map<String, dynamic>>,
                jobSnapshot as DocumentSnapshot<Map<String, dynamic>>,
                employerSnapshot as DocumentSnapshot<Map<String, dynamic>>));
          }else{

            //CHECK IF OPENED
            if(snapshot.data()!['is_opened'] == false){
              unseenNotifications++;
            }
            notificationModel.add(NotificationModel.withoutJobID(
              snapshot as DocumentSnapshot<Map<String, dynamic>>,));
          }


          // notiRef.doc(value).get().then((DocumentSnapshot doc) {
          //   // GET JOB MODEL FROM JOB ID
          //
          //   // GET EMPLOYER MODEL FROM JOB ID
          //
          //   notificationModel.add(NotificationModel.fromDocumentSnapshot(
          //       doc as DocumentSnapshot<Map<String, dynamic>>));
          //
          //   gotNotifications = true;
          //   emit(GetNotificationsSuccess());
          // }, onError: (e) {
          //   print("Error getting document: $e");
          //   gotNotifications = false;
          //   emit(GetNotificationsError());
          // });
        }

        notificationModel.sort((a, b) => b.date.compareTo(a.date));
      }

      gotNotifications = true;


      debugPrint("\n\n unseen ==> $unseenNotifications \n\n");

      emit(GetNotificationsSuccess());
    }catch(e){
      debugPrint("\n\n\nError getting document: $e\n\n\n");
      gotNotifications = false;
      emit(GetNotificationsError());
    }
  }

  Future<List> updateUserModel({required String userId, required PreferenceCubit prefCubit}) async{


    debugPrint("\n\n user Id ==> ${GetStorage().read('uid')} \n\n");
    // debugPrint("\n\n update user Model function \n\n");

    List userNotifications = [];

    DocumentSnapshot<Map<String, dynamic>> snapshot = await userRef.doc(GetStorage().read('uid')).get() as DocumentSnapshot<Map<String, dynamic>>;

    // prefCubit.userModel!.notifications = snapshot.data()!['notifications'];
    prefCubit.userModel = NewUserModel.fromDocumentSnapshot(snapshot);

    debugPrint("\n\n notifications ==> ${snapshot.data()!['notifications']} \n\n");

    userNotifications = prefCubit.userModel!.notifications;

    return userNotifications;
  }


  void changeNotificationStatus(NotificationModel notiModel, String notiId){
    notiModel.isOpened = true;
    unseenNotifications--;
    notiRef.doc(notiId).update({'is_opened': true});
    emit(ChangesNotificationStatus());
  }
}