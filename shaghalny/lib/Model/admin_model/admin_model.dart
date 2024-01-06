import 'package:cloud_firestore/cloud_firestore.dart';

/*class AdminModel {
  static List<String> _city = [];
  static List<String> _area = [];
  static List<String> _university = [];
  static String _supportMail = "";
  static String _supportNumber = "";

  static void setCity(List<String> city) {
    _city = city;
  }

  static void setArea(List<String> area) {
    _area = area;
  }

  static void setUniversity(List<String> university) {
    _university = university;
  }

  static void setSupportMail(String supportMail) {
    _supportMail = supportMail;
  }

  static void setSupportNumber(String supportNumber) {
    _supportNumber = supportNumber;
  }
  static List<String> getCity() => _city;
  static List<String> getArea() => _area;
  static List<String> getUniversity() => _university;
  static String getSupportMail() => _supportMail;
  static String getSupportNumber() => _supportNumber;




}*/


class NewAdminModel{
  String? id;
  List<dynamic> city;
  Map<String,dynamic> area;
  List<dynamic> university;
  String supportMail;
  String supportNumber;
  int specialJobsLevel;
  int leaderLevel;

  NewAdminModel(this.city, this.area, this.university, this.supportMail,
      this.supportNumber, this.specialJobsLevel, this.leaderLevel);

  NewAdminModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        city = doc.data()!["cities"] ?? [],
        area = doc.data()!["area"] ?? {},
        university = doc.data()!["university"] ?? [],
        supportMail = doc.data()!["support_mail"] ?? '',
        supportNumber = doc.data()!["support_number"] ?? '',
        specialJobsLevel = doc.data()!["special_jobs_level"] ?? 0,
        leaderLevel = doc.data()!["leader_level"] ?? 0;

}