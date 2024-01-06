import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shaghalny/Model/jobs_model/applied_job_model.dart';
import 'package:shaghalny/Model/jobs_model/job_model.dart';
import 'package:shaghalny/Model/jobs_model/job_year_model.dart';
import 'package:shaghalny/Model/user_model/user_model.dart';
import 'package:shaghalny/ViewModel/cubits/data_cubit/data_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import 'package:shaghalny/utils/dateTime/get_month.dart';
import 'package:shaghalny/utils/job_functions/job_functions.dart';

part 'job_history_state.dart';

class JobHistoryCubit extends Cubit<JobHistoryState> {
  JobHistoryCubit() : super(JobHistoryInitial());

  static JobHistoryCubit get(context) =>
      BlocProvider.of<JobHistoryCubit>(context);

  List<AppliedJobModel> jobs = [];
  List<JobYearModel>jobYearModelList= [];

  Future<void> getJobHistory(context) async {
    emit(GetJobHistoryLoading());
    jobs.clear();
    jobYearModelList.clear();
    PreferenceCubit preferenceCubit = BlocProvider.of<PreferenceCubit>(context, listen: false);
    DataCubit dataCubit = BlocProvider.of<DataCubit>(context, listen: false);

    Map<String, dynamic>? jobsIds = preferenceCubit.userModel?.jobHistory ?? {};
    print(jobsIds);
    for (String key in jobsIds.keys) {
      DocumentSnapshot<Map<String, dynamic>> job = await dataCubit.getJobById(key);

      String employerId = job.data()!['employer_id'];
      DocumentSnapshot<Map<String, dynamic>> employer = await dataCubit.getEmployerById(employerId);

      JobModel jobModel = JobModel.fromDocumentSnapshot(job, employer);
      AppliedJobModel model = AppliedJobModel(
        jobModel: jobModel,
        state: 5,
        month: getMonth(jobModel.startDate.toDate().month),
        year: jobModel.startDate.toDate().year,
        appliedTime: jobModel.endDate,
      );
      jobs.add(model);
    }
    jobYearModelList = JobFunctions.execute(jobs);
    emit(GetJobHistorySuccess());
  }
}