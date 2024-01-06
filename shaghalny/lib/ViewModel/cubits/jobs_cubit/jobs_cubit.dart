import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/androidmanagement/v1.dart';
import 'package:meta/meta.dart';
import 'package:shaghalny/Model/employer_model/employer_model.dart';
import 'package:shaghalny/Model/jobs_model/applied_job_model.dart';
import 'package:shaghalny/ViewModel/cubits/data_cubit/data_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/home_cubit/home_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import 'package:shaghalny/ViewModel/database/cache_helper/cache_helper.dart';
import 'package:shaghalny/utils/dateTime/get_month.dart';
import 'package:shaghalny/utils/job_functions/job_functions.dart';
import 'package:shaghalny/Model/jobs_model/job_model.dart';
import 'package:shaghalny/Model/jobs_model/job_month_model.dart';
import 'package:shaghalny/Model/user_model/user_model.dart';

import '../../../Model/jobs_model/job_year_model.dart';

part 'jobs_state.dart';

class JobsCubit extends Cubit<JobsState> {
  JobsCubit() : super(JobsInitial());

  static JobsCubit get(context) => BlocProvider.of<JobsCubit>(context);


  // all jobs;
  List<AppliedJobModel> jobs = [];
  List<AppliedJobModel> appliedJobsList = [];
  List<AppliedJobModel> approvedJobsList = [];

  List<JobYearModel> appliedJobYearModelList = [];
  List<JobYearModel> approvedJobYearModelList = [];

  CollectionReference jobRef = FirebaseFirestore.instance.collection('jobs');
  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
  CollectionReference employerRef = FirebaseFirestore.instance.collection('employer');

  // fill the 3 arrays
  Future<void> fillJobs(PreferenceCubit preferenceCubit ,context) async {
    emit(FillJobsLoading());
    HomeCubit homeCubit = HomeCubit.get(context);
    print("Here in fillJobs");
    Map<String, dynamic>? list = preferenceCubit.userModel?.jobs ?? {};
    jobs.clear();
    appliedJobYearModelList.clear();
    approvedJobYearModelList.clear();
    appliedJobsList.clear();
    approvedJobsList.clear();
    // fill jobs , appliedJobs ,approvedJobs

    for (final key in list.keys) {
      // extract from firebase (from UserModel)
      final value = list[key];
      List<dynamic> info = [];
      value.forEach((element) {
        info.add(element);
      });

      // building AppliedModel
      int state = int.parse(info[0]);
      Timestamp appliedTime = info[1];

      // now I have job ID
      // i need to get info from JOBS table by job ID (first)
      // to fill JOB Model you to to get employer ID
      DateTime now = DateTime.now();
      DateTime twoMonthAgo = now.subtract(const Duration(days: 60));

      if(appliedTime.toDate().isAfter(twoMonthAgo) || appliedTime.toDate() == twoMonthAgo ){
        var dataCubit = DataCubit.get(context);
        DocumentSnapshot<Map<String, dynamic>> job = await dataCubit.getJobById(key.trim());

        String employerId = job.data()!['employer_id'];
        DocumentSnapshot<Map<String, dynamic>> employer = await dataCubit.getEmployerById(employerId);

        JobModel jobModel = JobModel.fromDocumentSnapshot(job, employer);
        String parentId = jobModel.parentID;



        AppliedJobModel model = AppliedJobModel(
          jobModel: jobModel,
          state: int.parse(info[0]),
          month: getMonth(appliedTime.toDate().month),
          year: appliedTime.toDate().year,
          appliedTime: appliedTime,
          approvedTime: (info.length >= 3) ? info[2] : null,
          signture: (info.length >= 4) ? info[3] : null,
        );

        // add model to Job list
        jobs.add(model);

        // filter applied jobs and approved jobs
        // i will never get zero
        //states
        // 0 approved
        // 1 pending
        // 2 declined
        // 3 upcoming
        // 4 sign contract
        // 5 done
        if (model.state == 0 || model.state == 1 || model.state == 2 || model.state == 5) {
          appliedJobsList.add(model);
        }
        else {
          AppliedJobModel copyModel = AppliedJobModel.copy(model);
          copyModel.state = 0;
          appliedJobsList.add(copyModel);
          approvedJobsList.add(model);
        }
      }
      else{
        //don't take it with the list
        continue;
      }
    }

    // build the tree
    appliedJobYearModelList  = JobFunctions.execute(appliedJobsList);
    approvedJobYearModelList = JobFunctions.execute(approvedJobsList);
    emit(FillJobsSuccess());
    return;
  }


