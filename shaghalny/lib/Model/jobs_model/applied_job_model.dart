import 'package:cloud_firestore/cloud_firestore.dart';
import 'job_model.dart';

class AppliedJobModel {
  JobModel jobModel;
  int state;
  String month;
  int year;
  Timestamp appliedTime;
  Timestamp? approvedTime;
  String? signture;

  AppliedJobModel(
      {required this.jobModel,
      required this.state,
      required this.month,
      required this.year,
      required this.appliedTime,
      this.approvedTime,
      this.signture,
});

  factory AppliedJobModel.copy(AppliedJobModel model) {
    return AppliedJobModel(
      jobModel: model.jobModel,
      state: model.state,
      month: model.month,
      year: model.year,
      appliedTime: model.appliedTime,
    );
  }
}
