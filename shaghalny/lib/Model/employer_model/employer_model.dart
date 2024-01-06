import 'package:cloud_firestore/cloud_firestore.dart';

class EmployerModel{
  String id;
  int employees;
  String image;
  List<dynamic> jobs;
  String name;
  dynamic rate;
  String industry;
  Map<String, dynamic> reviews;


  EmployerModel({
    required this.id,
    required this.employees, required this.image, required this.jobs, required this.industry,
      required this.name, required this.rate, required this.reviews});


  EmployerModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        employees = doc.data()!['employees'] ?? 0,
        image = doc.data()!["image"] ?? '',
        jobs = doc.data()!['jobs'] ?? [],
        name = doc.data()!['name'] ?? '',
        industry = doc.data()!['industry'] ?? 'Business',
        rate = doc.data()!['rate'] ?? 0,
        reviews = doc.data()!['reviews'] ?? {};
}