  int isInJobs(String id) {
    for (final key in jobs) {
      if (key.jobModel.jobId == id) {
        print(key.state);
        return key.state;
      }
    }
    return -1;
  }

  // int sign contract screen
  void changeApprovedJobState(String jobId, String signture) {
    for (var i in approvedJobYearModelList) {
      i.monthsList.forEach((element) {
        element.jobList.forEach((element) {
          if (element.jobModel.jobId == jobId) {
            element.state = 3; // upcoming
            element.signture = signture;
            print("state modified");
          }
        });
      });
    }
    emit(ChangeApprovedJobStateSuccess());
  }

  // add to appliedJobs in apply for job screen
  void addToAppliedJobs(JobModel model)  {
    print("add to jobs function");
    AppliedJobModel appliedJobModel = AppliedJobModel(
      jobModel: model,
      appliedTime: Timestamp.now(),
      state: 1,
      month: getMonth(Timestamp.now().toDate().month),
      year: Timestamp.now().toDate().year,
    );
    appliedJobsList.add(appliedJobModel);
    jobs.add(appliedJobModel);
    appliedJobYearModelList = JobFunctions.execute(appliedJobsList);
    print("Size : ${appliedJobsList.length}");
    emit(AddToAppliedJobsSuccess());
  }

// delete from applied jobs
  Future<void> deleteJob({required String jobId, required context , required bool removeFromApplied ,required bool removeFromApproved})async{
    //Delete from App local data
    // Delete job Application
    var preferenceCubit = PreferenceCubit.get(context);
    if(removeFromApplied && removeFromApproved){
      jobs.removeWhere((element) => element.jobModel.jobId==jobId);
      appliedJobsList.removeWhere((element) => element.jobModel.jobId==jobId);
      approvedJobsList.removeWhere((element) => element.jobModel.jobId==jobId);
      preferenceCubit.userModel?.jobs?.remove(jobId);
    }else if(removeFromApproved){
      // time ended to sign contract
      // just remove it from approved jobs and
      // change state
      approvedJobsList.removeWhere((element) => element.jobModel.jobId==jobId);
      preferenceCubit.userModel?.jobs?.forEach((key, value) {
        if(key == jobId){
          value[0]=2;
          print("---------Done--------");
        }
      });
      appliedJobsList.forEach((element) {
        if(element.jobModel.jobId==jobId){
          element.state=2;
        }
      });
      jobs.forEach((element) {
        if(element.jobModel.jobId==jobId){
          element.state=2;
        }
      });
    }

    appliedJobYearModelList  = JobFunctions.execute(appliedJobsList);
    approvedJobYearModelList = JobFunctions.execute(approvedJobsList);

    emit(DeleteJobFromCubitSuccess());
  }

  Future<void> deleteJobWhenTimeEnds({required String jobID})async{

    try{
      String uid = CacheHelper.getData(key: 'uid');
      final docRef = FirebaseFirestore.instance.collection('User').doc(uid);

// Update a value in the map field
      List<dynamic> myArray=[];
      await docRef.get().then((doc) {
        myArray = doc.data()?['jobs'][jobID];
        myArray[0]="2";
        print(myArray);
      });

      await docRef.update({
        'jobs.$jobID': myArray,
      });

      emit(DeleteJobWhenTimeEndsSuccess());
    }catch(e){
      print(e.toString());
      emit(DeleteJobWhenTimeEndsFail());
    }
  }

  Future<void> addToJobHistory({required String jobId ,required String userId,required String text})async{
    await userRef.doc(userId).update({'job_history.$jobId':text});
    emit(AddToJobHistorySuccess());
  }

  Future<void> changeJobStateInDataBase({required String uid , required String jobId ,required List<dynamic>list , required String state})async{
    list[0]=state;
    await userRef.doc(uid).update({'jobs.$jobId':list});
    emit(ChangeJobStateSuccess());
  }

  void changeJobStateInAllJobs({required String jobId , required String state}){
    jobs.forEach((element) {
      if(element.jobModel.parentID == jobId){
        element.state=int.parse(state);
      }
    });
  }


}