import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import '/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../../Model/employer_model/employer_model.dart';
import '../../../Model/jobs_model/job_model.dart';
import '../../../Model/user_model/user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of<HomeCubit>(context);

  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
  CollectionReference jobRef = FirebaseFirestore.instance.collection('jobs');
  CollectionReference employerRef = FirebaseFirestore.instance.collection('employer');

  List<JobModel> allJobModel = [];
  bool gotAllJobs = false;
  // final startAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
  final startAtTimestamp = Timestamp.fromDate(DateTime.now());
  final now = DateTime.now();

  void getAllJobs(PreferenceCubit prefCubit) async {
    // QuerySnapshot<dynamic> snapshot = city != ''
    //     ? await jobRef
    //         .where("level", isLessThan: prefCubit.adminModel!.specialJobsLevel)
    //         .where("city", isEqualTo: city)
    //         .get()
    //     : await jobRef
    //         .where("level", isLessThan: prefCubit.adminModel!.specialJobsLevel)
    //         .get();

    emit(LoadingAllJobs());
    allJobModel.clear();
    debugPrint("\n\n city ==> ${prefCubit.userModel!.city}\n\n");

    QuerySnapshot<dynamic> snapshot = await jobRef
        .where("level", isLessThan: prefCubit.adminModel!.specialJobsLevel)
        .where("city", isEqualTo: prefCubit.userModel!.city)
        .where("is_compound", isEqualTo: false)
        .where("is_approved", isEqualTo: true)
        // .orderBy("level")
        // .orderBy("start_date", descending: true).startAt([startAtTimestamp])
        // .orderBy("start_date").startAt([DateTime(now.year, now.month, now.day, 0, 0, 0)])
        // .orderBy("start_date").startAt([DateTime(2023, 1, 1, 0, 0, 0)])
        .get();


    List<JobModel> tempJobModel = [];

    debugPrint("\n\nsnapshot length ${snapshot.docs.length} \n\n");

    for (int i = 0; i < snapshot.docs.length; i++) {
      // debugPrint("\n\n job${i+1} ==> ${snapshot.docs[i].id} \n\n");



      if((snapshot.docs[i].data()!['end_date'] as Timestamp).compareTo(startAtTimestamp) >= 0){


        debugPrint("\n\nsnapshot position ${snapshot.docs[i].id} \n\n");

        DocumentSnapshot employerSnapshot = await employerRef
            .doc(snapshot.docs[i].data()!['employer_id'].toString())
            .get();
        if (employerSnapshot.exists) {
          // allJobModel = snapshot.docs
          //     .map((docSnapshot) => JobModel.fromDocumentSnapshot(
          //         docSnapshot as DocumentSnapshot<Map<String, dynamic>>,
          //         employerSnapshot as DocumentSnapshot<Map<String, dynamic>>))
          //     .cast<JobModel>()
          //     .toList();

          tempJobModel.add(JobModel.fromDocumentSnapshot(
              snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>,
              employerSnapshot as DocumentSnapshot<Map<String, dynamic>>));
        }
      }
    }


    // REMOVE JOB MODELS THAT USER IS DECLINED
    for(int i = 0; i < tempJobModel.length; i++){
      if(prefCubit.userModel!.jobs!.containsKey(tempJobModel[i].jobId)){
        if(prefCubit.userModel!.jobs![tempJobModel[i].jobId][0] != 3){
          allJobModel.add(tempJobModel[i]);
        }
      }else{
        allJobModel.add(tempJobModel[i]);
      }
    }

    if(Platform.isAndroid) {
      getRecommendedJobs(prefCubit);
    }

    gotAllJobs = true;
    emit(AllJobsSuccess());
  }

  List<JobModel> highRatedJobModel = [];
  bool gotHighRatedJobs = false;

  void getHighRatedEmployeesJob(PreferenceCubit prefCubit) async {
    // QuerySnapshot<dynamic> snapshot = await jobRef
    //     // .where("start_date", isGreaterThanOrEqualTo: date)
    //     .where("level", isLessThan: prefCubit.adminModel!.specialJobsLevel)
    //     .orderBy("level")
    //     .orderBy("start_date", descending: true).startAt([startAtTimestamp])
    //     .get();


    // List<JobModel> tempJobModel = [];


    // for(var doc in allJobModel){
    //
    //   if((doc.startDate).compareTo(startAtTimestamp) >= 0){
    //     DocumentSnapshot employerSnapshot = await employerRef
    //         .doc(doc.employerId.toString())
    //         .get();
    //     if (employerSnapshot.exists) {
    //       // tempJobModel.add(JobModel.fromDocumentSnapshot(
    //       //     doc as DocumentSnapshot<Map<String, dynamic>>,
    //       //     employerSnapshot as DocumentSnapshot<Map<String, dynamic>>));
    //
    //       //GET THE LONG AND LAT OF THE JOB LOCATION
    //       debugPrint("\n\n location ${doc.jobId} ==> ${doc.location} \n\n");
    //       List<Location> jobLocations = await locationFromAddress(doc.location);
    //       double jobLong = jobLocations[0].longitude;
    //       double jobLat = jobLocations[0].latitude;
    //       double distance =
    //       Geolocator.distanceBetween(userLat, userLong, jobLat, jobLong);
    //
    //       temp[distance] = doc;
    //
    //       debugPrint("\n\n ${doc.salary} ==> $distance");
    //
    //       count++;
    //     }
    //   }
    // }


    // for (int i = 0; i < snapshot.docs.length; i++) {
    //   DocumentSnapshot employerSnapshot = await employerRef
    //       .doc(snapshot.docs[i].data()!['employer_id'].toString().trim())
    //       .get();
    //   if (employerSnapshot.exists) {
    //     // highRatedJobModel = snapshot.docs
    //     //     .map((docSnapshot) => JobModel.fromDocumentSnapshot(
    //     //         docSnapshot as DocumentSnapshot<Map<String, dynamic>>,
    //     //         employerSnapshot as DocumentSnapshot<Map<String, dynamic>>))
    //     //     .cast<JobModel>()
    //     //     .toList();
    //
    //     tempJobModel.add(JobModel.fromDocumentSnapshot(
    //         snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>,
    //         employerSnapshot as DocumentSnapshot<Map<String, dynamic>>));
    //   }
    // }
    //
    // // REMOVE JOB MODELS THAT USER IS DECLINED
    // for(int i = 0; i < tempJobModel.length; i++){
    //   if(prefCubit.userModel!.jobs!.containsKey(tempJobModel[i].jobId)){
    //     if(prefCubit.userModel!.jobs![tempJobModel[i].jobId][0] != 3){
    //       highRatedJobModel.add(tempJobModel[i]);
    //     }
    //   }else{
    //     highRatedJobModel.add(tempJobModel[i]);
    //   }
    // }


    highRatedJobModel = allJobModel;
    highRatedJobModel
        .sort((a, b) => b.employerModel.rate.compareTo(a.employerModel.rate));

    gotHighRatedJobs = true;

    emit(GetHighRatedJobSuccess());
  }

  List<JobModel> recommendedJobModel = [];
  bool gotRecommendedJobs = false;

  void getRecommendedJobs(PreferenceCubit prefCubit) async {
    recommendedJobModel.clear();
    gotRecommendedJobs = false;
    List<Location> userLocations = await locationFromAddress("${prefCubit.userModel!.area}, ${prefCubit.userModel!
        .city}, Egypt");
    double userLong = userLocations[0].longitude;
    double userLat = userLocations[0].latitude;

    debugPrint("\n\n longitude ==> $userLong");
    debugPrint("latitude ==> $userLat \n\n");

    Map<double, JobModel> temp = {};

    // QuerySnapshot<dynamic> snapshot = await jobRef
    //     // .where("start_date", isEqualTo: date)
    //     .where("level", isLessThan: prefCubit.adminModel!.specialJobsLevel)
    //     .orderBy("level")
    //     // .orderBy("start_date", descending: true).startAt([startAtTimestamp])
    //     .get();

    debugPrint("\n\n\n user level ==> ${prefCubit.adminModel!.specialJobsLevel}");

    List<JobModel> tempJobModel = [];


    // for(var doc in snapshot.docs){
    //
    //   if((doc.data()!['start_date'] as Timestamp).compareTo(startAtTimestamp) >= 0){
    //     DocumentSnapshot employerSnapshot = await employerRef
    //         .doc(doc.data()!['employer_id'].toString())
    //         .get();
    //     if (employerSnapshot.exists) {
    //       tempJobModel.add(JobModel.fromDocumentSnapshot(
    //           doc as DocumentSnapshot<Map<String, dynamic>>,
    //           employerSnapshot as DocumentSnapshot<Map<String, dynamic>>));
    //
    //       //GET THE LONG AND LAT OF THE JOB LOCATION
    //       debugPrint("\n\n location ${doc.id} ==> ${doc.data()!["location"]} \n\n");
    //       List<Location> jobLocations = await locationFromAddress(
    //           "${doc.data()!["location"]}");
    //       double jobLong = jobLocations[0].longitude;
    //       double jobLat = jobLocations[0].latitude;
    //       double distance =
    //       Geolocator.distanceBetween(userLat, userLong, jobLat, jobLong);
    //
    //       temp[distance] = tempJobModel[count];
    //
    //       debugPrint("\n\n ${tempJobModel[count].salary} ==> $distance");
    //
    //       count++;
    //     }
    //   }
    // }


    debugPrint("\n\n length ${allJobModel.length} \n\n");
    for(var doc in allJobModel){

      // debugPrint("/n/n HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEE \n\n");
      // if((doc.startDate).compareTo(startAtTimestamp) >= 0){
        // DocumentSnapshot employerSnapshot = await employerRef
        //     .doc(doc.employerId.toString())
        //     .get();
        // if (employerSnapshot.exists) {
          // tempJobModel.add(JobModel.fromDocumentSnapshot(
          //     doc as DocumentSnapshot<Map<String, dynamic>>,
          //     employerSnapshot as DocumentSnapshot<Map<String, dynamic>>));

          //GET THE LONG AND LAT OF THE JOB LOCATION
          debugPrint("\n\n location ${doc.jobId} ==> ${doc.location} \n\n");
          List<Location> jobLocations = await locationFromAddress("${doc.location}, ${doc.city}, Egypt");
          double jobLong = jobLocations[0].longitude;
          double jobLat = jobLocations[0].latitude;
          double distance =
          Geolocator.distanceBetween(userLat, userLong, jobLat, jobLong);

          temp[distance] = doc;

          debugPrint("\n\n ${doc.salary} ==> $distance");

        // }
      // }
    }

    // tempJobModel.clear();
    var sortedByValueMap = Map.fromEntries(
        temp.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));

    sortedByValueMap.forEach((key, value) async {
      tempJobModel.add(value);
    });

    // REMOVE JOB MODELS THAT USER IS DECLINED
    for(int i = 0; i < tempJobModel.length; i++){
      if(prefCubit.userModel!.jobs!.containsKey(tempJobModel[i].jobId)){
        if(prefCubit.userModel!.jobs![tempJobModel[i].jobId][0] != 3){
          recommendedJobModel.add(tempJobModel[i]);
        }
      }else{
        recommendedJobModel.add(tempJobModel[i]);
      }
    }


    gotRecommendedJobs = true;

    emit(GetRecommendJobSuccess());
  }

  List<JobModel> specialJobsModel = [];
  bool gotSpecialJobs = false;

  void getSpecialJobs(PreferenceCubit prefCubit) async {
    specialJobsModel.clear();
    gotSpecialJobs = false;
    QuerySnapshot<dynamic> snapshot = await jobRef
        .where("level",
        isGreaterThanOrEqualTo: prefCubit.adminModel!.specialJobsLevel)
        .where("city", isEqualTo: prefCubit.userModel!.city)
        .where("is_compound", isEqualTo: false)
        .where("is_approved", isEqualTo: true)
        // .orderBy("level")
        // .orderBy("start_date", descending: true).startAt([startAtTimestamp])
        .get();


    // debugPrint("\nsnapshot special ==> ${snapshot.docs.length} \n");


    List<JobModel> tempJobModel = [];

    for (int i = 0; i < snapshot.docs.length; i++) {


      // debugPrint("\n time stamp => ${(snapshot.docs[i].data()!['end_date'] as Timestamp).compareTo(startAtTimestamp)}\n");

      if((snapshot.docs[i].data()!['end_date'] as Timestamp).compareTo(startAtTimestamp) > 0){
        DocumentSnapshot employerSnapshot = await employerRef
            .doc(snapshot.docs[i].data()!['employer_id'].toString())
            .get();

        if (employerSnapshot.exists) {
          tempJobModel.add(JobModel.fromDocumentSnapshot(
              snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>,
              employerSnapshot as DocumentSnapshot<Map<String, dynamic>>));
        }
      }
    }



    // REMOVE JOB MODELS THAT USER IS DECLINED
    for(int i = 0; i < tempJobModel.length; i++){
      if(prefCubit.userModel!.jobs!.containsKey(tempJobModel[i].jobId)){
        if(prefCubit.userModel!.jobs![tempJobModel[i].jobId][0] != 3){
          specialJobsModel.add(tempJobModel[i]);
        }
      }else{
        specialJobsModel.add(tempJobModel[i]);
      }
    }

    // debugPrint("\nspecial jobs length ==> ${specialJobsModel.length} \n");

    gotSpecialJobs = true;
    emit(SpecialJobSuccess());
  }


  bool gotNewJobs = false;
  List<JobModel> newJobs = [];
  Map<String, List<JobModel>> newJobMap = {};
  void getNewJobs(PreferenceCubit prefCubit) async {
    newJobMap.clear();
    newJobs.clear();
    gotNewJobs = false;
    QuerySnapshot<dynamic> snapshot = await jobRef
        .where("level", isLessThan: prefCubit.adminModel!.specialJobsLevel)
        .where("is_compound", isEqualTo: true)
        .where("is_approved", isEqualTo: true)
        .get();

    debugPrint("\n\n newjobs snapshot ==> ${snapshot.docs.length}\n\n");


    List<JobModel> tempJobModel = [];

    for (int i = 0; i < snapshot.docs.length; i++) {
      // debugPrint("\n\n job${i+1} ==> ${snapshot.docs[i].id} \n\n");

      if((snapshot.docs[i].data()!['end_date'] as Timestamp).compareTo(startAtTimestamp) >= 0){

        DocumentSnapshot employerSnapshot = await employerRef
            .doc(snapshot.docs[i].data()!['employer_id'].toString())
            .get();
        if (employerSnapshot.exists){

          tempJobModel.add(JobModel.fromDocumentSnapshot(
              snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>,
              employerSnapshot as DocumentSnapshot<Map<String, dynamic>>));
        }
      }
    }


    // REMOVE JOB MODELS THAT USER IS DECLINED
    for(int i = 0; i < tempJobModel.length; i++){
      if(prefCubit.userModel!.jobs!.containsKey(tempJobModel[i].jobId)){
        if(prefCubit.userModel!.jobs![tempJobModel[i].jobId][0] != 3){
          newJobs.add(tempJobModel[i]);
        }
      }else{
        newJobs.add(tempJobModel[i]);
      }
    }

    for(int i = 0; i < newJobs.length; i++){
      if(newJobMap[newJobs[i].parentID] == null){
        newJobMap[newJobs[i].parentID] = [];
      }
      newJobMap[newJobs[i].parentID]!.add(newJobs[i]);
    }

    // for(var key in newJobMap.keys){
    //
    // }

    newJobMap.forEach((key, value){
      value.sort((e1, e2) => e1.startDate.compareTo(e2.startDate));
    });

    debugPrint("\n\n\n newJobMap length ==> ${newJobMap.length} \n\n\n");

    gotNewJobs = true;
    emit(GotNewJobsSuccess());

  }

  String per = "per hour";
  int getSalaryPerHour(JobModel e){

    Duration time = e.endDate.toDate().difference(e.startDate.toDate());

    int timeInDouble = 0;

    if(time.inHours != 0){
      timeInDouble = (time.inHours.floor() / (time.inDays + 1)).floor();
      per = "per hour";
    }
    else{
      timeInDouble = (time.inMinutes.floor() / (time.inDays + 1)).floor();
      per = "per min";
    }

    timeInDouble = (e.salary / timeInDouble).floor();

    return timeInDouble;
  }
}
