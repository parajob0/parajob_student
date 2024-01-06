import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../Model/jobs_model/job_model.dart';

part 'warnings_state.dart';

class WarningsCubit extends Cubit<WarningsState> {
  WarningsCubit() : super(WarningsInitial());

  static WarningsCubit get(context) => BlocProvider.of<WarningsCubit>(context);

  CollectionReference jobRef = FirebaseFirestore.instance.collection('jobs');
  CollectionReference employerRef =
      FirebaseFirestore.instance.collection('employer');

  List<JobModel> jobs = [];
  bool gotWarningJobs = false;

  void getWarnings({required Map<String, dynamic> warnings}) async {
    jobs.clear();

    for (var key in warnings.keys) {
      DocumentSnapshot<dynamic> jobSnapshot = await jobRef.doc(key).get();
      DocumentSnapshot<dynamic> employerSnapshot =
          await employerRef.doc(jobSnapshot.data()!['employer_id']).get();

      jobs.add(JobModel.fromDocumentSnapshot(
          jobSnapshot as DocumentSnapshot<Map<String, dynamic>>,
          employerSnapshot as DocumentSnapshot<Map<String, dynamic>>));
    }

    gotWarningJobs = true;
    emit(GotWarningJobsSuccess());
  }
}
