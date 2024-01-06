import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../employer_model/employer_model.dart';
import '../jobs_model/job_model.dart';

class NotificationModel {
  String id;
  String type;

  // String employer;
  // String position;
  String jobId;
  Timestamp date;
  bool isOpened;
  JobModel? jobModel;

  // EmployerModel employerModel;

  NotificationModel(
    this.id,
    this.type,
    this.jobId,
    this.date,
    this.isOpened,
    this.jobModel,
    // this.employerModel
  );

  NotificationModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
    DocumentSnapshot<Map<String, dynamic>> jobDoc,
    DocumentSnapshot<Map<String, dynamic>> employerDoc,
  )   : id = doc.id,
        type = doc.data()!['type'] ?? '',
        // employer = doc.data()!["employer"] ?? '',
        // position = doc.data()!['position'] ?? '',
        jobId = doc.data()!['job_id'] ?? '',
        date = doc.data()!['date'] ?? Timestamp(555555, 555555),
        jobModel = JobModel.fromDocumentSnapshot(jobDoc, employerDoc),
        isOpened = doc.data()!['is_opened'] ?? false;

  NotificationModel.withoutJobID(
    DocumentSnapshot<Map<String, dynamic>> doc,
  )   : id = doc.id,
        type = doc.data()!['type'] ?? '',
        // employer = doc.data()!["employer"] ?? '',
        // position = doc.data()!['position'] ?? '',
        jobId = doc.data()!['job_id'] ?? '',
        date = doc.data()!['date'] ?? Timestamp(555555, 555555),
        isOpened = doc.data()!['is_opened'] ?? false;
}
