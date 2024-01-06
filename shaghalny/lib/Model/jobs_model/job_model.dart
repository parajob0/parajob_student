import 'package:cloud_firestore/cloud_firestore.dart';

import '../employer_model/employer_model.dart';

class JobModel {
  String jobId;
  String image;
  List<dynamic> description;
  List<dynamic> requirements;
  EmployerModel employerModel;
  int level;
  String employerId;
  Timestamp startDate;
  Timestamp endDate;
  String location;
  String locationLink;
  String position;
  int salary;
  String city;

  bool isCompound;
  String parentID;

  JobModel({
    required this.jobId,
    required this.image,
    required this.level,
    required this.description,
    required this.requirements,
    required this.employerId,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.locationLink,
    required this.position,
    required this.salary,
    required this.employerModel,
    required this.city,
    required this.isCompound,
    required this.parentID,
  });

  JobModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc,
      DocumentSnapshot<Map<String, dynamic>> employerDoc)
      : jobId = doc.id,
        image = doc.data()!["image"] ?? '',
        position = doc.data()!["position"] ?? '',
        location = doc.data()!["location"] ?? '',
        locationLink = doc.data()!["location_link"] ?? '',
        salary = doc.data()!["price_per_student"] ?? 0,
        startDate = doc.data()!["start_date"] ?? Timestamp(5555555, 555555),
        endDate = doc.data()!["end_date"] ?? Timestamp(5555555, 555555),
        requirements = doc.data()!["requirements"] ?? [],
        description = doc.data()!["description"] ?? [],
        level = doc.data()!["level"] ?? 0,
        employerId = doc.data()!['employer_id'] ?? '',
        city = doc.data()!['city'] ?? '',
        isCompound = doc.data()!['is_compound'] ?? false,
        parentID = doc.data()!['parent_id'] ?? doc.id,
        employerModel = EmployerModel.fromDocumentSnapshot(employerDoc);



}

